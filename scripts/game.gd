extends Node2D

func init_game():
	init_lights()
func init_lights():
	$map/black.visible = 1
	$player/flash.visible = 1

func _ready() -> void:
	#init_game()
	
	
	pass

func _process(delta: float) -> void:
	pass
