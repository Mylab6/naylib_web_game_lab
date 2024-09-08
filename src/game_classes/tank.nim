import raylib

type
    Tank = object
        position: Vector3
        color: Color
        size: Vector3
        speed: float
        texture: Texture2D
        sound: Sound
        bossType: string
        health: int
        damage: int