-- Biblioteca de Animação
local animar = require ("anim8")

-- Importando menu
require("Menu")

-- Montagem do Menu
local menu = nil
local menuAtivo = true
local offColor = {72/255, 160/255, 14/255}
local onColor = {20/255, 100/255, 10/255}

local optText = {}
optText[1] = 'Iniciar o Jogo'
optText[2] = 'Sair do Jogo'

-- Montagem da fase
fase = {}
fase.number = 1

-- Montagem dos efeitos de pontuação
efeitosPontuacao = {}
efeitosPontuacao.x = 1
efeitosPontuacao.y = 1

-- Montagem do jogador
jogador = {}
jogador.x = love.graphics.getWidth() - 670
jogador.y = love.graphics.getHeight() - 120
jogador.posAnteriorX = jogador.x
jogador.posAnteriorY = jogador.y
jogador.width = 48
jogador.height = 64
jogador.velocidade = 2
jogador.velocidadePulo = 0
jogador.alturaPulo = 275
jogador.gravidade = 400
jogador.vida = 100
jogador.texto = ''
jogador.nivel = 1
jogador.vivo = true
jogador.andando = false
jogador.pulando = false

-- Montagem do inimigo
inimigo = {}
inimigo.x = love.graphics.getWidth() - 200
inimigo.y = love.graphics.getHeight() - 120
inimigo.posAnteriorX = inimigo.x
inimigo.posAnteriorY = inimigo.y
inimigo.width = 33
inimigo.height = 53
inimigo.velocidade = 4
inimigo.quantidade = 0
inimigo.dtMaxCriaInimigo = 0
inimigo.dtAtualInimigo = inimigo.dtMaxCriaInimigo
inimigo.vida = 100
inimigo.nivel = 1
inimigo.vivo = true
inimigo.andando = false

-- Montagem dos projéteis do jogador. Junto aos timers de controle de tiro
projeteis = {}
projeteis.x = jogador.x
projeteis.y = love.graphics.getHeight() - 160
projeteis.width = 32
projeteis.height = 32
projeteis.velocidadeMaxTiro = 1.0
projeteis.tempoTiro = projeteis.velocidadeMaxTiro
projeteis.acerto = 0
projeteis.podeAtirar = true

-- Montagem dos projéteis do inimigo. Junto aos timers de controle de tiro
projeteisInimigo = {}
projeteisInimigo.x = inimigo.x
projeteisInimigo.y = love.graphics.getHeight() - 160
projeteisInimigo.width = 32
projeteisInimigo.height = 32
projeteisInimigo.velocidadeMaxTiro = 1.0
projeteisInimigo.tempoTiro = projeteis.velocidadeMaxTiro
projeteisInimigo.dtAtualProjInimigo = 0
projeteisInimigo.acerto = 0
projeteisInimigo.podeAtirar = true

  
function love.load()
  
  -- Carregamento das sprites do game
  sprites = {}
  sprites.backgroundMenu = love.graphics.newImage('Imagens/Background/BackgroundMenu.png')
  sprites.background = love.graphics.newImage('Imagens/Background/Background.png')
  sprites.jogador = love.graphics.newImage('Imagens/Sprites/Valoeu.png')
  sprites.inimigo = love.graphics.newImage('Imagens/Sprites/Inimigo.png')
  sprites.flecha = love.graphics.newImage('Imagens/Sprites/Flecha.png')  
  sprites.fogo = love.graphics.newImage('Imagens/Sprites/FogoVermelho.png')
  
  -- Carregamento dos sons do game
  sons = {}
  sons.musica = love.audio.newSource('Sons/Musica/MusicaDoJogo.mp3','stream')
  sons.clickBotao = love.audio.newSource('Sons/Efeitos/Botao/ButtonClick.mp3','static')
  sons.houverBotao = love.audio.newSource('Sons/Efeitos/Botao/ButtonHouver.wav','static')
  sons.flecha = love.audio.newSource('Sons/Efeitos/SomDaFlecha.wav','static')
  sons.fogo = love.audio.newSource('Sons/Efeitos/SomDeFogo.wav','static')
  sons.pulo = love.audio.newSource('Sons/Efeitos/SomDePulo.wav','static')
  sons.personagemAtingido = love.audio.newSource('Sons/Efeitos/SomAtingido.wav','static')
  sons.passosDireita = love.audio.newSource('Sons/Efeitos/SomDePassosDireita.wav','static')
  sons.passosEsquerda = love.audio.newSource('Sons/Efeitos/SomDePassosEsquerda.wav','static')
  
  iniciaMenu()
  iniciaTrilhaSonora()
  
  -- Carregamento das fontes do game
  fontes = {}
  fontes.vt = love.graphics.newFont('Fontes/vt323/VT323-Regular.ttf')
  fontes.russoone = love.graphics.newFont('Fontes/russoone/RussoOne-Regular.ttf')
  fontes.jogo = love.graphics.newImageFont("Imagens/Fonte/Fonte.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\""
  )
  
  -- Carregamento das animações do jogador
  jogador.grades = {}
  jogador.grades.andar = animar.newGrid(jogador.width, jogador.height, sprites.jogador:getWidth(), sprites.jogador:getHeight())
  
  jogador.animacoes = {}
  jogador.animacoes.parado = animar.newAnimation(jogador.grades.andar('1-3',1), 0.1)
  jogador.animacoes.andarParaCima = animar.newAnimation(jogador.grades.andar('1-3',4), 0.1)
  jogador.animacoes.andarParaBaixo = animar.newAnimation(jogador.grades.andar('1-3',1), 0.1)
  jogador.animacoes.andarParaDireita = animar.newAnimation(jogador.grades.andar('1-3',3), 0.1)
  jogador.animacoes.andarParaEsquerda = animar.newAnimation(jogador.grades.andar('1-3',2), 0.1)
  
  jogador.anim = jogador.animacoes.parado
  
  -- Carregamento das animações do inimigo
  inimigo.grades = {}
  inimigo.grades.andar = animar.newGrid(inimigo.width, inimigo.height, sprites.inimigo:getWidth(), sprites.inimigo:getHeight())
  
  inimigo.animacoes = {}
  inimigo.animacoes.parado = animar.newAnimation(inimigo.grades.andar('1-1',1), 0.1)
  inimigo.animacoes.andarParaCima = animar.newAnimation(inimigo.grades.andar('9-11',1), 0.1)
  inimigo.animacoes.andarParaBaixo = animar.newAnimation(inimigo.grades.andar('9-11',1), 0.1)
  inimigo.animacoes.andarParaDireita = animar.newAnimation(inimigo.grades.andar('2-5',1), 0.1)
  inimigo.animacoes.andarParaEsquerda = animar.newAnimation(inimigo.grades.andar('2-5',1), 0.1)
  inimigo.animacoes.bravo = animar.newAnimation(inimigo.grades.andar('1-12',1), 0.1)
  
  inimigo.anim = inimigo.animacoes.parado
  
  -- Carregamento das animações do projétil inimigo
  projeteisInimigo.grades = {}
  projeteisInimigo.grades.spell = animar.newGrid(projeteisInimigo.width, projeteisInimigo.height, sprites.fogo:getWidth(), 
  sprites.fogo:getHeight())
  
  projeteisInimigo.animacoes = {}
  projeteisInimigo.animacoes.fogo = animar.newAnimation(projeteisInimigo.grades.spell('1-1',1, '1-1',2, '1-1',3, '1-1',4), 0.01)
  
  projeteisInimigo.anim = projeteisInimigo.animacoes.fogo
  
end  

function love.update(dt)
  
  if not menuAtivo then
    efeitosNaPontuacao(dt)
    movimentosDoJogador(dt)
    movimentosDoInimigo(dt)
    tirosDoJogador(dt)
    tirosDoInimigo(dt)
    colisoesDoJogador()
    colisoesDoInimigo()  
  end
  
end

function love.draw()
  
  if menuAtivo then
    menu:draw()
  else  
    -- Carregamento do background do game
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(sprites.background)
    
    -- Carregamento das Fontes 
    love.graphics.setFont(fontes.jogo)
    
    -- Carregamento de informações de fase e de personagens
    love.graphics.print(" Fase: ", 350, 10, 0, 1, 1, 0, 2, 0, 0)
    love.graphics.print(fase.number .. " (The End: Part I)", 415, 14, 0, 1, 1, 5, 5, 0, 0)
    love.graphics.print(" Acertos do Jogador: ", 10, 10, 0, 1, 1, 0, 2, 0, 0)
    love.graphics.print(projeteis.acerto, 200, 13, 0, efeitosPontuacao.x, efeitosPontuacao.y, 5, 5, 0, 0)
    love.graphics.print(" Acertos do Inimigo: ", 10, 30, 0, 1, 1, 0, 2, 0, 0)
    love.graphics.print(projeteisInimigo.acerto, 200, 33, 0, efeitosPontuacao.x, efeitosPontuacao.y, 5, 5, 0, 0)
    love.graphics.print(" Vida do Jogador: ", 10, 50, 0, 1, 1, 0, 2, 0, 0)
    love.graphics.print(jogador.vida .. "%", 170, 53, 0, 1, 1, 5, 5, 0, 0)
    love.graphics.print(" Vida do Inimigo: ", 10, 70, 0, 1, 1, 0, 2, 0, 0)
    love.graphics.print(inimigo.vida .. "%", 170, 73, 0, 1, 1, 5, 5, 0, 0)

    -- Inverte a imagem se necessário
    local sx = 1
    if inimigo.anim == inimigo.animacoes.andarParaEsquerda then
      sx = -1
    end
    
    -- Carregamento do Personagem jogador
    if jogador.vivo then
      love.graphics.setColor(1, 1, 1, 1)
      jogador.anim:draw(sprites.jogador, jogador.x, jogador.y, nil, 1, 1, jogador.width/2, jogador.height/1.3)
      love.graphics.print(jogador.texto, jogador.x - 70, jogador.y - 90)
      desenhaBalaoTexto()
      
      -- Carregamento do Personagem inimigo
      for i, inimigos in ipairs(inimigo) do
        if inimigo.vivo then
          love.graphics.setColor(1, 1, 1, 1)
          inimigo.anim:draw(inimigos.img, inimigos.x, inimigos.y, nil, sx, 1, inimigo.width/2, inimigo.height/1.3)
        end
      end  
      
      -- Caregamento dos projéteis do Jogador
      for i,proj in ipairs(projeteis) do
        love.graphics.draw(proj.img, proj.x, proj.y)  
      end
      
      -- Caregamento dos projéteis do Inimigo
      for i,proj in ipairs(projeteisInimigo) do
        projeteisInimigo.anim:draw(proj.img, proj.x, proj.y)  
      end
      
    elseif jogador.vida <= 0 then
      love.graphics.draw(sprites.backgroundMenu)
      love.graphics.print("Voce morreu! Aperte ENTER para reiniciar o jogo ou ESC para encerar o jogo.", love.graphics.getWidth() / 12, love.graphics.getHeight() / 2)
    end
    
    if not inimigo.vivo and inimigo.vida <= 0 then
      love.graphics.draw(sprites.backgroundMenu)
      love.graphics.print("Parabens! Voce conseguiu derrotar o seu irmao Sola e passou para a proxima fase.", love.graphics.getWidth() / 18, love.graphics.getHeight() / 2)
      love.graphics.print("Aperte ENTER para reiniciar o jogo ou ESC para encerar o jogo.", love.graphics.getWidth() / 6.8, love.graphics.getHeight() / 1.8)
      pausaSons()
    end
    
  end
  
  -- Carregamento da Taxa de quadros por segundo
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 720, 10)
  
end  

function love.keypressed(key)
  
  if not jogador.vivo and key == 'return' or not inimigo.vivo and key == 'return' then
    love.event.quit('restart')
  end
  if not jogador.vivo and key == 'escape' or not inimigo.vivo and key == 'escape' then
    love.event.quit()
  end 
  if jogador.vivo and key == 'e' then
    jogador.texto = 'Ola jogador, meu nome e Valoeu!'
  end  
end  

function love.keyreleased(key)
  if jogador.vivo and key == 'e' then
    jogador.texto = ''
  end  
end  

function love.mousemoved( x, y, dx, dy, istouch )
  if menuAtivo then
    menu.options[1].color = offColor
    menu.options[2].color = offColor
    local mouseOver = menu:mousePressed(x, y)
    if mouseOver == optText[1] then
      menu.options[1].color = onColor
    elseif mouseOver == optText[2] then
      menu.options[2].color = onColor
    end 
  end  
end

function love.mousepressed( x, y, button )
  if menuAtivo then
    local clickedOpt = menu:mousePressed(x, y)
    if clickedOpt ~= nil then
      if clickedOpt == optText[1] then
        menuAtivo = false
        sons.musica:stop()
      elseif clickedOpt == optText[2] then
        love.event.quit()
      end
      love.audio.play(sons.clickBotao)
    end  
  end  
end

function iniciaMenu()
  menu = newMenu()
  menu:addOption(325, 320, 150, 40, optText[1])
  menu:addOption(325, 370, 150, 40, optText[2])
end

function iniciaTrilhaSonora()
  if menuAtivo then
    sons.musica:setLooping(true)
    love.audio.play(sons.musica)
  end
end

function pausaSons() 
  love.audio.pause()
  love.audio.setVolume(0.0)
end

function efeitosNaPontuacao(dt)
  -- Atualizando efeitos de pontuação
  efeitosPontuacao.x = efeitosPontuacao.x - 3 * dt
  efeitosPontuacao.y = efeitosPontuacao.y - 3 * dt
  
  if efeitosPontuacao.x <= 1 then
    efeitosPontuacao.x = 1
    efeitosPontuacao.y = 1
  end  
end

function desenhaBalaoTexto()
  if jogador.texto ~= '' then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', jogador.x -83, jogador.y -100, 300, 40)
  end  
end

function movimentosDoJogador(dt)
  -- Atualiza posição do Jogador
  if jogador.andando then
    jogador.anim:update(dt)
  end
  
  local posicaoAnteriorX = jogador.x
  local posicaoAnteriorY = jogador.y
  
  -- Controles do jogador
  if jogador.vivo and love.keyboard.isDown('left','a') then
    if jogador.x > 40 then
      jogador.x = jogador.x - jogador.velocidade
      jogador.anim = jogador.animacoes.andarParaEsquerda
      love.audio.play(sons.passosEsquerda)
      jogador.andando = true
    end  
  end

  if jogador.vivo and love.keyboard.isDown('right','d') then
    if jogador.x + jogador.width < love.graphics.getWidth()  then
      jogador.x = jogador.x + jogador.velocidade
      jogador.anim = jogador.animacoes.andarParaDireita
      love.audio.play(sons.passosDireita)
      jogador.andando = true
    end  
  end

  if jogador.vivo and love.keyboard.isDown('lshift','rshift') and love.keyboard.isDown('left','a') then
    if jogador.x > 40 then
      jogador.x = jogador.x - jogador.velocidade * 2
      jogador.anim = jogador.animacoes.andarParaEsquerda
      love.audio.play(sons.passosEsquerda)
      jogador.andando = true
    end  
  end 
  
  if jogador.vivo and love.keyboard.isDown('lshift','rshift') and love.keyboard.isDown('right','d') then
    if jogador.x + jogador.width < love.graphics.getWidth()  then
      jogador.x = jogador.x + jogador.velocidade * 2
      jogador.anim = jogador.animacoes.andarParaDireita
      love.audio.play(sons.passosDireita)
      jogador.andando = true
    end  
  end 
  
  if jogador.vivo and love.keyboard.isDown('space') then
    if jogador.velocidadePulo == 0 then
      jogador.velocidadePulo = jogador.alturaPulo
      jogador.anim = jogador.animacoes.parado
      love.audio.play(sons.pulo)
      jogador.pulando = true
    end
  end

  if jogador.vivo and jogador.velocidadePulo ~= 0 and jogador.pulando then
    jogador.y = jogador.y - jogador.velocidadePulo * dt
    jogador.velocidadePulo = jogador.velocidadePulo - jogador.gravidade * dt
    if jogador.y > jogador.posAnteriorY then
      jogador.velocidadePulo = 0
      jogador.y = jogador.posAnteriorY
    end  
  end  
  
  -- Atualiza o estado do frame do jogador
  if posicaoAnteriorX ~= jogador.x or posicaoAnteriorY ~= jogador.y then
    jogador.andando = true
    jogador.pulando = true
  else
    jogador.andando = false
    jogador.pulando = false
    jogador.anim:gotoFrame(3)
  end
end

function movimentosDoInimigo(dt)
  -- Controle de instância de inimigos
  inimigo.dtAtualInimigo = inimigo.dtAtualInimigo - (1 * dt)
  if inimigo.dtAtualInimigo < 0  and jogador.vivo and inimigo.quantidade < 1 then
    inimigo.dtAtualInimigo = inimigo.dtMaxCriaInimigo
    novoInimigo = {}
    novoInimigo.x = inimigo.x
    novoInimigo.y = inimigo.y
    novoInimigo.img = sprites.inimigo
    table.insert(inimigo, novoInimigo)
    inimigo.quantidade = inimigo.quantidade + 1
  end  
  -- Movimento dos inimigos
  for i, inimigos in ipairs(inimigo) do
    if inimigo.vida < 100 then
      inimigos.x = inimigos.x - (0 * dt)
      if inimigos.x > 800  or inimigos.x < 0 then -- Inimigo saiu da tela
        table.remove(inimigos, i) -- remove da tabela
      end 
      inimigo.anim = inimigo.animacoes.andarParaEsquerda
    end  
  end
end

function tirosDoJogador(dt)
  -- Controle e emissão dos tiros do Personagem
  projeteis.tempoTiro = projeteis.tempoTiro - (1 * dt)
  if projeteis.tempoTiro < 0 then
    projeteis.podeAtirar = true
  end 
  
  if love.keyboard.isDown('q') and jogador.vivo and projeteis.podeAtirar then
    novoProjetil = {}
    novoProjetil.x = jogador.x
    novoProjetil.y = jogador.y - 40
    novoProjetil.img = sprites.flecha
    table.insert(projeteis, novoProjetil)
    projeteis.podeAtirar = false
    projeteis.tempoTiro = projeteis.velocidadeMaxTiro
    love.audio.play(sons.flecha)
  end
  
  -- Atualizar constantemente a lista de projéteis do personagem
  for i, proj in ipairs(projeteis) do
    proj.x = proj.x + (460 * dt)
    if proj.x < 0 then
      table.remove(proj,i)
    end  
  end 
end

function tirosDoInimigo(dt)
  -- Controle e emissão dos tiros do Inimigo
  projeteisInimigo.tempoTiro = projeteisInimigo.tempoTiro - (1 * dt)
  if projeteisInimigo.tempoTiro < 0 then
    projeteisInimigo.podeAtirar = true
  end  
  
  projeteisInimigo.dtAtualProjInimigo = projeteisInimigo.dtAtualProjInimigo - (1 * dt)
  if projeteisInimigo.dtAtualProjInimigo < 0 and inimigo.vivo and jogador.vivo and projeteisInimigo.podeAtirar then
    if inimigo.vida < 100 then
      novoProjetilInimigo = {}
      novoProjetilInimigo.x = inimigo.x
      novoProjetilInimigo.y = projeteisInimigo.y 
      novoProjetilInimigo.img = sprites.fogo
      table.insert(projeteisInimigo, novoProjetilInimigo)
      projeteisInimigo.podeAtirar = false
      projeteisInimigo.tempoTiro = projeteisInimigo.velocidadeMaxTiro
      projeteisInimigo.anim:update(dt)
      love.audio.play(sons.fogo) 
    end 
  end
  
  -- Atualizar constantemente a lista de projéteis do inimigo
  for i, proj in ipairs(projeteisInimigo) do
    proj.x = proj.x - (260 * dt)
    if proj.x < 0 then
      table.remove(proj,i)
    end  
  end 
end

function colisoesDoJogador()
  -- Atualizar Colisões Projétil jogador
  for i, inimigos in ipairs(inimigo) do
    for j, proj in ipairs(projeteis) do
      if checarColisoesProjeteisJogador(inimigos.x, inimigos.y, sprites.inimigo:getWidth(), sprites.inimigo:getHeight(), proj.x, 
      proj.y, sprites.flecha:getWidth(), sprites.flecha:getHeight()) and inimigo.vivo then
        table.remove(projeteis, j)
        efeitosPontuacao.x = 1.5
        efeitosPontuacao.y = 1.5
        projeteis.acerto = projeteis.acerto + 1
        inimigo.vida = inimigo.vida - 10
        if inimigo.vida <= 0 then
          table.remove(inimigo, i)
          inimigo.vivo = false
        end  
      end
    end
    if checarColisoes(inimigos.x, inimigos.y, sprites.inimigo:getWidth(), sprites.inimigo:getHeight(), jogador.x - (sprites.jogador:getWidth() / 2), jogador.y, sprites.jogador:getWidth(), sprites.jogador:getHeight()) and jogador.vivo then
      love.audio.play(sons.personagemAtingido)
      jogador.vida = jogador.vida - 10
      if jogador.vida <= 0 then
        table.remove(jogador, i)
        jogador.vivo = false
      end  
    end
  end
end

function colisoesDoInimigo()
  -- Atualizar Colisões Projétil inimigo
  for j, proj in ipairs(projeteisInimigo) do
    if checarColisoesProjeteisInimigo(jogador.x, jogador.y, sprites.jogador:getWidth(), sprites.jogador:getHeight(), proj.x, proj.y, 
    sprites.fogo:getWidth(), sprites.fogo:getHeight()) and jogador.vivo then
      table.remove(projeteisInimigo, j)
      efeitosPontuacao.x = 1.5
      efeitosPontuacao.y = 1.5
      projeteisInimigo.acerto = projeteisInimigo.acerto + 1
      love.audio.play(sons.personagemAtingido)
      jogador.vida = jogador.vida - 10
      if jogador.vida <= 0 then
        table.remove(jogador, i)
        jogador.vivo = false
      end  
    end 
  end  
end  

function checarColisoesProjeteisJogador(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2 and x2 < x1 + w1 and y1 > y2 + h2 and y2 < y1 + h1
end

function checarColisoesProjeteisInimigo(x1,y1,w1,h1,x2,y2,w2,h2)
  return x1 > x2 - w2 and x2 > x1 - w1 and y1 > y2 - h2 and y2 > y1 - h1
end

function checarColisoes(x1, y1, w1, h1, x2, y2, w2, h2)
  return x2 >= x1 - w2 and x2 <= x1 + w1 and y2 >= y1 - h2 and y2 <= y1 + h1
end 

function checarColisoesInverso(x1, y1, w1, h1, x2, y2, w2, h2)
  return x2 <= x1 + w2 and x2 >= x1 - w1 and y2 <= y1 + h2 and y2 >= y1 - h1
end 