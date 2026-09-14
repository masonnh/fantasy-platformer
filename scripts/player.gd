extends CharacterBody2D


@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	
	if is_on_floor() and velocity.x == 0:
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

	move_and_slide()
