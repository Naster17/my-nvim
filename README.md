# my-nvim

System prerequisites: `git`, `curl`, `tar`, a C compiler, `node`, `python3`, `ripgrep`, Rust toolchain (`cargo`), and `tree-sitter` CLI >= 0.26.1.
Missing tools are reported on demand (when you open a file that needs them); `:DepsCheck` lists everything at once.

> Debian/Ubuntu `apt` ships tree-sitter-cli 0.22 which is too old.
> Grab a binary from https://github.com/tree-sitter/tree-sitter/releases
> (e.g. `tree-sitter-linux-x64.gz`) and put it on your `PATH`.
> macOS: `brew install tree-sitter`. Windows: same releases page.

```bash
git clone https://github.com/Naster17/my-nvim ~/.config/nvim && nvim
```

On first launch plugins, Mason packages (`chadrc.lua` pkgs) and Treesitter
parsers install automatically. Manual fallback in NeoVim:
```vim
:MasonInstallAll
:TSUpdate
```

CodeCompanion chat talks to a local llama.cpp server (default `http://127.0.0.1:8080`).
Point it at another machine with:
```bash
export LLAMA_CPP_URL="http://192.168.1.104:8080"
```
