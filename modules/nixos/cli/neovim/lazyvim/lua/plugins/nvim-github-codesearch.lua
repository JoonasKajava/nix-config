-- TODO: This does not work currently since build for this fails

return {
  {
    "napisani/nvim-github-codesearch",
    build = "make",
    config = function()
      local gh_search = require("nvim-github-codesearch")
      gh_search.setup({
        use_telescope = true,
      })
      vim.keymap.set("n", "<leader>fs", "<cmd>lua require('nvim-github-codesearch').prompt()<CR>", {
        desc = "Find From Github",
      })
    end,
  },
}
