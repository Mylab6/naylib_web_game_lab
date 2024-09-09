import raylib

type
  Player = object
    x, y, width, height: float32

  Ball = object
    x, y, speedX, speedY, radius: float32

var
  player: Player
  opponent: Player
  ball: Ball
  score: int

proc initPong*() =
  player.x = 50
  player.y = float32(getScreenHeight() div 2 - 40)
  player.width = 10
  player.height = 80

  opponent.x = float32(getScreenWidth() - 60)
  opponent.y = float32(getScreenHeight() div 2 - 40)
  opponent.width = 10
  opponent.height = 80

  ball.x = float32(getScreenWidth() div 2)
  ball.y = float32(getScreenHeight() div 2)
  ball.speedX = 5
  ball.speedY = 5
  ball.radius = 5

  score = 0

proc updatePong*(): bool =
  if isKeyDown(KeyboardKey.UP): player.y -= 5
  if isKeyDown(KeyboardKey.DOWN): player.y += 5
  player.y = clamp(player.y, 0, float32(getScreenHeight()) - player.height)

  # Simple AI for opponent
  if opponent.y + opponent.height/2 < ball.y: opponent.y += 3
  if opponent.y + opponent.height/2 > ball.y: opponent.y -= 3
  opponent.y = clamp(opponent.y, 0, float32(getScreenHeight()) - opponent.height)

  ball.x += ball.speedX
  ball.y += ball.speedY

  if ball.y <= 0 or ball.y >= float32(getScreenHeight()): ball.speedY *= -1

  if checkCollisionCircleRec(Vector2(x: ball.x, y: ball.y), ball.radius,
    Rectangle(x: player.x, y: player.y, width: player.width, height: player.height)) or
    checkCollisionCircleRec(Vector2(x: ball.x, y: ball.y), ball.radius,
    Rectangle(x: opponent.x, y: opponent.y, width: opponent.width, height: opponent.height)):
    ball.speedX *= -1
    inc(score)

  if ball.x < 0 or ball.x > float32(getScreenWidth()):
    return true  # Game over

  return false  # Game continues

proc drawPong*() =
  drawRectangle(int32(player.x), int32(player.y), int32(player.width), int32(player.height), Blue)
  drawRectangle(int32(opponent.x), int32(opponent.y), int32(opponent.width), int32(opponent.height), Red)
  drawCircle(int32(ball.x), int32(ball.y), ball.radius, Yellow)
  drawText(cstring("Score: " & $score), 10, 10, 20, DarkGray)

proc getPongScore*(): int =
  return score