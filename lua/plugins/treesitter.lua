return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  lazy = false,
  priority = 100,
  build = ":TSUpdate",

  config = function()
    local parser_install_dir = vim.fn.stdpath "data" .. "/site"
    vim.opt.runtimepath:prepend(parser_install_dir)

    -- Work around a markdown injection crash in Neovim 0.12.x by
    -- disabling markdown -> markdown_inline injected trees.
    vim.treesitter.query.set("markdown", "injections", "")

    require("nvim-treesitter.configs").setup {
      parser_install_dir = parser_install_dir,
      ensure_installed = {
        "asm",
        "c",
        "cpp",
        "make",
        "cmake",
        "llvm",
        "nasm",
        "zig",
        "rust",
        "python",
        "lua",
        "bash",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "diff",
        "doxygen",
        "http",
        "html",
        "css",
        "json",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "gitattributes",
        "ruby",
        "sql",
        "ssh_config",
        "tmux",
        "xml",
        "yaml",
      },
      sync_install = false,
      auto_install = true,

      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    }
  end,
}
