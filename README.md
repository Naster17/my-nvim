# my-nvim
Do not forget install and use "Nerd Font" :)

```bash
git clone https://github.com/Naster17/my-nvim ~/.config/nvim && nvim
```

On first launch plugins, Mason packages (`chadrc.lua` pkgs) and Treesitter
parsers install automatically. Manual fallback in NeoVim:
```vim
:MasonInstallAll
:TSUpdate
```

System prerequisites: `git`, `curl`, `tar`, a C compiler, `node`, `python3`, `ripgrep`, Rust toolchain (`cargo`), and `tree-sitter` CLI >= 0.26.1.
Missing tools are reported on demand (when you open a file that needs them); `:DepsCheck` lists everything at once.

> Debian/Ubuntu `apt` ships tree-sitter-cli 0.22 which is too old.
> Grab a binary from https://github.com/tree-sitter/tree-sitter/releases
> (e.g. `tree-sitter-linux-x64.gz`) and put it on your `PATH`.
> macOS: `brew install tree-sitter`. Windows: same releases page.

CodeCompanion chat talks to a llama.cpp server. The default is `http://bc250.int:8080`.

Users: change `DEFAULT_LLAMA_URL` at the top of `lua/plugins/codecompanion.lua`,
or override it without editing the config:
```bash
export LLAMA_CPP_URL="http://your-server:8080"
```

The model list and context window come from the server's `/v1/models`.
Pin a model or cap the context window when the server reports a larger one:
```bash
export LLAMA_CPP_MODEL="my-model"
export LLAMA_CPP_CONTEXT_WINDOW=64000
```
