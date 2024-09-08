import raylib
import moving_cube
import random


const
  screenWidth = 800
  screenHeight = 450
proc addCube(): MovingCube =
  randomize()
 # let randomInt = rand(100)


  var color = Color(
    r: uint8(rand(256)),
    g: uint8(rand(256)),
    b: uint8(rand(256)),
    a: 255
  )
  var initialPos = Vector3(
    x: rand(-10..10).toFloat(),
    y:0,
    z: rand(-10..10).toFloat()
  )
  
  let cube = newMovingCube(
    initialPos = initialPos,
    size = Vector3(x: 2, y: 2, z: 2),
    color = color,
    wireColor = Maroon,
    speed = 0.05,
    rotSpeed = 0.05
  )
  return cube
proc main() =
  initWindow(screenWidth, screenHeight, "Raylib Nim - Moving Rotating Cube")
  defer: closeWindow()

  var camera = Camera()
  camera.position = Vector3(x: 10, y: 10, z: 10)
  camera.target = Vector3(x: 0, y: 0, z: 0)
  camera.up = Vector3(x: 0, y: 1, z: 0)
  camera.fovy = 45
  camera.projection = CameraProjection.Perspective
  #Create an array for 20 cubes 
  var cubes: seq[MovingCube] = @[]
  for i in 0 .. 3000:
    cubes.add(addCube())
 

  setTargetFPS(60)

  while not windowShouldClose():
#    cube.update()

    beginDrawing()
    clearBackground(RayWhite)
    
    beginMode3D(camera)
 #   cube.draw()
  #  cube.drawTargetPoints()
    for cube in cubes:
      cube.update()
      cube.draw()
      cube.drawTargetPoints()
    drawGrid(10, 1.0)
    endMode3D()
    
    drawText("Cube moving and rotating", 10, 40, 20, DarkGray)
    drawFPS(10, 10)
    
    endDrawing()

when isMainModule:
  main()