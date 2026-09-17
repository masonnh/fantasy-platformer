extends Node2D
@onready var hud: CanvasLayer = $Hud
@onready var heart_container: HBoxContainer = $Hud/HeartContainer

var heart_size = 42


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_hud_hearts(3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## Updates the health in the hud
func update_hud_hearts(health: int) -> void:
	var curr_hearts = heart_container.get_children().size()
	
	# Add hearts until hearts = health
	if curr_hearts < health:
		while curr_hearts < health:
			var heart = TextureRect.new()
			heart.texture = preload("res://assets/images/hud/heart.png")
			heart.custom_maximum_size = Vector2(heart_size, heart_size)
			heart.custom_minimum_size = Vector2(heart_size, heart_size)
			heart_container.add_child(heart)
			curr_hearts += 1
	
	# Remove hearts until hearts = health
	else:
		while curr_hearts > health:
			heart_container.get_child(0).queue_free()
			curr_hearts -= 1


func _on_player_update_health(health: int) -> void:
	update_hud_hearts(health)
