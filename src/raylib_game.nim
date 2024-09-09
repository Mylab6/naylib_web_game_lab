import raylib
import random

const
  screenWidth = 800
  screenHeight = 450
  playerSize = 20
  blockSize = 30
  blockSpeed = 5

type
  Player = object
    x, y: float32

  Block = object
    x, y: float32
    active: bool

var
  player: Player
  blocks: array[2, Block]
  score: int

proc initGame() =
  randomize()

  player.x = float32(screenWidth div 2)
  player.y = float32(screenHeight - playerSize * 2)

  for i in 0..1:
    blocks[i].x = float32(rand(screenWidth - blockSize))
    blocks[i].y = float32(-blockSize * (i + 1) * 2)
    blocks[i].active = true

  score = 0

proc updateGame() =
  # Move player
  if isKeyDown(KeyboardKey.LEFT): player.x -= 5
  if isKeyDown(KeyboardKey.RIGHT): player.x += 5

  # Keep player within screen bounds
  player.x = clamp(player.x, 0, float32(screenWidth - playerSize))

  # Update blocks
  for i in 0..1:
    if blocks[i].active:
      blocks[i].y += blockSpeed
      if blocks[i].y > screenHeight:
        blocks[i].y = float32(-blockSize)
        blocks[i].x = float32(rand(screenWidth - blockSize))
        inc(score)

    # Check collision
    if checkCollisionRecs(
      Rectangle(x: player.x, y: player.y, width: float32(playerSize), height: float32(playerSize)),
      Rectangle(x: blocks[i].x, y: blocks[i].y, width: float32(blockSize), height: float32(blockSize))
    ):
      initGame()  # Reset game on collision

proc drawGame() =
  beginDrawing()
  clearBackground(RayWhite)

  # Draw player
  drawRectangle(int32(player.x), int32(player.y), playerSize, playerSize, Blue)

  # Draw blocks
  for blk in blocks:
    if blk.active:
      drawRectangle(int32(blk.x), int32(blk.y), blockSize, blockSize, Red)

  # Draw score
  drawText(cstring("Score: " & $score), 10, 10, 20, DarkGray)

  endDrawing()

initWindow(screenWidth, screenHeight, "Block Dodge Game")
setTargetFPS(60)

initGame()

while not windowShouldClose():
  updateGame()
  drawGame()

closeWindow()