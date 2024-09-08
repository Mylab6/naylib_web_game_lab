import raylib, rlgl
import os
import std/logging

var logger = newConsoleLogger()

type
  RenderMode* = enum
    None, Cube, Sphere, Cylinder, Plane, Model

  BaseGameObject* = ref object of RootObj
    position*: Vector3
    rotation*: Vector3
    scale*: Vector3
    color*: Color
    name*: string
    objectType*: string
    deltaTime*: float
    children*: seq[BaseGameObject]
    model*: Model
    renderMode*: RenderMode
    rotateSpeed*: float32
    rotationAngle*: float

proc newBaseGameObject*(
  position: Vector3 = Vector3(x: 0, y: 0, z: 0),
  rotation: Vector3 = Vector3(x: 0, y: 0, z: 0),
  scale: Vector3 = Vector3(x: 1, y: 1, z:1),
  color: Color = WHITE,
  name: string = "",
  objectType: string = "",
  renderMode: RenderMode = None
): BaseGameObject =
  BaseGameObject(
    position: position,
    rotation: rotation,
    scale: scale,
    color: color,
    name: name,
    objectType: objectType,
    children: @[],
    renderMode: renderMode
  )

proc update(gameObject: BaseGameObject, newTime: float) =
  gameObject.deltaTime = newTime
  for child in gameObject.children:
    update(child, newTime)

proc addChild*(parent: BaseGameObject, child: BaseGameObject) =
  parent.children.add(child)

proc removeChild*(parent: BaseGameObject, child: BaseGameObject) =
  parent.children.delete(parent.children.find(child))

proc loadModel*(gameObject: BaseGameObject, modelName: string) =
  let resourcePath = joinPath("src/resources", "models", modelName)
  if fileExists(resourcePath):
    gameObject.model = loadModel(resourcePath)
    gameObject.renderMode = Model
  else:
    logger.log(lvlError, "Model file not found: " & resourcePath)

proc drawGameObject*(gameObject: BaseGameObject, camera: Camera3D, deltaTime: float32)  =
  pushMatrix()
  translatef(gameObject.position.x, gameObject.position.y, gameObject.position.z)
  rotatef(gameObject.rotation.x, 1, 0, 0)
  rotatef(gameObject.rotation.y, 0, 1, 0)
  rotatef(gameObject.rotation.z, 0, 0, 1)
  scalef(gameObject.scale.x, gameObject.scale.y, gameObject.scale.z)

  case gameObject.renderMode:
    of None:
      discard
    of Cube:
      drawCube(Vector3(x: 0, y: 0, z: 0), 1, 1, 1, gameObject.color)
    of Sphere:
      drawSphere(Vector3(x: 0, y: 0, z: 0), 0.5, gameObject.color)
    of Cylinder:
      drawCylinder(Vector3(x: 0, y: 0, z: 0), 0.5, 0.5, 1, 16, gameObject.color)
    of Plane:
      drawPlane(Vector3(x: 0, y: 0, z: 0), Vector2(x: 1, y: 1), gameObject.color)
    of Model:
      if not gameObject.model.isModelReady:
        drawModel(gameObject.model, Vector3(x: 0, y: 0, z: 0), 1.0, gameObject.color)

  popMatrix()

  # Draw children
  for child in gameObject.children:
    child.drawGameObject(camera, deltaTime)

proc setRenderMode*(gameObject: BaseGameObject, mode: RenderMode) =
  gameObject.renderMode = mode

proc rotateGameObject*(gameObject: BaseGameObject) =
  gameObject.rotateSpeed = 1
  gameObject.rotationAngle += gameObject.rotateSpeed
  logger.log(lvlInfo, "Rotation Angle: " & $gameObject.rotationAngle)
  gameObject.rotation.x += gameObject.rotateSpeed
  gameObject.rotation.y += gameObject.rotateSpeed
  gameObject.rotation.z += gameObject.rotateSpeed