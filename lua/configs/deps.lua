local M = {}

local function has(exe)
  return vim.fn.executable(exe) == 1
end

local function has_c_compiler()
  for _, cc in ipairs { "cc", "gcc", "clang", "cl" } do
    if has(cc) then
      return true
    end
  end
  return false
end

local tools = {
  { name = "git", hint = "https://git-scm.com/downloads" },
  { name = "curl", hint = "https://curl.se/download.html" },
  { name = "tar", hint = "ships with macOS, Windows 10+ and most Linux distros" },
  { name = "node", hint = "https://nodejs.org" },
  { name = "python3", hint = "https://www.python.org/downloads" },
  { name = "rg", hint = "https://github.com/BurntSushi/ripgrep#installation" },
  {
    name = "tree-sitter (>= 0.26.1)",
    exe = "tree-sitter",
    hint = "https://github.com/tree-sitter/tree-sitter/releases",
  },
  { name = "cargo", hint = "https://rustup.rs" },
}

function M.check()
  local missing = {}
  for _, t in ipairs(tools) do
    if not has(t.exe or t.name) then
      missing[#missing + 1] = "- " .. t.name .. ": " .. t.hint
    end
  end
  if not has_c_compiler() then
    missing[#missing + 1] =
      "- C compiler (Debian/Ubuntu: sudo apt install build-essential, macOS: xcode-select --install, Windows: MSVC Build Tools)"
  end
  if #missing > 0 then
    vim.notify("[deps] Missing system dependencies:\n" .. table.concat(missing, "\n"), vim.log.levels.WARN)
  end
  return missing
end

local warned = {}

function M.need(exe, label, hint)
  if has(exe) then
    return true
  end
  if not warned[exe] then
    warned[exe] = true
    vim.schedule(function()
      vim.notify("[deps] `" .. exe .. "` not found, needed for " .. label .. ". Install: " .. hint, vim.log.levels.WARN)
    end)
  end
  return false
end

vim.api.nvim_create_user_command("DepsCheck", function()
  M.check()
end, { desc = "Check system dependencies" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  once = true,
  callback = function()
    M.need("cargo", "Rust tooling", "https://rustup.rs")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "Cargo.toml",
  once = true,
  callback = function()
    M.need("cargo", "crates.nvim", "https://rustup.rs")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  once = true,
  callback = function()
    M.need("node", "TypeScript/JavaScript LSP", "https://nodejs.org")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  once = true,
  callback = function()
    M.need("python3", "Python LSP", "https://www.python.org/downloads")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "platformio.ini",
  once = true,
  callback = function()
    if not has "pio" then
      M.need("pio", "PlatformIO", "https://docs.platformio.org/en/latest/core/installation/index.html")
    end
  end,
})

return M
