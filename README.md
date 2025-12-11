# wobble.nvim

Neovim plugin for switching between files with similar names

## Primary use

- switch between header and source files

# Requirements

- Neovim 0.10+

# Quick Start

Using lazy.nvim:

```lua
{
    "Lukas-Fohl/wobble.nvim",
    config = function()
        require("wobble").setup({
            source_exts = { "c", "cpp", "cc", "cxx", "m", "mm", "c++" },
            header_exts = { "h", "hpp", "hh", "hxx", "h++" },
            search_paths = { ".", "./src", "./include", "./../src", "./../include" }
        })
        vim.keymap.set("n", "<leader>w", "<cmd>Wobble<CR>")
    end
}

```

