import raylib

const
  screenWidth = 800
  screenHeight = 450
  paddleWidth = 10
  paddleHeight = 100
  ballSize = 10

type
  Paddle = object
    rect: Rectangle
    speed: float32

  Ball = object
    position: Vector2
    speed: Vector2
    radius: float32

var
  leftPaddle, rightPaddle: Paddle
  ball: Ball
  leftScore, rightScore: int

proc initGame() =
  leftPaddle = Paddle(
    rect: Rectangle(x: 50, y: screenHeight/2 - paddleHeight/2, width: paddleWidth, height: paddleHeight),
    speed: 5
  )
  rightPaddle = Paddle(
    rect: Rectangle(x: screenWidth - 50 - paddleWidth, y: screenHeight/2 - paddleHeight/2, width: paddleWidth, height: paddleHeight),
    speed: 5
  )
  ball = Ball(
    position: Vector2(x: screenWidth/2, y: screenHeight/2),
    speed: Vector2(x: 5, y: 5),
    radius: ballSize/2
  )

proc updateAI() =
  let paddleCenter = rightPaddle.rect.y + paddleHeight / 2
  let ballCenter = ball.position.y

  # Add some prediction based on ball's vertical speed
  let predictedBallY = ballCenter + ball.speed.y * ((screenWidth - ball.position.x) / ball.speed.x.abs)
  
  # Move towards the predicted position
  if predictedBallY < paddleCenter - 10:
    rightPaddle.rect.y -= rightPaddle.speed
  elif predictedBallY > paddleCenter + 10:
    rightPaddle.rect.y += rightPaddle.speed

  # Ensure the paddle stays within the screen bounds
  rightPaddle.rect.y = clamp(rightPaddle.rect.y, 0, screenHeight - paddleHeight)

proc updateGame() =
  # Move left paddle (human player)
  if isKeyDown(KeyboardKey.W) and leftPaddle.rect.y > 0:
    leftPaddle.rect.y -= leftPaddle.speed
  if isKeyDown(KeyboardKey.S) and leftPaddle.rect.y < screenHeight - paddleHeight:
    leftPaddle.rect.y += leftPaddle.speed
  
  # Update AI-controlled right paddle
  updateAI()

  # Move ball
  ball.position.x += ball.speed.x
  ball.position.y += ball.speed.y

  # Ball collisions
  if ball.position.y <= 0 or ball.position.y >= screenHeight:
    ball.speed.y *= -1

  # Paddle collisions
  if checkCollisionCircleRec(ball.position, ball.radius, leftPaddle.rect) or
     checkCollisionCircleRec(ball.position, ball.radius, rightPaddle.rect):
    ball.speed.x *= -1.1  # Increase speed slightly on each hit

  # Scoring
  if ball.position.x <= 0:
    rightScore += 1
    ball.position = Vector2(x: screenWidth/2, y: screenHeight/2)
  elif ball.position.x >= screenWidth:
    leftScore += 1
    ball.position = Vector2(x: screenWidth/2, y: screenHeight/2)

proc drawGame() =
  beginDrawing()
  clearBackground(BLACK)

  # Draw paddles
  drawRectangle(leftPaddle.rect, WHITE)
  drawRectangle(rightPaddle.rect, WHITE)

  # Draw ball
  drawCircle(ball.position, ball.radius, WHITE)

  # Draw scores
  drawText($leftScore, screenWidth div 4, 20, 40, WHITE)
  drawText($rightScore, 3 * screenWidth div 4, 20, 40, WHITE)

  # Draw middle line
  drawLine(screenWidth div 2, 0, screenWidth div 2, screenHeight, WHITE)

  # Draw AI label
  let xPos = int(rightPaddle.rect.x) - 30
  let yPos = int(rightPaddle.rect.y) + int(paddleHeight/2) - 10
  let textAI: cstring = "AI";
  drawText(textAI, xPos.int32, yPos.int32, 20.int32, WHITE)

  #drawText(textAI, xPos, yPos, 20, RED)

  endDrawing()

# Main game loop
initWindow(screenWidth, screenHeight, "Raylib Nim Pong with AI")
setTargetFPS(60)

initGame()

while not windowShouldClose():
  updateGame()
  drawGame()

closeWindow()