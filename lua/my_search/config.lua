local M = {}
-- Build a `find` command that prunes big dirs (including .git) and excludes some filenames
local function build_find_cmd(query)
  -- Directories to prune (skip walking into them)
  local dir_prunes = {
    "node_modules/*",
    "target/*",
    "go/*",
    "lib/forge-std/*",
    "era-downloader/*",
    ".git/*",
  }

  -- Filenames/globs to exclude from results
  local file_excludes = {
    "package-lock.json",
    "*.mod",
    "*.lock",
    "lazy-lock.*",
  }

  local cmd = { "find", "." }

  -- \( -path "./dir/*" -o ... \) -prune -o
  table.insert(cmd, "(")
  for i, p in ipairs(dir_prunes) do
    if i > 1 then table.insert(cmd, "-o") end
    table.insert(cmd, "-path")
    table.insert(cmd, "./" .. p)
  end
  table.insert(cmd, ")")
  table.insert(cmd, "-prune")
  table.insert(cmd, "-o")

  -- Only files
  table.insert(cmd, "-type")
  table.insert(cmd, "f")

  -- Optional path filter from the query (works for dirs or filenames)
  if query and query ~= "" then
    table.insert(cmd, "-path")
    table.insert(cmd, "*" .. query .. "*")
  end

  -- Exclude certain filenames
  for _, pat in ipairs(file_excludes) do
    table.insert(cmd, "!")
    table.insert(cmd, "-name")
    table.insert(cmd, pat)
  end

  -- Print matches
  table.insert(cmd, "-print")

  return cmd
end

function M.derive_cmd(query, mode)
    if query == "" or #query < 3 then
        return ""
    end

    if mode == "files" then
        return build_find_cmd(query)
    else
        local excludes = {
            "node_modules/*",
            "package-lock.json",
            "go/*",
            ".git/*",
            "*.mod",
            "target/*",
            "*.lock",
            "lib/forge-std/.*",
            "era-downloader/*",
            "lazy-lock.*",
        }
        local cmd = {
            "rg",
            "--vimgrep",
            "--no-heading",
            "--color=never",
            query,
            ".",
        }

        for _, pattern in ipairs(excludes or {}) do
            table.insert(cmd, "--glob")
            table.insert(cmd, "!" .. pattern)
        end

        return cmd
    end
end

return M
