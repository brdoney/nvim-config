local colors = {
  black        = '#262626',
  darkgray     = '#3A3A3A',
  lightgray     = '#4E4E4E',
  inactivegray = '#666666',
  darkwhite    = '#E4E4E4',
  white        = '#EEEEEE',
}

local palette = {
  a = { bg = colors.darkgray, fg = colors.darkwhite, gui = 'bold' },
  b = { bg = colors.lightgray, fg = colors.white },
  c = { bg = colors.black, fg = colors.white },
}

return {
  normal = palette,
  insert = palette,
  visual = palette,
  replace = palette,
  command = palette,
  inactive = {
    a = { bg = colors.black, fg = colors.inactivegray, gui = 'bold' },
    b = { bg = colors.black, fg = colors.inactivegray },
    c = { bg = colors.black, fg = colors.inactivegray }
  }
}
