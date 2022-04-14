extends Node2D

func _ready():
	$Timer.stop()

func _on_Timer_timeout():
	visible = false
	$Timer.stop()
	get_parent().emit_signal("continueTime")

func startTimer():
	$Timer.start()
