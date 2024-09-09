import raylib, rlgl
import math

type
  MovingCube* = ref object
    position*: Vector3
    size*: Vector3
    color*: Color
    wireColor*: Color
    movementSpeed*: float32
    rotationSpeed*: float32
    rotation*: Vector3
    targetPoints*: array[4, Vector3]
    currentTargetIndex*: int
    isRotating*: bool

proc newMovingCube*(initialPos: Vector3, size: Vector3, color, wireColor: Color, speed, rotSpeed: float32): MovingCube =
  result = MovingCube(
    position: initialPos,
    size: size,
    color: color,
    wireColor: wireColor,
    movementSpeed: speed,
    rotationSpeed: rotSpeed,
    rotation: Vector3(x: 0, y: 0, z: 0),
    currentTargetIndex: 0,
    isRotating: true
  )
  # Define the four target points
  result.targetPoints = [
    Vector3(x: 5, y: 0, z: 5),
    Vector3(x: -5, y: 0, z: 5),
    Vector3(x: -5, y: 0, z: -5),
    Vector3(x: 5, y: 0, z: -5)
  ]

proc getDirection(cube: MovingCube): Vector3 =
  let target = cube.targetPoints[cube.currentTargetIndex]
  result = Vector3(
    x: target.x - cube.position.x,
    y: target.y - cube.position.y,
    z: target.z - cube.position.z
  )
  let length = sqrt(result.x * result.x + result.y * result.y + result.z * result.z)
  if length != 0:
    result.x /= length
    result.y /= length
    result.z /= length

proc update*(cube: MovingCube) =
  let direction = cube.getDirection()
  let targetAngle = arctan2(direction.z, direction.x)
  let currentAngle = cube.rotation.y
  
  if cube.isRotating:
    # Rotate towards the target
    let angleDiff = targetAngle - currentAngle
    if abs(angleDiff) > 0.01:
      cube.rotation.y += float32(sgn(angleDiff)) * min(abs(angleDiff), cube.rotationSpeed)
    else:
      cube.isRotating = false
  else:
    # Move towards the target
    cube.position.x += direction.x * cube.movementSpeed
    cube.position.z += direction.z * cube.movementSpeed
    
    # Check if we've reached the target (with some tolerance)
    let distanceToTarget = sqrt(
      (cube.targetPoints[cube.currentTargetIndex].x - cube.position.x)^2 +
      (cube.targetPoints[cube.currentTargetIndex].z - cube.position.z)^2
    )
    if distanceToTarget < 0.1:
      cube.currentTargetIndex = (cube.currentTargetIndex + 1) mod 4
      cube.isRotating = true

proc draw*(cube: MovingCube) =
  pushMatrix()
  translatef(cube.position.x, cube.position.y, cube.position.z)
  rotatef(cube.rotation.y * 180 / PI, 0, 1, 0)  # Convert radians to degrees
  drawCube(Vector3(x: 0, y: 0, z: 0), cube.size.x, cube.size.y, cube.size.z, cube.color)
  drawCubeWires(Vector3(x: 0, y: 0, z: 0), cube.size.x, cube.size.y, cube.size.z, cube.wireColor)
  popMatrix()

proc drawTargetPoints*(cube: MovingCube) =
  for point in cube.targetPoints:
    drawSphere(point, 0.2, Yellow)