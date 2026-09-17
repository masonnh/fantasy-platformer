extends MobBaseClass

@onready var anim_spr: AnimatedSprite2D = $AnimatedSprite2D

var direction := Vector2(-1,0)


func _ready() -> void:
	init_mob(1, 1, 100)


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move(direction, delta)
	if direction.x > 0:
		anim_spr.flip_h = true
	else:
		anim_spr.flip_h = false


func _on_walk_timer_timeout() -> void:
	direction.x *= -1
