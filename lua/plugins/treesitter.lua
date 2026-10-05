return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",

  config = function()
    local parser_install_dir = vim.fn.stdpath "data" .. "/site"
    vim.opt.runtimepath:prepend(parser_install_dir)

    local parsers = {
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
      "qmljs",
      "sql",
      "ssh_config",
      "tmux",
      "xml",
      "yaml",
    }

    local ok, ts = pcall(require, "nvim-treesitter")
    if ok and ts.setup and ts.install then
      ts.setup {
        install_dir = parser_install_dir,
      }

      local installed_ok, installed = pcall(ts.get_installed)
      local missing = parsers
      if installed_ok and type(installed) == "table" then
        local have = {}
        for _, lang in ipairs(installed) do
          have[lang] = true
        end
        missing = {}
        for _, lang in ipairs(parsers) do
          if not have[lang] then
            missing[#missing + 1] = lang
          end
        end
      end

      if #missing > 0 then
        if vim.fn.executable "tree-sitter" == 1 then
          ts.install(missing)
        else
          vim.schedule(function()
            vim.notify(
              "[nvim-treesitter] `tree-sitter` CLI not found (>= 0.26.1 needed to build some parsers). "
                .. "Install it from https://github.com/tree-sitter/tree-sitter/releases and run `:TSUpdate`.",
              vim.log.levels.WARN
            )
          end)
        end
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
        local ok2, ts2 = pcall(require, "nvim-treesitter")
        if ok2 and ts2 and ts2.indentexpr then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
