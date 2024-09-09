import raylib , basegameobject

type
    Tank* = ref object of  BaseGameObject
        speed*: float
        texture*: Texture2D
        sound*: Sound
        health*: int
        damage*: int
        tankType*: string