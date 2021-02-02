require('MenuOption')
require('Util')
local Menu = {}
Menu.__index = Menu

function newMenu()
  local button = {}
  button.fontName = 'Fontes/vt323/VT323-Regular.ttf'
  button.options = {}
  button.backgroundMenu = {}
  button.backgroundMenu.image = love.graphics.newImage('Imagens/Background/BackgroundMenu.png')
  
  return setmetatable(button, Menu)
end  

function Menu:mousePressed(mouseX, mouseY)
  -- para 1 até todas as opções adicionadas no vetor option
  for i = 1, #self.options do
    if (checkMousePosInQuad(mouseX, mouseY, self.options[i].x, self.options[i].y, self.options[i].w, self.options[i].h)) then
      return self.options[i].text -- retorna qual opçcao foi clicada atraves do texto  
    end
  end
  return ''
end

function Menu:update(dt)
  
end

function Menu:addOption(x, y, w, h, text)
  local color = {72/255, 160/255, 14/255}
  local option = newMenuOption(color, x, y, w, h, text)
  
  -- Colocando o elemento na ultimo posição (#self.options é o numero total)
  self.options[#self.options + 1] = option
end  

function Menu:drawOption(index)
  local option = self.options[index]
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle('fill', option.x - 2, option.y - 2, option.w + 4, option.h + 4)
  love.graphics.setColor(option.color)
  love.graphics.rectangle('fill', option.x, option.y, option.w, option.h)
  love.graphics.setColor(255/255, 255/255, 255/255)
  love.graphics.setFont(love.graphics.newFont(self.fontName, 20))
  love.graphics.print(option.text, option.x + 18, option.y + 24 - 15)
end  

function Menu:draw()
  love.graphics.draw(self.backgroundMenu.image)
  for index = 1, #self.options do
    self.drawOption(self, index)
  end 
  -- Carregando taxa de quadros por segundo
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 720, 10)
end