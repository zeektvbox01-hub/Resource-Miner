extends Node2D

func _ready() -> void:
	$Title.show()
	$"Main Menu Background".show()
	$"Start Button".show()

func _on_start_button_pressed() -> void:
	$Title.hide()
	$"Main Menu Background".hide()
	$"Start Button".hide()
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
