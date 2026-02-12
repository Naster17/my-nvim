return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  lazy = false,
  priority = 100,
  build = ":TSUpdate",

  config = function()
    require("nvim-treesitter.configs").setup {
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
        "diff",
        "doxygen",
        "http",
        "html",
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
