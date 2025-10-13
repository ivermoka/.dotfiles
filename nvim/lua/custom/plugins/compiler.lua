return {
  {
    'Zeioth/compiler.nvim',
    cmd = { 'CompilerOpen', 'CompilerToggleResults', 'CompilerRedo' },
    dependencies = { 'stevearc/overseer.nvim' },
    opts = {},
  },
  --- Task Runner
  {
    'stevearc/overseer.nvim',
    cmd = { 'CompilerOpen', 'CompilerToggleResults', 'CompilerRedo' },
    opts = {
      task_list = {
        direction = 'bottom',
        min_height = 10,
        max_height = 15,
        default_detail = 1,
      },
    },
  },
}
