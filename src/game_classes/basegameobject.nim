import raylib

type
  BaseGameObject* = ref object of RootObj
    position*: Vector2
    rotation*: float32
    scale*: Vector2
    color*: Color
    name*: string
    objectType*: string
    children*: seq[BaseGameObject]

proc newBaseGameObject*(
  position: Vector2 = Vector2(x: 0, y: 0),
  rotation: float32 = 0,
  scale: Vector2 = Vector2(x: 1, y: 1),
  color: Color = WHITE,
  name: string = "",
  objectType: string = ""
): BaseGameObject =
  BaseGameObject(
    position: position,
    rotation: rotation,
    scale: scale,
    color: color,
    name: name,
    objectType: objectType,
    children: @[]
  )

proc addChild*(parent: BaseGameObject, child: BaseGameObject) =
  parent.children.add(child)

proc removeChild*(parent: BaseGameObject, child: BaseGameObject) =
  parent.children.delete(parent.children.find(child))

# Example usage
when isMainModule:
  let gameObject = newBaseGameObject(
    position = Vector2(x: 100, y: 100),
    rotation = 45,
    scale = Vector2(x: 2, y: 2),
    color = RED,
    name = "Player",
    objectType = "Character"
  )
  
  echo "Created game object: ", gameObject.name
  echo "Position: ", gameObject.position
  echo "Rotation: ", gameObject.rotation
  echo "Scale: ", gameObject.scale
  echo "Color: ", gameObject.color