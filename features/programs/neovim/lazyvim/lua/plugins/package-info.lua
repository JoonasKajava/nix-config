return {
  {
    "vuki656/package-info.nvim",
    lazy = true,
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("package-info").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return require("package-info").get_status()
        end,
        cond = function()
          return require("package-info").get_status() ~= nil
        end,
      })
    end,
  },
}
