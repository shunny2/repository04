local MenuOption = {}
MenuOption.__index = MenuOption

function newMenuOption(color, x, y, w, h, text)
  local button = {}
  button.color = color
  button.x = x
  button.y = y
  button.w = w
  button.h = h
  button.text = text
  
  return setmetatable(button, MenuOption)
  
end 