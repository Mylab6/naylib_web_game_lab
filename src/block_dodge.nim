import raylib
import random
type
  Player = object
    x, y, width, height: float32

  Block = object
    x, y: float32
    active: bool

var
  player: Player
  blocks: array[2, Block]
  score: int

proc initBlockDodge*() =
  randomize();
  player.x = float32(getScreenWidth() div 2)
  player.y = float32(getScreenHeight() - 40)
  player.width = 20
  player.height = 20

  for i in 0..1:
    blocks[i].x = float32(rand(getScreenWidth() - 30))
    blocks[i].y = float32(-30 * (i + 1) * 2)
    blocks[i].active = true

  score = 0

proc updateBlockDodge*(): bool =
  if isKeyDown(KeyboardKey.LEFT): player.x -= 5
  if isKeyDown(KeyboardKey.RIGHT): player.x += 5
  player.x = clamp(player.x, 0, float32(getScreenWidth()) - player.width)

  for i in 0..1:
    if blocks[i].active:
      blocks[i].y += 5
      if blocks[i].y > float32(getScreenHeight()):
        blocks[i].y = -30
        blocks[i].x = float32(rand(getScreenWidth() - 30))
        inc(score)

    if checkCollisionRecs(
      Rectangle(x: player.x, y: player.y, width: player.width, height: player.height),
      Rectangle(x: blocks[i].x, y: blocks[i].y, width: 30, height: 30)
    ):
      return true  # Game over

  return false  # Game continues

proc drawBlockDodge*() =
  drawRectangle(int32(player.x), int32(player.y), int32(player.width), int32(player.height), Blue)
  for blockE in blocks:
    if blockE.active:
      drawRectangle(int32(blockE.x), int32(blockE.y), 30, 30, Red)
  drawText(cstring("Score: " & $score), 10, 10, 20, DarkGray)

proc getBlockDodgeScore*(): int =
  return score