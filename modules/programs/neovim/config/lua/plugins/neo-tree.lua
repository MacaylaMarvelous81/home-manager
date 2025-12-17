return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      source_selector = {
        winbar = false,
      },
    },
    --   opts = function(_, opts)
    --     local get_icon = require("astroui").get_icon
    --
    --     if not opts.sources then opts.sources = {} end
    --     table.insert(opts.sources, "document_symbols")
    --
    --     if not opts.source_selector then opts.source_selector = {
    --       sources = {},
    --     } end
    --     if not opts.source_selector.sources then opts.source_selector.sources = {} end
    --
    --     table.insert(
    --       opts.source_selector.sources,
    --       { source = "document_symbols", display_name = get_icon("DefaultFile", 1, true) .. "Symbol" }
    --     )
    --
    --     for i, v in pairs(opts.source_selector.sources) do
    --       if v.source == "buffers" then
    --         table.remove(opts.source_selector.sources, i)
    --         break
    --       end
    --     end
    --   end,
  },
}
