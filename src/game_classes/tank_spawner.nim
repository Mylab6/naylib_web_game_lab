# Write a class for a tank spawner that can spawn tanks at a given rate.
# Let's go through the requirements:
# - The tank spawner should have a method `spawn` that returns a new tank.
# - The tank spawner should have a method `update` that updates the internal state of the spawner.
# - The tank spawner should have a method `draw` that draws the spawner.
# - The tank spawner should have a method `set_spawn_rate` that sets the spawn rate of the spawner.
# - The tank spawner should have a method `set_position` that sets the position of the spawner.
# - The tank spawner should have a method `set_color` that sets the color of the spawner.
# - The tank spawner should have a method `set_size` that sets the size of the spawner.
# - The tank spawner should have a method `set_speed` that sets the speed of the tanks.
# - The tank spawner should have a method `set_texture` that sets the texture of the tanks.
# - The tank spawner should have a method `set_sound` that sets the sound of the tanks.
# - 3 tank types for now, Red Rammers, Green Shooters, and Blue Tanks 
# - The tank spawner should have a method `set_tank_type` that sets the tank type of the tanks.
# - The tank spawner should have a method `set_tank_health` that sets the health of the tanks.
# - The tank spawner should have a method `set_tank_damage` that sets the damage of the tanks.
# Start writing the code please 
import raylib, tank , basegameobject
import std/logging
import math

var logger = newConsoleLogger()
type
    TankSpawner* = ref object of BaseGameObject
        spawnRate*: float
        size*: Vector3
        speed*: float
        texture*: Texture2D
        sound*: Sound
        tankType*: string
        tankHealth*: int
        tankDamage*: int
        

proc spawnSpawner(spawner: TankSpawner): Tank =
    var tank: Tank
    # Create a new tank with the specified properties
    tank.position = spawner.position
    tank.color = spawner.color
    tank.speed = spawner.speed
    tank.texture = spawner.texture
    tank.sound = spawner.sound
    tank.tankType = spawner.tankType
    tank.health = spawner.tankHealth
    tank.damage = spawner.tankDamage
    return tank


proc updateSpawner(spawner: TankSpawner) =
    logger.log(lvlInfo, "a log message")

    # Update the internal state of the spawner

proc drawSpawner*(spawner: TankSpawner, camera: Camera3D, newTime: float) =  # Draw the spawner base cube
    logger.log(lvlInfo,"test")

proc setSpawnRate(spawner: TankSpawner, rate: float) =
    spawner.spawnRate = rate

proc setPosition(spawner: TankSpawner, position: Vector3) =
    spawner.position = position

proc setColor(spawner: TankSpawner, color: Color) =
    spawner.color = color

proc setSize(spawner: TankSpawner, size: Vector3) =
    spawner.size = size

proc setSpeed(spawner: TankSpawner, speed: float) =
    spawner.speed = speed

proc setTexture(spawner: TankSpawner, texture: Texture2D) =
    spawner.texture = texture

proc setSound(spawner: TankSpawner, sound: Sound) =
    spawner.sound = sound

proc setTankType(spawner: TankSpawner, tankType: string) =
    spawner.tankType = tankType

proc setTankHealth(spawner: TankSpawner, health: int) =
    spawner.tankHealth = health

proc setTankDamage(spawner: TankSpawner, damage: int) =
    spawner.tankDamage = damage



