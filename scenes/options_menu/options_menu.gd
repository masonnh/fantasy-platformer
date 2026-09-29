class_name OptionsMenu
extends Control

@onready var exit_button: Button = $MarginContainer/VBoxContainer/ExitButton as Button
@onready var settings_tab_container: SettingsTabContainer = $MarginContainer/VBoxContainer/SettingsTabContainer as SettingsTabContainer

signal exit_options_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit_button.button_down.connect(_on_exit_pressed)
	settings_tab_container.exit_options_menu.connect(_on_exit_pressed)
	set_process(false)


func _on_exit_pressed() -> void:
	exit_options_menu.emit()
	SettingsSignalBus.emit_set_settings_dictionary(SettingsDataContainer.create_storage_dictionary())
	set_process(false)
