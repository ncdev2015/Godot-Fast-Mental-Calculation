extends Node2D

func _ready():
	$BestMark.text = "Best Mark:\n" + str(Globals.bestMark)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		_on_StartButton_pressed()

func _on_StartButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Instructions/Instructions.tscn")
