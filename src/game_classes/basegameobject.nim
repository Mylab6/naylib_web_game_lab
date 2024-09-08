import raylib , raymath, std/math
import os


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
    mesh*: Mesh
    model*: Model
    renderMode*: RenderMode

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
  gameObject.model = loadModel(resourcePath)
  gameObject.renderMode = Model

proc drawGameObject*(gameObject: BaseGameObject, camera: Camera3D, deltaTime: float32)  =
  case gameObject.renderMode:
    of None:
      discard
    of Cube:
      drawCube(gameObject.position, gameObject.scale, gameObject.color)
    of Sphere:
      drawSphere(gameObject.position, gameObject.scale.x, gameObject.color)
    of Cylinder:
      drawCylinder(gameObject.position, gameObject.scale.x, gameObject.scale.y, gameObject.scale.z, 16, gameObject.color)
    of Plane:
      drawPlane(gameObject.position, Vector2(x: gameObject.scale.x, y: gameObject.scale.z), gameObject.color)
    of Model:
      if gameObject.model.isModelReady:
        drawModel(gameObject.model, gameObject.position, 1.0, gameObject.color)
      # I don't know howto do this yet 


  # Draw children
  for child in gameObject.children:
    child.drawGameObject(camera, deltaTime)

proc setRenderMode*(gameObject: BaseGameObject, mode: RenderMode) =
  gameObject.renderMode = mode

proc rotateGameObject*(gameObject: BaseGameObject, axis: Vector3, speed: float32) =
  let rotationAmount = speed * gameObject.deltaTime
  
  gameObject.rotation.x += axis.x * rotationAmount
  gameObject.rotation.y += axis.y * rotationAmount
  gameObject.rotation.z += axis.z * rotationAmount

  # Normalize rotation angles
  #gameObject.rotation.x = gameObject.rotation.x mod 360
  #gameObject.rotation.y = gameObject.rotation.y mod 360
  #gameObject.rotation.z = gameObject.rotation.z mod 360