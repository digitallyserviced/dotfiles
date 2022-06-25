
function options_dynamic(M)
  local coloring = {
    tab_bar = {
      background = "hsl(0,0,10%)",
      -- foreground = "rgba(0,0,0,0)"
    },
  }

  local unix_domains = {
    unix_domains = {
      {
        name = "main",
      },
    },
  }

  -- Utility functions -----------------------------------------------------------

  -- Join list of arguments into a path separated by the correct path seperator
  local options = {
    -- debug_key_events = true,
    color_scheme_dirs = {
    },
    font = wezterm.font_with_fallback {
      { family = "ShureTechMono NF", weight = "Regular" },
      { family = "Iosevka Term", weight = "Regular" },
      -- { family = "MesloLGL Nerd Font Mono", weight = "Regular" },
      { family = "PragmataPro Mono", weight = "Regular" },
      { family = "BitstreamVeraSansMono Nerd Font Mono", weight = "Regular" },
      -- { family = "Hack Nerd Font", weight = "Regular" },
      -- { family = "FuraCode Nerd Font", weight = "Regular" },
      -- { family = "JetBrains Mono", weight = "Light" },
      { family = "Terminus", weight = "Bold" },
      "Noto Color Emoji",
    },
  }

  return options
end

return options_dynamic

-- #
-- 
-- 
-- ⌨⛀⛁⛂⛃⛖⛗⚱⚲⚳⚴⚵⚶⚷⚸⚠⚟⚞⚛⚜⚝♳♴♵♶♷♸♹♺♻☣☤☭☯☠☡☢☐☑☒☓☄
