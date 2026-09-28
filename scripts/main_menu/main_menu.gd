class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton as Button
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton as Button
@onready var options_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/OptionsButton as Button
@onready var start_level = preload("res://scenes/main.tscn") as PackedScene
@onready var options_menu: OptionsMenu = $OptionsMenu as OptionsMenu
@onready var margin_container: MarginContainer = $MarginContainer as MarginContainer


func _ready() -> void:
	handle_connecting_signals()


## Change scene to main when start pressed
func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)


## Display options menu when pressed
func _on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true


## Quit game when exit button pressed
func _on_exit_pressed() -> void:
	get_tree().quit()


## Return to main menu when pressed
func _on_exit_options_menu() -> void:
	margin_container.visible = true
	options_menu.visible = false


## Connect main menu signals
func handle_connecting_signals() -> void:
	start_button.button_down.connect(_on_start_pressed)
	options_button.button_down.connect(_on_options_pressed)
	exit_button.button_down.connect(_on_exit_pressed)
	options_menu.exit_options_menu.connect(_on_exit_options_menu)
