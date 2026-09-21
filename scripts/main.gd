extends Node2D
@onready var hud: CanvasLayer = $Hud
@onready var heart_container: HBoxContainer = $Hud/HeartContainer

var heart_size := 42
var level := 1
var current_level_root: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_hud_hearts(3)
	await _load_level(level)


###################
# Level Management
###################

## Loads the level based on the level number
func _load_level(level_number: int) -> void:
	# If there's a current level, delete it
	if current_level_root:
		current_level_root.queue_free()
	
	# Load the next level
	var level_path = "res://scenes/levels/level%s.tscn" % level_number
	var lvl_scene = load(level_path) as PackedScene
	current_level_root = lvl_scene.instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)


## Sets up the level based on the level root
func _setup_level(level_root: Node) -> void:
	var player = level_root.get_node_or_null("Player")
	if player is Player:
		var p: Player = player as Player
		p.update_health.connect(_on_player_update_health)
		p.exit_level.connect(_on_player_exit_level)


###################
# Signal Handlers
###################

## Signal to update player health in hud
func _on_player_update_health(health: int) -> void:
	update_hud_hearts(health)


## Signal to proceed to next level after finishing current level
func _on_player_exit_level() -> void:
	level += 1
	_load_level(level)


###################
# HUD Helpers
###################

## Updates the health in the hud
func update_hud_hearts(health: int) -> void:
	var curr_hearts = heart_container.get_child_count()
	var loops = 0
	
	# Add hearts until hearts = health
	if curr_hearts < health:
		var heart_diff = health - curr_hearts
		for i in heart_diff:
			var heart = TextureRect.new()
			heart.texture = preload("res://assets/images/hud/heart.png")
			heart.custom_maximum_size = Vector2(heart_size, heart_size)
			heart.custom_minimum_size = Vector2(heart_size, heart_size)
			heart_container.add_child(heart)
	
	# Remove hearts until hearts = health
	else:
		var heart_diff = curr_hearts - health
		for i in heart_diff:
			heart_container.get_child(i).queue_free()
