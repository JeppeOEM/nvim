local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" -- installs lazy if not installed
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({ { import = "mrqdt.plugins" }, { import = "mrqdt.plugins.lsp" } }, {
  -- lazy settings
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
