import raylib
import moving_cube
import random
import renderableobject

const
  screenWidth = 800
  screenHeight = 450
var camera: Camera 

var cubes: seq[RenderableObject]
proc addCube(): RenderableObject =
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
  
  let cube = newRenderableObject(
    initialPos = initialPos,
    size = Vector3(x: 2, y: 2, z: 2),
    color = color,
    wireColor = Maroon,
    speed = rand(0.1..5.62), 
    rotSpeed = 0.05
  )
  return cube
proc updateDrawFrame {.cdecl.} =

    
  beginDrawing()
  clearBackground(RayWhite)
      
  beginMode3D(camera)
  for cube in cubes:
    cube.update( getFrameTime())
    #cube.update()
    cube.draw()
    #cube.drawTargetPoints()
  drawGrid(10, 1.0)
  endMode3D()
      
  drawText("Cube moving and rotating", 10, 40, 20, DarkGray)
  drawFPS(10, 10)
      
  endDrawing()

proc main() =

  initWindow(screenWidth, screenHeight, "Raylib Nim - Moving Rotating Cube")
  camera = Camera()
  cubes = @[]
  for i in 0..<10:
    cubes.add(addCube())
  let ball:RenderableObject = addCube()
  ball.primitiveType = ptSphere
  cubes[0].addChild(ball)
  camera.position = Vector3(x: 0, y: 20, z: -6)
  camera.target = Vector3(x: 0, y: 0, z: 0)
  camera.up = Vector3(x: 0, y: 0, z: -1)
  camera.fovy = 45
  camera.projection = CameraProjection.Perspective
  defer: closeWindow()
  when defined(emscripten):
      emscriptenSetMainLoop(updateDrawFrame, 60, 1)
  else:
      setTargetFPS(60) # Set our game to run at 60 frames-per-second
      # ----------------------------------------------------------------------------------
      # Main game loop
      while not windowShouldClose(): # Detect window close button or ESC key
        updateDrawFrame()
    #setTargetFPS(60)




when isMainModule:
  main()