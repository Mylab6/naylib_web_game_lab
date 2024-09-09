import raylib
import math

type
  MovableObject* = ref object of RootObj
    position*: Vector3
    rotation*: Vector3
    scale*: Vector3
    movementSpeed*: float32
    rotationSpeed*: float32
    children*: seq[MovableObject]

proc newMovableObject*(position: Vector3 = Vector3(x: 0, y: 0, z: 0),
                       rotation: Vector3 = Vector3(x: 0, y: 0, z: 0),
                       scale: Vector3 = Vector3(x: 1, y: 1, z: 1),
                       movementSpeed: float32 = 0.1,
                       rotationSpeed: float32 = 0.1): MovableObject =
  result = MovableObject(
    position: position,
    rotation: rotation,
    scale: scale,
    movementSpeed: movementSpeed,
    rotationSpeed: rotationSpeed,
    children: @[]
  )

proc addChild*(self: MovableObject, child: MovableObject) =
  self.children.add(child)

proc removeChild*(self: MovableObject, child: MovableObject) =
  let index = self.children.find(child)
  if index != -1:
    self.children.delete(index)

proc move*(self: MovableObject, direction: Vector3) =
  self.position.x += direction.x * self.movementSpeed
  self.position.y += direction.y * self.movementSpeed
  self.position.z += direction.z * self.movementSpeed
  
  for child in self.children:
    child.move(direction)

proc rotate*(self: MovableObject, axis: Vector3, angle: float32) =
  self.rotation.x += axis.x * angle * self.rotationSpeed
  self.rotation.y += axis.y * angle * self.rotationSpeed
  self.rotation.z += axis.z * angle * self.rotationSpeed
  
  for child in self.children:
    child.rotate(axis, angle)

proc update*(self: MovableObject) =
  # This method can be overridden in subclasses to add custom update logic
  for child in self.children:
    child.update()