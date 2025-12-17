return {
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
        },
        opts = {
            -- lsp_keymaps = false,
            -- other options
        },
        config = function(lp, opts)
            require("go").setup(opts)

            local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
            local gopls_cfg = require('go.lsp').config()
            gopls_cfg.settings.gopls.buildFlags = {"-tags=integration,bdd,e2e"}
            gopls_cfg.settings.warn_test_name_dupes = false
            vim.lsp.config.gopls = gopls_cfg
            vim.lsp.enable('gopls')

            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    require('go.format').goimports()
                end,
                group = format_sync_grp,
            })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    }
}
