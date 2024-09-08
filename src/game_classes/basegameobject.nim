import raylib 

type
  BaseGameObject* = ref object of RootObj
    position*: Vector3
    rotation*: float32
    scale*: Vector3
    color*: Color
    name*: string
    objectType*: string
    deltaTime*: float
    children*: seq[BaseGameObject]


proc newBaseGameObject*(
  position: Vector3 = Vector3(x: 0, y: 0, z: 0),
  rotation: float32 = 0,
  scale: Vector3 = Vector3(x: 1, y: 1, z:1),
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

proc update(gameObject: BaseGameObject,newTime :float) =
  gameObject.deltaTime = newTime
  for child in gameObject.children:
    update(child,newTime)  
proc addChild*(parent: BaseGameObject, child: BaseGameObject) =
  parent.children.add(child)

proc removeChild*(parent: BaseGameObject, child: BaseGameObject) =
  parent.children.delete(parent.children.find(child))


