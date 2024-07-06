return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      event = "VeryLazy",
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets
    "onsails/lspkind.nvim", -- vs-code like pictograms
  },
  config = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    local ls = require("luasnip")
    -- some shorthands...
    local s = ls.snippet
    local sn = ls.snippet_node
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local c = ls.choice_node
    local d = ls.dynamic_node
    local r = ls.restore_node
    local l = require("luasnip.extras").lambda
    local rep = require("luasnip.extras").rep
    local p = require("luasnip.extras").partial
    local m = require("luasnip.extras").match
    local n = require("luasnip.extras").nonempty
    local dl = require("luasnip.extras").dynamic_lambda
    local fmt = require("luasnip.extras.fmt").fmt
    local fmta = require("luasnip.extras.fmt").fmta
    local types = require("luasnip.util.types")
    local conds = require("luasnip.extras.conditions")
    local conds_expand = require("luasnip.extras.conditions.expand")
    local s = ls.snippet
    local t = ls.text_node
    local f = ls.function_node
    local i = ls.insert_node

    vim.keymap.set({ "i" }, "<A-b>", function()
      ls.expand()
    end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<A-m>", function()
      ls.jump(1)
    end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<A-n>", function()
      ls.jump(-1)
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<A-v>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { silent = true })
    local function copy(args)
      return args[1]
    end

    -- view the vim file type name
    -- :set filetype

    ls.add_snippets("all", {
      s("test", {
        t("Hello, World!"),
        i(1),
        t("This is a test snippet."),
      }),
      s("fn", {
        -- Simple static text.
        t("//Parameters: "),
        -- function, first parameter is the function, second the Placeholders
        -- whose text it gets as input.
        f(copy, 2),
        t({ "", "function " }),
        -- Placeholder/Insert.
        i(1),
        t("("),
        -- Placeholder with initial text.
        i(2, "int foo"),
        -- Linebreak
        t({ ") {", "\t" }),
        -- Last Placeholder, exit Point of the snippet.
        i(0),
        t({ "", "}" }),
      }),
      s("class", {
        -- Choice: Switch between two different Nodes, first parameter is its position, second a list of nodes.
        c(1, {
          t("public "),
          t("private "),
        }),
        t("class "),
        i(2),
        t(" "),
        c(3, {
          t("{"),
          -- sn: Nested Snippet. Instead of a trigger, it has a position, just like insertNodes. !!! These don't expect a 0-node!!!!
          -- Inside Choices, Nodes don't need a position as the choice node is the one being jumped to.
          sn(nil, {
            t("extends "),
            -- restoreNode: stores and restores nodes.
            -- pass position, store-key and nodes.
            r(1, "other_class", i(1)),
            t(" {"),
          }),
          sn(nil, {
            t("implements "),
            -- no need to define the nodes for a given key a second time.
            r(1, "other_class"),
            t(" {"),
          }),
        }),
        t({ "", "\t" }),
        i(0),
        t({ "", "}" }),
      }),
      s("if", {
        t("if "),
        i(1, "true"),
        t(" then "),
        i(2),
        t(" end"),
      }),
    })

    ls.add_snippets("javascript", {
      s("textest", {
        t("Hello, World!"),
        i(1),
        t("This is a test snippet."),
      }),
      s(
        "beg",
        fmt(
          [[
      \begin{{{}}}
      {}
      \end{{{}}}
      ]],
          {
            i(1),
            i(2),
            rep(3),
          }
        )
      ),
    })
    ls.add_snippets("java", {
      s(
        "logc",
        fmt([[Debug.Log($"<color={}>{}</color>");]], {
          c(1, {
            t("red"),
            t("green"),
            t("blue"),
            t("cyan"),
            t("magenta"),
          }),
          i(2),
        })
      ),
    })

    ls.add_snippets("typescriptreact", {

      -- 1st version
      s("co", {
        t("position(["),
        f(function()
          local register_data = vim.fn.getreg() .. ""
          if string.match(register_data, "[%d-]+,%s*[%d-]+") then
            return register_data
          else
            print("register does not contain the pattern")
          end
        end),
        t("])"),
      }),

      s("co2", {
        d(function()
          local register_data = vim.fn.getreg() .. ""
          if string.match(register_data, "[%d-]+,%s*[%d-]+") then
            return M.sn(nil, {
              M.t("position([" .. register_data .. "])"),
            })
          else
            print("register does not contain the pattern")
            return M.sn(nil, {})
          end
        end),
        i(1),
      }),
    })

    -- require("luasnip.loaders.from_vscode").load({ paths = { "~/.config/nvim/lua/mrqdt/snippets.lua" } }) -- Load snippets from my-snippets folder

    -- You can also use lazy loading so you only get in memory snippets of languages you use
    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    -- require("luasnip.loaders.from_vscode").lazy_load()
    -- require("luasnip.loaders.from_vscode").load({ paths = ".~/.config/nvim/snippets" })
    -- require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })
    -- load snippets from path/of/your/nvim/config/my-cool-snippets
    --require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/.config/nvim/lua/mrqdt/snippets/my-cool-snippets" } })
    -- require("luasnip.loaders.from_snipmate").lazy_load()
    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          ls.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
      -- sources for autocompletion
      -- order is important
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" }, -- file system paths
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current: buffer
      }),

      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      },
    })
  end,
}
