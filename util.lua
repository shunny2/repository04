-- verifica se o mouse está dentro do retângulo
function checkMousePosInQuad(mouseX, mouseY, objX, objY, objW, objH)
  if (not (mouseY >= objY and mouseY <= objY + objH)) then
    return false
  end
  if (not (mouseX >= objX and mouseX <= objX + objW)) then
    return false
  end
  return true
end