return {
  -- {
  --   "anurag3301/nvim-platformio.lua",
  --   lazy = false,
  --   dependencies = {
  --     { "akinsho/nvim-toggleterm.lua" },
  --     { "nvim-telescope/telescope.nvim" },
  --     { "nvim-lua/plenary.nvim" },
  --   },
  --   config = "configs.platformio",
  -- },
  {
    "mrcjkb/rustaceanvim",
    version = "^7", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    "ggml-org/llama.vim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.llama_config = {
        auto_fim = false,
        show_info = 1,
        endpoint_fim = "http://192.168.1.104:8080/infill",
        -- model = "",
        -- t_max_prompt_ms = 1000, -- not supported
        n_prefix = 256,
        n_suffix = 64,
        t_max_predict_ms = 5000,
        n_predict = 512, -- default 128
        max_cache_keys = 250, -- default 250
        enable_at_startup = false,
        ring_update_ms = 1000,
        keymap_fim_trigger = "<C-F>",
        keymap_fim_accept_full = "<Enter>",
        keymap_fim_accept_line = "<C-G>",
        keymap_fim_accept_word = "<C-B>",
      }
    end,
  },
  {
    "mbbill/undotree",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.undotree_WindowLayout = 4
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SplitWidth = 35
      vim.g.undotree_DiffpanelHeight = 12
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
    keys = {
      { "<C-u>", "<cmd>UndotreeToggle<CR>", { silent = true, desc = "Open UndoTree" } },
      -- { "<Esc>", "<cmd>UndotreeHide<CR>",   desc = "Hide UndoTree" }
    },
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
    opts = {
      focus = true,
    },
    cmd = "Trouble",
    keys = {
      { "<leader>tw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
      { "<leader>td", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble document diagnostics" },
      { "<leader>tq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
      { "<leader>tl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
      { "<leader>tt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
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
        "astro",
        "awk",
        "csv",
        "printf",
        "ninja",
        "objdump",
        "kconfig",
        "linkerscript",
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
    },
  },
}
