return {
  {'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
  config = function ()
    require('ibl').setup {
      indent = { char = '┊' },
      exclude = {
        filetypes = { 'help' },
        buftypes = { 'terminal', 'nofile' },
      }
    }
  end
  }
}
