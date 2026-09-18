class_name MobBaseClass
extends Area2D

# Mob stats
var health: int
var attack_power: int
var speed: int


## Called when a mob instance is created to initialize values
func init_mob(health_init: int = 1, attack_power_init: int = 1, speed_init: int = 200) -> void:
	health = health_init
	attack_power = attack_power_init
	speed = speed_init


## Subtracts mob health by damage_amt
func take_damage(damage_amt: int) -> void:
	health -= damage_amt
	if health <= 0:
		die()


## Removes mob from scene
func die() -> void:
	queue_free()


## Takes direction and delta, and moves the mob according to speed
func move(direction: Vector2, delta: float) -> void:
	position.x += direction.x * speed * delta
	position.y += direction.y * speed * delta
