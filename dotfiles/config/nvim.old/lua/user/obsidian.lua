local function utf8_length(str)
  return vim.str_utfindex(str)
end

-- https://neovim.discourse.group/t/how-do-you-work-with-strings-with-multibyte-characters-in-lua/2437/3
local function utf8_sub(str, i, j)
  -- stylua: ignore start
  local length = vim.str_utfindex(str)
  if i < 0 then i = i + length + 1 end
  if (j and j < 0) then j = j + length + 1 end
  local u = (i > 0) and i or 1
  local v = (j and j <= length) and j or length
  if (u > v) then return "" end
  local s = vim.str_byteindex(str, u - 1)
  local e = vim.str_byteindex(str, v)
  return str:sub(s + 1, e)
  -- stylua: ignore end
end

local function slugify(s)
  -- stylua: ignore
  local filter = {
    [" "] = "-",
    ["_"] = "-",
    ["-"] = "-",
    -- Numbers
    ["0"] = "0", ["1"] = "1", ["2"] = "2", ["3"] = "3", ["4"] = "4", ["5"] = "5", ["6"] = "6", ["7"] = "7", ["8"] = "8", ["9"] = "9",
    -- Lowercase latin letters
    ["a"] = "a", ["b"] = "b", ["c"] = "c", ["d"] = "d", ["e"] = "e", ["f"] = "f", ["g"] = "g", ["h"] = "h", ["i"] = "i", ["j"] = "j", ["k"] = "k", ["l"] = "l", ["m"] = "m", ["n"] = "n", ["o"] = "o", ["p"] = "p", ["q"] = "q", ["r"] = "r", ["s"] = "s", ["t"] = "t", ["u"] = "u", ["v"] = "v", ["w"] = "w", ["x"] = "x", ["y"] = "y", ["z"] = "z",
    -- Uppercase latin letters
    ["A"] = "a", ["B"] = "b", ["C"] = "c", ["D"] = "d", ["E"] = "e", ["F"] = "f", ["G"] = "g", ["H"] = "h", ["I"] = "i", ["J"] = "j", ["K"] = "k", ["L"] = "l", ["M"] = "m", ["N"] = "n", ["O"] = "o", ["P"] = "p", ["Q"] = "q", ["R"] = "r", ["S"] = "s", ["T"] = "t", ["U"] = "u", ["V"] = "v", ["W"] = "w", ["X"] = "x", ["Y"] = "y", ["Z"] = "z",
    -- Lowercase cyrillic letters
    ["а"] = "а", ["б"] = "б", ["в"] = "в", ["г"] = "г", ["д"] = "д", ["е"] = "е", ["ё"] = "ё", ["ж"] = "ж", ["з"] = "з", ["и"] = "и", ["й"] = "й", ["к"] = "к", ["л"] = "л", ["м"] = "м", ["н"] = "н", ["о"] = "о", ["п"] = "п", ["р"] = "р", ["с"] = "с", ["т"] = "т", ["у"] = "у", ["ф"] = "ф", ["х"] = "х", ["ц"] = "ц", ["ч"] = "ч", ["ш"] = "ш", ["щ"] = "щ", ["ъ"] = "ъ", ["ы"] = "ы", ["ь"] = "ь", ["э"] = "э", ["ю"] = "ю", ["я"] = "я",
    -- Uppercase cyrillic letters
    ["А"] = "а", ["Б"] = "б", ["В"] = "в", ["Г"] = "г", ["Д"] = "д", ["Е"] = "е", ["Ё"] = "ё", ["Ж"] = "ж", ["З"] = "з", ["И"] = "и", ["Й"] = "й", ["К"] = "к", ["Л"] = "л", ["М"] = "м", ["Н"] = "н", ["О"] = "о", ["П"] = "п", ["Р"] = "р", ["С"] = "с", ["Т"] = "т", ["У"] = "у", ["Ф"] = "ф", ["Х"] = "х", ["Ц"] = "ц", ["Ч"] = "ч", ["Ш"] = "ш", ["Щ"] = "щ", ["Ъ"] = "ъ", ["Ы"] = "ы", ["Ь"] = "ь", ["Э"] = "э", ["Ю"] = "ю", ["Я"] = "я",
  }

  local slug = ""

  for i = 1, utf8_length(s) do
    local char = utf8_sub(s, i, i)
    local slugchar = filter[char]
    if slugchar then
      slug = slug .. slugchar
    end
  end

  slug = slug:gsub("^%-*", "")
  slug = slug:gsub("%-*$", "")
  slug = slug:gsub("%-+", "-")

  return slug
end

-- https://github.com/epwalsh/obsidian.nvim/issues/467
-- https://github.com/epwalsh/obsidian.nvim/blob/ec0f44e1921d2701bd99a542031d280f1e3930b5/lua/obsidian/commands/new.lua#L5
-- https://github.com/epwalsh/obsidian.nvim/blob/ec0f44e1921d2701bd99a542031d280f1e3930b5/lua/obsidian/commands/template.lua#L6
-- Assumes `obsidian.opts.disable_frontmatter = true`.
-- Assumes template has `# {{ title }}`
local function create_note_with_template(template_name)
  local client = require("obsidian").get_client()
  local templates = require("obsidian.templates")
  local util = require("obsidian.util")
  local log = require("obsidian.log")

  local prompt = "Enter title or path (optional): "
  if template_name ~= "default" then
    prompt = "Enter title or path for " .. template_name .. " (optional): "
  end

  local title = util.input(prompt)
  if not title then
    log.warn("Aborted")
    return
  elseif title == "" then
    title = nil
  end

  local note = client:create_note({ title = title, no_write = true }) -- Taken from `new()`
  client:open_note(note, { sync = true }) -- Taken from `new()`
  client:write_note_to_buffer(note) -- Taken from `new()`
  local insert_location = util.get_active_window_cursor_location() -- Taken from `template()`
  templates.insert_template({ template_name = template_name, client = client, location = insert_location }) -- Taken from `template()`

  local bufnr = vim.api.nvim_get_current_buf()
  if title then
    vim.api.nvim_buf_set_lines(bufnr, 0, 1, true, {}) -- HACK: Removes the extra level 1 heading produced by `new()`
  else
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local new_lines = {}
    for _, line in ipairs(lines) do
      if not string.match(line, "^# ") then
        table.insert(new_lines, line)
      end
    end
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines) -- Removes the redundant level 1 heading produced by the template when title is nil
  end
end

-- See https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#system-requirements
return {
  {
    "nvim-treesitter",
    opts = {
      ensure_installed = {
        "markdown",
        "markdown_inline",
        "html",
      },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    event = { "VeryLazy" },
    dependencies = {
      "plenary.nvim",
      "nvim-cmp",
      "telescope.nvim",
      "nvim-treesitter",
    },
    keys = {
      {
        "<leader>nn",
        function()
          create_note_with_template("default")
        end,
        desc = "New note",
      },
      {
        "<leader>fnn",
        function()
          return vim.cmd.ObsidianSearch()
        end,
        desc = "Search all notes",
      },
      {
        "<leader>fnb",
        function()
          vim.cmd.ObsidianBacklinks()
        end,
        desc = "Search note backlinks",
      },
      {
        "<leader>fnl",
        function()
          vim.cmd.ObsidianLinks()
        end,
        desc = "Search note links",
      },
      {
        "<leader>fnt",
        function()
          vim.cmd.ObsidianTags()
        end,
        desc = "Search tags",
      },
      {
        "<leader>ni",
        function()
          vim.cmd.ObsidianPasteImg()
        end,
        desc = "Insert image from clipboard",
      },
      {
        "<leader>ne",
        function()
          vim.cmd.ObsidianExtractNote()
        end,
        desc = "Extract note",
      },
      {
        "<leader>no",
        function()
          vim.cmd.ObsidianOpen()
        end,
        desc = "Open notes in Obsidian",
      },
    },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes",
        },
      },
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<leader>ct"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
      follow_url_func = function(url)
        vim.fn.jobstart({ "open", url })
      end,
      note_id_func = function(title)
        local id = os.date("!%Y%m%d%H%M%S")
        -- if title then
        --   id = slugify(title) .. "-" .. id
        -- end
        return id
      end,
      note_path_func = function(spec)
        local path = spec.dir / spec.id
        return path:with_suffix(".md")
      end,
      new_notes_location = "notes_subdir",
      wiki_link_func = "prepend_note_path",
      disable_frontmatter = true,
      ui = {
        bullets = { hl_group = "ObsidianBullet" },
      },
      attachments = {
        img_folder = "assets",
      },
      templates = {
        subdir = "templates",
      },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)
    end,
  },
  {
    "NvChad",
    opts = {
      inits_by_ft = {
        markdown = {
          function()
            -- conceallevel is used by obsidian.nvim to hide markup.
            vim.opt_local.conceallevel = 1

            -- Disable conceallevel in insert mode.
            vim.api.nvim_create_autocmd({ "InsertEnter" }, {
              group = vim.api.nvim_create_augroup("user_obsidian_inits_insert_enter", {}),
              callback = function()
                if vim.bo.filetype == "markdown" then
                  vim.opt_local.conceallevel = 0
                end
              end,
            })
            vim.api.nvim_create_autocmd({ "InsertLeave" }, {
              group = vim.api.nvim_create_augroup("user_obsidian_inits_insert_leave", {}),
              callback = function()
                if vim.bo.filetype == "markdown" then
                  vim.opt_local.conceallevel = 1
                end
              end,
            })
          end,
        },
      },
    },
  },
}
