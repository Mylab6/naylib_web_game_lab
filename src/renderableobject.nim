import raylib, rlgl
import math

type
  PrimitiveType* = enum
    ptCube, ptSphere, ptCylinder, ptPlane, ptTorus, ptModel

  RenderableObject* = ref object of RootObj
    position*: Vector3
    size*: Vector3
    color*: Color
    wireColor*: Color
    movementSpeed*: float32
    rotationSpeed*: float32
    rotation*: Vector3
    moveDirection*: Vector3
    children*: seq[RenderableObject]
    primitiveType*: PrimitiveType
    modelPath*: string
    model*: Model

proc newRenderableObject*(initialPos, size: Vector3, color, wireColor: Color, speed, rotSpeed: float32, 
                          primitiveType: PrimitiveType = ptCube, modelPath: string = ""): RenderableObject =
  result = RenderableObject(
    position: initialPos,
    size: size,
    color: color,
    wireColor: wireColor,
    movementSpeed: speed,
    rotationSpeed: rotSpeed,
    rotation: Vector3(x: 0, y: 0, z: 0),
    moveDirection: Vector3(x: 1, y: 0, z: 0),  # Default movement direction
    children: @[],
    primitiveType: primitiveType,
    modelPath: modelPath
  )
  if primitiveType == ptModel and modelPath != "":
    result.model = loadModel(modelPath)

proc addChild*(self: RenderableObject, child: RenderableObject) =
  self.children.add(child)

proc removeChild*(self: RenderableObject, child: RenderableObject) =
  let index = self.children.find(child)
  if index != -1:
    self.children.delete(index)

proc update*(self: RenderableObject, deltaTime: float32) =
  # Move the object
  self.position.x += self.moveDirection.x * self.movementSpeed * deltaTime
  self.position.y += self.moveDirection.y * self.movementSpeed * deltaTime
  self.position.z += self.moveDirection.z * self.movementSpeed * deltaTime

  # Rotate the object
  self.rotation.y += self.rotationSpeed * deltaTime

  # Simple bouncing logic
  if abs(self.position.x) > 5:  # Assuming a boundary of -5 to 5
    self.moveDirection.x *= -1
  if abs(self.position.z) > 5:  # Assuming a boundary of -5 to 5
    self.moveDirection.z *= -1

  # Update children
  for child in self.children:
    child.update(deltaTime)

proc drawPrimitive(self: RenderableObject, position: Vector3) =
  case self.primitiveType:
    of ptCube:
      drawCube(position, self.size.x, self.size.y, self.size.z, self.color)
      drawCubeWires(position, self.size.x, self.size.y, self.size.z, self.wireColor)
    of ptSphere:
      drawSphere(position, self.size.x / 2, self.color)
      drawSphereWires(position, self.size.x / 2, 16, 16, self.wireColor)
    of ptCylinder:
      drawCylinder(position, self.size.x / 2, self.size.x / 2, self.size.y, 16, self.color)
      drawCylinderWires(position, self.size.x / 2, self.size.x / 2, self.size.y, 16, self.wireColor)
    of ptPlane:
      drawPlane(position, Vector2(x: self.size.x, y: self.size.z), self.color)
    of ptTorus:
      return
      #drawTorus(position, self.size.x, self.size.y, 16, 16, self.color)
      #drawTorusWires(position, self.size.x, self.size.y, 16, 16, self.wireColor)
    of ptModel:
      if not self.model.isModelReady:
        drawModel(self.model, position, 1.0, self.color)

proc draw*(self: RenderableObject, parentPosition: Vector3 = Vector3(x: 0, y: 0, z: 0)) =
  let globalPosition = Vector3(
    x: parentPosition.x + self.position.x,
    y: parentPosition.y + self.position.y,
    z: parentPosition.z + self.position.z
  )

  pushMatrix()
  translatef(globalPosition.x, globalPosition.y, globalPosition.z)
  rotatef(self.rotation.y * 180 / PI, 0, 1, 0)
  rotatef(self.rotation.x * 180 / PI, 1, 0, 0)
  rotatef(self.rotation.z * 180 / PI, 0, 0, 1)
  
  self.drawPrimitive(Vector3(x: 0, y: 0, z: 0))
  
  popMatrix()

  # Draw children relative to this object's position
  for child in self.children:
    child.draw(globalPosition)

