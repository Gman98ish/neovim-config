return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "fredrikaverpil/neotest-golang", version = "*" },
      "olimorris/neotest-phpunit",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-golang")({
            warn_test_name_dupes = false,
            go_test_args = { "-tags=integration,bdd,e2e" },
          }),
          require("neotest-phpunit")
        }
      })
    end
  }
}
