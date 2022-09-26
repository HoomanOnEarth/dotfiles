-- auto install packer.nvim
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  vim.api.nvim_command("packadd packer.nvim")
end

-- bootstrap
local layers = {
	require "me.options",
    require "me.system",
    require "me.ui",
    require "me.finder",
}

local packer = require("packer")
local use = packer.use

packer.startup(function()
  use("wbthomason/packer.nvim")

  for _, layer in pairs(layers) do
    if layer.plugins ~= nil then
      layer.plugins(use)
    end
  end
end)

for _, layer in pairs(layers) do
  if layer.setup ~= nil then
    layer.setup()
  end
end

local map = vim.keymap.set
for _, layer in pairs(layers) do
  if layer.bindings ~= nil then
    layer.bindings(map)
  end
end
