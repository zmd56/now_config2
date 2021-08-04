#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# quickswitch for i3 - quickly change to and locate windows in i3.
#
# Maintainer: OliverUv <OliverUv@Github, oliver.uvman+quickswitch@gmail.com>
# Original author: slowpoke <mail+python at slowpoke dot io>
# This program is Free Software under the terms of the
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.


import os
import re
import sys
import argparse
import subprocess
import shutil

try:
    import i3
except ImportError:
    print("quickswitch requires i3-py.")
    print("You can install it from the PyPI with ``pip install i3-py''.")
    sys.exit(os.EX_UNAVAILABLE)

# Must use semver 2.0.0
__version__ = "2.7.0"

workspace_number_re = re.compile("^(?P<number>\d+)(?P<name>.*)")
default_dmenu_command = "dmenu -b -i -l 20"
window_class_ignore_list = []
follow = False
follow_if_empty = False


def check_dmenu():
    """Check if dmenu is available."""
    return bool(shutil.which("dmenu"))


def dmenu(options, dmenu):
    """Call dmenu with a list of options."""

    cmd = subprocess.Popen(dmenu,
                           shell=True,
                           stdin=subprocess.PIPE,
                           stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE)
    stdout, _ = cmd.communicate("\n".join(options).encode("utf-8"))
    return stdout.decode("utf-8").strip("\n")


def get_windows():
    """Get all windows."""
    windows = parse_for_windows(i3.get_tree(), [])
    return create_lookup_table(windows)


def parse_for_windows(tree_dict, window_list):
    is_leaf_node = False

    if ("nodes" in tree_dict and len(tree_dict["nodes"]) > 0):
        is_leaf_node = True
        for node in tree_dict["nodes"]:
            parse_for_windows(node, window_list)

    if ("floating_nodes" in tree_dict and
       len(tree_dict["floating_nodes"]) > 0):
        is_leaf_node = True
        for node in tree_dict["floating_nodes"]:
            parse_for_windows(node, window_list)

    if not is_leaf_node:
        if (tree_dict["layout"] != "dockarea" and
           not tree_dict["window"] is None):
            window_list.append(tree_dict)

    return window_list


def find_window_by_regex(regex, insensitive=False, move=False):
    """
    Find the first window whose title matches regex
    and focus or move it.
    """
    action = move_window_here if move else focus

    if insensitive:
        cr = re.compile(regex, re.I)
    else:
        cr = re.compile(regex)
    for win_name, win_id in get_windows().items():
        if cr.match(win_name):
            action(win_id)
            return True
    return False


def find_workspace_by_regex(regex, insensitive=False):
    """
    Find the first workspace whose title matches regex
    and move the current container to it.
    """
    action = move_container_to_workspace

    if insensitive:
        cr = re.compile(regex, re.I)
    else:
        cr = re.compile(regex)
    for title in get_workspaces().keys():
        if cr.match(title):
            action(title)
            return True
    return False


def get_scratchpad():
    """Get all windows on the scratchpad."""
    scratchpad = i3.filter(name="__i3_scratch")[0]
    nodes = scratchpad["floating_nodes"]
    windows = i3.filter(tree=nodes, nodes=[])
    return create_lookup_table(windows)


def workspace_is_numbered(ws_name):
    match = workspace_number_re.match(ws_name)
    return not not match


def get_workspace_number(ws_name):
    match = workspace_number_re.match(ws_name)
    if not match:
        return 0
    return int(match.group("number"))


def get_workspace_numbers(ws_names):
    return [get_workspace_number(ws) for ws in ws_names
            if workspace_is_numbered(ws)]


def workspace_name_from_number(ws_number):
    ws_names = get_workspaces().keys()
    for ws in ws_names:
        if workspace_is_numbered(ws):
            if (ws_number == get_workspace_number(ws)):
                return ws
    return ws_number


def get_workspaces():
    """
    Returns all workspace names.

    NOTE: This returns a map of name → name, which is rather redundant, but
    makes it possible to use the result without changing much in main().
    """
    workspaces = i3.get_workspaces()
    for ws in workspaces:
        # create_lookup_table will set the value of all entries
        # in the lookup table to the window id. We act as if the
        # workspace name is the window id.
        ws["window"] = ws["name"]
    return create_lookup_table(workspaces)


def first_empty():
    """Return the lowest numbered workspace that is empty."""
    workspaces = sorted(get_workspace_numbers(get_workspaces().keys()))
    for i in range(len(workspaces)):
        if workspaces[i] != i + 1:
            return str(i + 1)
    return str(len(workspaces) + 1)


def next_empty():
    """
    Return the lowest numbered workspace that is empty,
    and higher than the current workspace.
    """
    current_workspace = get_current_workspace()
    current_num = get_workspace_number(current_workspace)
    workspaces = get_workspace_numbers(get_workspaces().keys())
    potential_target = current_num + 1
    while True:
        if potential_target not in workspaces:
            return str(potential_target)
        potential_target += 1
    return str(potential_target)


def next_used(number):
    """Return the next used numbered workspace after the given number."""
    ws_numbers = get_workspace_numbers(get_workspaces().keys())
    workspaces = sorted([ws for ws in ws_numbers if ws > number])
    return workspace_name_from_number(workspaces[0]) if workspaces else None


def degap():
    """
    Remove ``gaps'' in the numbered workspaces.

    This searches for non-consecutive numbers in the workspace list, and moves
    used workspaces as far to the left as possible.

    """
    i = 0
    while True:
        ws = next_used(i)
        if ws is None:
            break
        ws_num = get_workspace_number(ws)
        if ws_num - i > 1:
            rename_workspace(ws, i + 1)
        i += 1


def get_lookup_title(window):
    """Get the lookup title for a window."""
    parts = window.get("name").split(" - ")
    wclass = window.get("window_properties", {}).get("class")
    mark = window.get("mark")
    if wclass:
        parts = [part for part in parts if part.lower() != wclass.lower()]
        parts.insert(0, wclass)
    title = " - ".join(parts)
    if mark:
        title += " [{}]".format(mark)
    return title


def create_lookup_table(windows):
    """
    Create a lookup table from the given list of windows.

    The returned dict is in the format window title → X window id.
    """
    rename_nonunique(windows)
    lookup = {}
    for window in windows:
        win_name = window.get("name")
        win_id = window.get("window")
        win_class = ""
        if (window.get("window_properties") and
           window["window_properties"].get("class")):
            win_class = window["window_properties"]["class"]
        if win_id is None:
            # this is not an X window, ignore it.
            continue
        if win_name.startswith("i3bar for output"):
            # this is an i3bar, ignore it.
            continue
        ignore_window = False
        for cn in window_class_ignore_list:
            if win_class == cn:
                ignore_window = True
                break
        if ignore_window:
            continue
        win_name = get_lookup_title(window)
        if win_name in lookup:
            # duplicate name of previous window
            # add "(win_id)" as suffix in attempt to make unique
            win_name = "{} ({})".format(win_name, str(win_id))
        lookup[win_name] = win_id
    return lookup


def rename_nonunique(windows):
    """Rename all windows which share a name by appending an index."""
    window_names = [window.get("name") for window in windows]
    for name in window_names:
        count = window_names.count(name)
        if count > 1:
            for i in range(count):
                index = window_names.index(name)
                window_names[index] = "{} [{}]".format(name, i + 1)
    for i in range(len(windows)):
        windows[i]["name"] = window_names[i]


def get_scratchpad_window(window):
    """Does `scratchpad show` on the specified window."""
    return i3.scratchpad("show", id=window)


def move_window_here(window):
    """Does `move workspace current` on the specified window."""
    return i3.msg(0, "{} move workspace current".format(
        i3.container(id=window)))


def move_container_to_workspace(workspace):
    """Moves the current container to the selected workspace"""
    ret = i3.msg(0, "move container to workspace {}".format(workspace))
    if follow or (follow_if_empty and is_current_workspace_empty()):
        goto_workspace(workspace)
    return ret


def rename_workspace(old, new_number):
    """Rename a given workspace."""
    m = workspace_number_re.match(old)
    if not m:
        return
    new = "%d%s" % (new_number, m.group("name"))
    return i3.msg(0, "rename workspace {} to {}".format(old, new))


def focus(window):
    """Focuses the given window."""
    return i3.focus(id=window)


def goto_workspace(name):
    """Jump to the given workspace."""
    return i3.workspace(name)


def get_current_workspace():
    """Get the name of the currently active workspace."""
    filtered = [ws for ws in i3.get_workspaces() if ws["focused"] is True]
    return filtered[0]["name"] if filtered else None


def is_current_workspace_empty():
    """Determines if the current workspace is empty."""
    return i3.filter(nodes=[], type="workspace", focused=True) != []


def cycle_numbered_workspaces(backwards=False):
    """Get the next (previous) numbered workspace."""
    current = get_current_workspace()
    if not workspace_is_numbered(current):
        return None
    i = get_workspace_number(current)

    all_ws_numbers = sorted(get_workspace_numbers(get_workspaces().keys()))

    current_index = all_ws_numbers.index(i)
    target_index = current_index + 1
    if backwards:
        target_index = current_index - 1

    # Wrap around if we'd reach a non-used number
    if target_index >= len(all_ws_numbers):
        target_index = 0
    elif target_index < 0:
        target_index = len(all_ws_numbers) - 1

    target_ws = all_ws_numbers[target_index]

    return str(workspace_name_from_number(target_ws))


def set_ignore_class_list(str_list):
    global window_class_ignore_list
    window_class_ignore_list = str_list.split(",")


def main():
    parser = argparse.ArgumentParser(description="""quickswitch for i3""")

    mutgrp_1 = parser.add_mutually_exclusive_group()
    mutgrp_1.add_argument("-m", "--move", default=False, action="store_true",
                          help="move a chosen window to the current "
                          "workspace or moves the current container "
                          "to the selected workspace")
    mutgrp_1.add_argument("-j", "--journey", default=False,
                          action="store_true",
                          help="moves the current container to a "
                          "chosen workspace or moves it to a new empty "
                          "workspace with -e")

    mutgrp_2 = parser.add_mutually_exclusive_group()
    mutgrp_2.add_argument("-f", "--follow", default=False,
                          action="store_true",
                          help="Follow a moved container to the workspace it is moved to")
    mutgrp_2.add_argument("-F", "--followifempty", default=False,
                          action="store_true",
                          help="Follow a moved container to the workspace it is moved to "
                          "if the current workspace is empty after moving")

    mutgrp_3 = parser.add_mutually_exclusive_group()
    mutgrp_3.add_argument("-s", "--scratchpad", default=False,
                          action="store_true",
                          help="list scratchpad windows instead of "
                          "regular ones")
    mutgrp_3.add_argument("-w", "--workspaces", default=False,
                          action="store_true",
                          help="list workspaces instead of windows")
    mutgrp_3.add_argument("-e", "--empty", default=False,
                          action="store_true",
                          help="go to the first empty, numbered "
                          "workspace. Use with -j to send current "
                          "window to a new empty workspace")
    mutgrp_3.add_argument("-E", "--nextempty", default=False,
                          action="store_true",
                          help="go to the next empty, numbered "
                          "workspace after the current one. Use "
                          "with -j to send current window to a new "
                          "empty workspace")
    mutgrp_3.add_argument("-r", "--regex",
                          help="find the first window matching the "
                          "regex and focus/move it. Finds the first "
                          "matching workspace when used with -j")
    mutgrp_3.add_argument("-g", "--degap", action="store_true",
                          help="make numbered workspaces consecutive "
                          "(remove gaps), does not work with other arguments")
    mutgrp_3.add_argument("-n", "--next", default=False, action="store_true",
                          help="go to the next (numbered) workspace")
    mutgrp_3.add_argument("-p", "--previous", default=False,
                          action="store_true",
                          help="go to the previous (numbered) workspace")
    mutgrp_3.add_argument("-u", "--urgent", default=False,
                          action="store_true",
                          help="go to the first window with the "
                          "urgency hint set")
    mutgrp_3.add_argument("-l", "--launch", default=False,
                          action="store_true",
                          help="if input to dmenu doesn't match any "
                          "given option, send the input to shell for "
                          "interpretation")

    parser.add_argument("-C", "--ignore-classes", default="",
                        help="comma separated list of window classes "
                        "to ignore")
    parser.add_argument("-d", "--dmenu", default=default_dmenu_command,
                        help="dmenu command, executed within a shell")
    parser.add_argument("-i", "--insensitive", default=False,
                        action="store_true",
                        help="make regexps case insensitive")
    parser.add_argument("-o", "--prompt", default=False, action="store_true",
                        help="show a prompt in dmenu describing the "
                        "action to perform")

    args = parser.parse_args()

    global follow
    follow = args.follow
    global follow_if_empty
    follow_if_empty = args.followifempty

    # jumping to the next empty workspaces doesn't require going through all
    # the stuff below, as we don't need to call dmenu etc, so we just call it
    # here and exit if the appropriate flag was given.
    if args.empty or args.nextempty:
        target_ws = first_empty() if args.empty else next_empty()
        if args.journey:
            sys.exit(*move_container_to_workspace(target_ws))
        else:
            sys.exit(*goto_workspace(target_ws))

    # likewise for degapping...
    if args.degap:
        degap()
        sys.exit(os.EX_OK)

    # initialize window_class_ignore_list
    if args.ignore_classes:
        set_ignore_class_list(args.ignore_classes)

    # ...and regex search...
    if args.regex:
        if args.journey:
            if find_workspace_by_regex(args.regex, args.insensitive):
                sys.exit(os.EX_OK)
            else:
                sys.exit(os.EX_NOTFOUND)

        else:
            if find_window_by_regex(args.regex, args.insensitive, args.move):
                sys.exit(os.EX_OK)
            else:
                sys.exit(os.EX_NOTFOUND)

    # ...as well as workspace cycling
    if args.next or args.previous:
        if not workspace_is_numbered(get_current_workspace()):
            print("--next and --previous only work on numbered workspaces")
            sys.exit(1)
        target_ws = cycle_numbered_workspaces(args.previous)
        if not args.move:
            sys.exit(*goto_workspace(target_ws))
        else:
            sys.exit(*i3.command(
                "move container to workspace {}".format(target_ws)))

    if args.urgent:
        urgent_windows = i3.filter(urgent=True, nodes=[])
        try:
            win_id = urgent_windows[0]["window"]
            focus(win_id)
        except IndexError:
            sys.exit(os.EX_SOFTWARE)
        sys.exit(os.EX_OK)

    if args.dmenu == default_dmenu_command and not check_dmenu():
        print("quickswitch requires dmenu.")
        print("Please install it using your distribution's package manager.")
        sys.exit(os.EX_UNAVAILABLE)

    lookup_func = get_windows
    unit = "window"
    if args.scratchpad:
        lookup_func = get_scratchpad
        unit = "scratchpad"
    if args.workspaces:
        lookup_func = get_workspaces
        unit = "workspace"

    action_func = focus
    dmenu_prompt = "focus {}".format(unit)
    if args.move:
        action_func = move_window_here
        dmenu_prompt = "move container to this {}".format(unit)
    elif args.journey:
        lookup_func = get_workspaces
        action_func = move_container_to_workspace
        dmenu_prompt = "move container to workspace"
    else:
        if args.scratchpad:
            action_func = get_scratchpad_window
            dmenu_prompt = "focus {}".format(unit)
        if args.workspaces:
            action_func = goto_workspace
            dmenu_prompt = "focus {}".format(unit)

    lookup = lookup_func()
    dmenu_prompt_args = args.dmenu
    if args.prompt:
        dmenu_prompt_args += " -p '{}'".format(dmenu_prompt)
    target = dmenu(lookup.keys(), dmenu_prompt_args)
    ws_id = lookup.get(target)

    if not ws_id and args.workspaces:
        # For workspace actions, we want to enable users to create new
        # workspaces. Easily done by discarding the lookup result
        # and just use what dmenu handed us to begin with.
        ws_id = target

    if ws_id:
        action_func(ws_id)
    elif target and args.launch:
        subprocess.call(target, shell=True)

    sys.exit(os.EX_OK)


if __name__ == "__main__":
    main()
