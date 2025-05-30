return {
    {
        'datsfilipe/vesper.nvim',
        opts = {
            transparent = true,
            italics = {
                comments = true, -- Boolean: Italicizes comments
                keywords = true, -- Boolean: Italicizes keywords
                functions = true, -- Boolean: Italicizes functions
                strings = true, -- Boolean: Italicizes strings
                variables = true, -- Boolean: Italicizes variables
            },
            overrides = {}, -- A dictionary of group names, can be a function returning a dictionary or a table.
            palette_overrides = {}
        }
    },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 }
}
