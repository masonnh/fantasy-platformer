class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton as Button
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton as Button
@onready var start_level = preload("res://scenes/main.tscn") as PackedScene


func _ready() -> void:
	start_button.button_down.connect(_on_start_pressed)
	exit_button.button_down.connect(_on_exit_pressed)


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)


func _on_exit_pressed() -> void:
	get_tree().quit()
