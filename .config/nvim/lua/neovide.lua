vim.o.guifont = "Source Code Pro:h10"
-- vim.g.neovide_padding_top = 0
-- vim.g.neovide_padding_bottom = 0
-- vim.g.neovide_padding_right = 0
-- vim.g.neovide_padding_left = 0
-- vim.g.neovide_transparency = 0.8
vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_cursor_trail_size = 0.4

vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set("n", "<C-=>", function()
  change_scale_factor(1.25)
end)
vim.keymap.set("n", "<C-->", function()
  change_scale_factor(1/1.25)
end)
