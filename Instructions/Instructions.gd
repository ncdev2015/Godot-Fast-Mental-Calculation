extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		_on_Button_pressed()

func _on_Button_pressed():
	get_tree().change_scene("res://Game/Game.tscn")
