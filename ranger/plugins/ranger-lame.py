from __future__ import (absolute_import, division, print_function)

import os
import subprocess

from ranger.api.commands import Command


class lame_base(Command):
    # The so-called doc-string of the class will be visible in the built-in
    # help that is accessible by typing "?c" inside ranger.
    """:lame_base <filename>

    Not really used directly, so don't!
    """

    # The execute method is called when you run this command in ranger.
    def execute(self):

        # Do the sox stuff
        self.perform_on_selected_files()

        # Unmark files when done
        self.fm.thisdir.mark_all(False)

    def lamecommand(self, fn):
        suffix = "_320"
        newfn = self.filename_with(suffix, fn)

        # The sox operation being used
        param = f"--preset insane"

        # The full command
        command = f"lame {param} '{fn}' '{newfn}'"

        return command

    def filename_with(self, tag, filename, newsuffix=".mp3"):
        from pathlib import Path

        infile = Path(filename)
        fn = Path(infile.stem + tag + newsuffix)
        fn = infile.parent.joinpath(fn)

        return fn

    def perform_on_selected_files(self):
        for file in self.fm.thisdir.get_selection():
            file = file.path

            # Make sure the file exists
            if not os.path.exists(file):
                self.fm.notify("The given file does not exist!", bad=True)
                return

            command = self.lamecommand(file)
            self.fm.notify("Executing: " + command + "!")

            # execute the command
            self.fm.execute_command(
                command,
                universal_newlines=True,
                stdout=subprocess.PIPE)


class mp3insane(lame_base):
    """:mp3insane <filename>

    Convert to mp3 using lame preset "insane", CBR 320KBPS

    This preset will usually be overkill for most  people  and  most
    situations,  but  if  you must have the absolute highest quality
    with no regard to filesize, this is the way to go.

    """

    def lamecommand(self, fn):
        suffix = "_insane"
        newfn = self.filename_with(suffix, fn)

        # The sox operation being used
        param = f"--preset insane"

        # The full command
        command = f"lame {param} '{fn}' '{newfn}'"

        return command


class mp3extreme(lame_base):
    """:mp3extreme <filename>

    Convert to mp3 using lame preset "extreme"

    If you have extremely good hearing and similar  equipment,  this
    preset  will  generally provide slightly higher quality than the
    standard mode.

    """

    def lamecommand(self, fn):
        suffix = "_extreme"
        newfn = self.filename_with(suffix, fn)

        # The sox operation being used
        param = f"--preset extreme"

        # The full command
        command = f"lame {param} '{fn}' '{newfn}'"

        return command


class mp3medium(lame_base):
    """:mp3medium <filename>

    Convert to mp3 using lame preset "medium", VBR mode

    This preset should provide near transparency to most  people  on
    most music.

    """

    def lamecommand(self, fn):
        suffix = "_medium"
        newfn = self.filename_with(suffix, fn)

        # The sox operation being used
        param = f"--preset medium"

        # The full command
        command = f"lame {param} '{fn}' '{newfn}'"

        return command


class mp3(lame_base):
    """:mp3 <filename>

    Convert to mp3 using the standard preset, VBR mode

    This  preset  should  generally be transparent to most people on
    most music and is already quite high in quality.

    """

    def lamecommand(self, fn):
        suffix = "_standard"
        newfn = self.filename_with(suffix, fn)

        # The sox operation being used
        param = f"--preset standard"

        # The full command
        command = f"lame {param} '{fn}' '{newfn}'"

        return command
