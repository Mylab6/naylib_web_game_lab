import raylib, game_classes/basegameobject

type

  GameState* = ref object
    objects*: seq[BaseGameObject]
    camera*: Camera3D
    currentLevel*: int
    # Add more state variables as needed

proc newGameState*(): GameState =
  result = GameState(
    objects: @[])
    

proc addObject*(state: GameState, obj: BaseGameObject) =
  state.objects.add(obj)

proc updateGameState*(state: GameState) =
  # Update game logic here
  for obj in state.objects:
    # Update each object
    discard

  # Example: Update camera position
  state.camera.position = Vector3(x: state.camera.position.x, y: state.camera.position.y, z: state.camera.position.z - 0.1)

