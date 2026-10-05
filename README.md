# my-nvim

System prerequisites: `git`, `curl`, a C compiler, `node`, `python3`, `ripgrep`, Rust toolchain.

```bash
git clone https://github.com/Naster17/my-nvim ~/.config/nvim && nvim
```

On first launch plugins, Mason packages (`chadrc.lua` pkgs) and Treesitter
parsers install automatically. Manual fallback in NeoVim:
```vim
:MasonInstallAll
:TSUpdate
```
