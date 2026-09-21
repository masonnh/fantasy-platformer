extends MobBaseClass

@onready var anim_spr: AnimatedSprite2D = $AnimatedSprite2D
@onready var behavior_timer: Timer = $BehaviorTimer


var direction := Vector2(0,0)
var is_running = false
var is_walking = false
var is_idle = true

var run_speed = 400


func _ready() -> void:
	init_mob(2, 2, 200)
	idle()


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_off_screen(position):
		direction.x *= -1
		
	move(direction, delta)
	
	if direction.x > 0:
		anim_spr.flip_h = true
	elif direction.x < 0:
		anim_spr.flip_h = false


####################
# Behavior Helpers
####################

func is_off_screen(position: Vector2):
	var viewport = get_viewport_rect()
	return not viewport.has_point(position)


func move(direction: Vector2, delta: float) -> void:
	if is_running:
		position.x += direction.x * run_speed * delta
		position.y += direction.y * run_speed * delta
	else:
		position.x += direction.x * speed * delta
		position.y += direction.y * speed * delta
	


## Makes the boar idle
func idle():
	is_idle = true
	anim_spr.animation = "idle"
	direction.x = 0


## Makes the boar walk in a random direction
func walk():
	is_walking = true
	anim_spr.animation = "walking"
	direction.x = -1 if randf() > 0.5 else 1


## Makes the boar run at the player for 3 seconds
func run(player_direction: Vector2):
	is_running = true
	anim_spr.animation = "running"
	direction.x = player_direction.x
	behavior_timer.wait_time = 2
	behavior_timer.start()


####################
# Signal Handlers
####################

func _on_behavior_timer_timeout() -> void:
	behavior_timer.wait_time = randf_range(0.5, 1.0)
	behavior_timer.start()
	
	if is_running:
		is_running = false
	
	if is_idle:
		is_idle = false
		walk()
	else:
		is_walking = false
		idle()


func _on_charge_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_idle = false
		is_walking = false
		var player_direction = position.direction_to(body.global_position)
		run(player_direction)
