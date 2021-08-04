local vim = vim

-- require("go.format").gofmt() -- format only
-- require("go.format").goimport() -- goimport + gofmt

-- Format on save
-- vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').gofmt() ]], false)

-- Import on save
-- vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)
