class_name Player
extends CharacterBody2D

signal update_health
signal exit_level

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_collision: CollisionShape2D = $Hitbox/HitboxCollision
@onready var hitbox: Area2D = $Hitbox

# Player consts
const SPEED = 400.0
const JUMP_VELOCITY = -500.0

# Player stats
var health := 3
var attack_power := 1

# Player state
var alive = true
var attacking := false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Handle restart level.
	if Input.is_action_just_pressed("restart_level"):
		get_tree().reload_current_scene()

	# Everything below can only happen if player is alive
	if !alive:
		return 
	
	if is_on_floor() and velocity.x == 0 and not attacking:
		anim_sprite.animation = "idle"
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		anim_sprite.animation = "running"
		if velocity.x > 0:
			anim_sprite.flip_h = false
			flip_hitbox()
		else:
			anim_sprite.flip_h = true
			flip_hitbox()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		anim_sprite.animation = "falling"

	# Handle jump.
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim_sprite.animation = "jumping"
		
	# Handle attack.
	if Input.is_action_just_pressed("attack") and is_on_floor():
		attack()

	move_and_slide()


## Flips the player attack hitbox across the y axis
func flip_hitbox() -> void:
	hitbox.position.x *= -1


## Handles the player's attack state
func attack() -> void:
	attacking = true
	anim_sprite.animation = "attacking"
	hitbox_collision.disabled = false


## Adds to player's health by health_amt
func add_health(health_amt) -> void:
	if !alive:
		return

	health += health_amt
	update_health.emit(health)

## Reduces the player's health by damage_amt
func take_damage(damage_amt: int) -> void:
	if !alive:
		return

	health -= damage_amt
	update_health.emit(health)
	if health <= 0:
		die()


## Handles player death
func die() -> void:
	alive = false
	anim_sprite.sprite_frames.set_animation_loop("dying", false)
	anim_sprite.animation = "dying"


func _on_animated_sprite_2d_animation_looped() -> void:
	if attacking:
		attacking = false
		hitbox_collision.disabled = true


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is MobBaseClass:
		var mob = area as MobBaseClass
		mob.take_damage(attack_power)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is MobBaseClass:
		var mob = area as MobBaseClass
		take_damage(mob.attack_power)
	
	elif area.name == "Heart":
		add_health(1)
		area.queue_free()


func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		exit_level.emit()
