import raylib
import naylibgui
import block_dodge
import pong

const
  screenWidth = 800
  screenHeight = 450

type
  GameState = enum
    gsMenu, gsBlockDodge, gsPong

var
  gameState: GameState = gsMenu
  currentGame: int32 = 0
  dropdownActive: bool = false
  showExitDialog: bool = false

proc drawMenu() =
  clearBackground(Green)
  
  # Title
  guiSetStyle(LABEL, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
  guiLabel(Rectangle(x: 0, y: 50, width: float32(screenWidth), height: 40), "Mini-Games Collection")

  # Game selection dropdown
  guiSetStyle(DROPDOWNBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
  if guiDropdownBox(
    Rectangle(x: float32(screenWidth)/2 - 100, y: 150, width: 200, height: 30),
    "Select a game;Block Dodge;Pong",
    currentGame,
    dropdownActive
  ) != 0:
    dropdownActive = not dropdownActive

  # Start game button
  if guiButton(Rectangle(x: float32(screenWidth)/2 - 60, y: 200, width: 120, height: 30), "Start Game") != 0:
    case currentGame:
      of 1:
        gameState = gsBlockDodge
        initBlockDodge()
      of 2:
        gameState = gsPong
        initPong()
      else:
        discard

  # Exit button
  if guiButton(Rectangle(x: float32(screenWidth)/2 - 60, y: 250, width: 120, height: 30), "Exit") != 0:
    showExitDialog = true

  # Footer
  guiSetStyle(LABEL, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
  guiLabel(Rectangle(x: 0, y: float32(screenHeight) - 30, width: float32(screenWidth), height: 30), "© 2023 Your Game Studio")

proc drawExitDialog() =
  drawRectangle(0, 0, screenWidth, screenHeight, fade(RAYWHITE, 0.8))
  let result = guiMessageBox(
    Rectangle(x: float32(screenWidth)/2 - 125, y: float32(screenHeight)/2 - 50, width: 250, height: 100),
    guiIconText(ICON_EXIT, "Exit Game"),
    "Are you sure you want to exit?",
    "Yes;No"
  )

  if result == 0 or result == 2:
    showExitDialog = false
  elif result == 1:
    closeWindow()

proc main() =
  initWindow(screenWidth, screenHeight, "Mini-Games Collection")
  setTargetFPS(60)

  # Load custom font (optional)
  # let customFont = loadFont("path/to/your/font.ttf")
  # guiSetFont(customFont)

  # Load custom style (optional)
  # guiLoadStyleDefault()

  while not windowShouldClose():
    beginDrawing()

    case gameState:
      of gsMenu:
        drawMenu()
        if showExitDialog:
          drawExitDialog()
      of gsBlockDodge:
        if updateBlockDodge():
          gameState = gsMenu
        drawBlockDodge()
      of gsPong:
        if updatePong():
          gameState = gsMenu
        drawPong()

    # Back to menu button (when in a game)
    if gameState != gsMenu:
      if guiButton(Rectangle(x: 10, y: 10, width: 100, height: 30), "Back to Menu") != 0:
        gameState = gsMenu

    endDrawing()

  closeWindow()

main()