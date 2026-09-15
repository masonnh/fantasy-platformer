extends CharacterBody2D


@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health := 3
var attack_power := 1
var attacking := false


func _physics_process(delta: float) -> void:
	
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
		else:
			anim_sprite.flip_h = true
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
	if Input.is_action_just_pressed("attack"):
		attack()

	move_and_slide()


## Handles the player's attack state
func attack() -> void:
	attacking = true
	anim_sprite.animation = "attacking"


## Reduces the player's health by hp_to_sub
func reduce_health(hp_to_sub: int) -> void:
	health -= hp_to_sub


func _on_animated_sprite_2d_animation_looped() -> void:
	if attacking:
		attacking = !attacking
