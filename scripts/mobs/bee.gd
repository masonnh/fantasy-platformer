extends MobBaseClass

@onready var anim_spr: AnimatedSprite2D = $AnimatedSprite2D
@onready var behavior_timer: Timer = $BehaviorTimer

var direction := Vector2(0,0)


func _ready() -> void:
	init_mob(1, 3, 300)


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move(direction, delta)
	if direction.x > 0:
		anim_spr.flip_h = true
	else:
		anim_spr.flip_h = false


func attack(player_direction: Vector2) -> void:
	anim_spr.animation = "attacking"
	direction.y = player_direction.y
	behavior_timer.wait_time = 2
	behavior_timer.start()


func _on_attack_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player_direction = position.direction_to(body.global_position)
		attack(player_direction)


func _on_behavior_timer_timeout() -> void:
	anim_spr.animation = "idle"
	direction.y *= -1
	behavior_timer.wait_time = 2
	behavior_timer.start()
