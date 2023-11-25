return {
  {'mhartington/formatter.nvim',
  config = function ()
    local util = require "formatter.util"

    -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
    require("formatter").setup {
      -- Enable or disable logging
      logging = true,
      -- Set the log level
      log_level = vim.log.levels.WARN,
      -- All formatter configurations are opt-in
      filetype = {
        elixir = {
          require("formatter.filetypes.elixir").mixformat
        },
        lua = {
          require("formatter.filetypes.lua").stylua
        },
        -- Use the special "*" filetype for defining formatter configurations on
        -- any filetype
        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace
        }
      }
    }

    -- format on save, unless disabled
    local format_group = vim.api.nvim_create_augroup('FormatAutogroup', { clear = true })
    vim.api.nvim_create_autocmd('BufWritePost', {
      callback = function()
        if not vim.b.format_disable then
          vim.cmd('FormatWriteLock')
        end
      end,
      group = format_group,
      pattern = '*',
    })

    vim.api.nvim_create_user_command('FormatDisable', function() vim.b.format_disable = true end, {desc = 'Temporary disable autoformat on write for current buffer'})
    vim.api.nvim_create_user_command('FormatEnable', function() vim.b.format_disable = false end, {desc = 'Enable autoformat on write for current buffer (if it was previously disabled)'})
  end
  }
}
