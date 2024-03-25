return {
  {
    "michaelb/sniprun",
    branch = "master",

    build = "sh install.sh 1",
    -- do 'sh install.sh 1'​【30 cm】 if you want to force compile locally
    -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

    config = function()
      require("sniprun").setup({
        selected_interpreters = { "Python3_fifo" },
        repl_enable = { "Python3_fifo" },
        display = {
          "VirtualText",
          "VirtualTextOk",
        },
      })
    end,
  },
}
