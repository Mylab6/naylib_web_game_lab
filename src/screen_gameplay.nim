# ****************************************************************************************
#
#   raylib - Advance Game template
#
#   Gameplay Screen Functions Definitions (Init, Update, Draw, Unload)
#
#   Copyright (c) 2014-2022 Ramon Santamaria (@raysan5)
#
#   This software is provided "as-is", without any express or implied warranty. In no event
#   will the authors be held liable for any damages arising from the use of this software.
#
#   Permission is granted to anyone to use this software for any purpose, including commercial
#   applications, and to alter it and redistribute it freely, subject to the following restrictions:
#
#     1. The origin of this software must not be misrepresented; you must not claim that you
#     wrote the original software. If you use this software in a product, an acknowledgment
#     in the product documentation would be appreciated but is not required.
#
#     2. Altered source versions must be plainly marked as such, and must not be misrepresented
#     as being the original software.
#
#     3. This notice may not be removed or altered from any source distribution.
#
# ****************************************************************************************

import raylib, screens, std/lenientops, game_classes/tank_spawner

# ----------------------------------------------------------------------------------------
# Module Variables Definition (local)
# ----------------------------------------------------------------------------------------

var
  framesCounter: int32 = 0
  finishScreen: int32 = 0

# ----------------------------------------------------------------------------------------
# Gameplay Screen Functions Definition
# ----------------------------------------------------------------------------------------

proc initGameplayScreen* =
  # Gameplay Screen Initialization logic
  # TODO: Initialize GAMEPLAY screen variables here!
  framesCounter = 0
  finishScreen = 0

proc updateGameplayScreen* =
  # Gameplay Screen Update logic
  # TODO: Update GAMEPLAY screen variables here!
  # Press enter or tap to change to ENDING screen
  if isKeyPressed(Enter) or isGestureDetected(Tap):
    finishScreen = 1
    playSound(fxCoin)

proc drawGameplayScreen* =
  # Gameplay Screen Draw logic
  # TODO: Draw GAMEPLAY screen here!
  drawRectangle(0, 0, getScreenWidth(), getScreenHeight(), Purple)
  drawText(font, "GAMEPLAY SCREEN", Vector2(x: 20, y: 10), font.baseSize*3'f32, 4, Maroon)
  var camera: Camera
  # Init the camera pleas e
  camera.position = Vector3(x: 10.0, y: 10.0, z: 10.0)
  camera.target = Vector3(x: 0.0, y: 2.0, z: 0.0)
  camera.up = Vector3(x: 0.0, y: 1.0, z: 0.0)
  camera.fovy = 45.0
  camera.projection = CameraProjection.Perspective

  beginMode3D(camera)
  #Add a spawner 
  var spawner: TankSpawner
  spawner.position = Vector2(x: 0, y: 0)
  spawner.color = Red
  spawner.size = Vector2(x: 2, y: 2)
  spawner.speed = 1.0
  
  drawCube(Vector3(x: 0, y: 1, z: 0), 2.0, 2.0, 2.0, Red)
  drawCubeWires(Vector3(x: 0, y: 1, z: 0), 2.0, 2.0, 2.0, Maroon)
  drawGrid(10, 1.0)
  endMode3D()
  drawText("PRESS ENTER or TAP to JUMP to ENDING SCREEN", 130, 220, 20, Maroon)

proc unloadGameplayScreen* =
  # Gameplay Screen Unload logic
  # TODO: Unload GAMEPLAY screen variables here!
  discard

proc finishGameplayScreen*: int32 =
  # Gameplay Screen should finish?
  return finishScreen
