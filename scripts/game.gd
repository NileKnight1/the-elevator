extends Node2D

func init_game():
	init_lights()
func init_lights():
	#$map/black.visible = 1
	#$player/flash.visible = 1
	
	$map/hallway/dark.visible = 1
	$map/part1/dark.visible = 1
	$map/part2/dark.visible = 1
	$map/part3/dark.visible = 1
	$map/part4/dark.visible = 1
	

func disable_move():
	$player.move = 0
func allow_move():
	$player.move = 1

func _ready() -> void:
	#init_game()
	
	pass

var elevator_area = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if elevator_area:
			if $player.scale == Vector2(1, 1):
				disable_move()
				$map/hallway/boundaries/StaticBody2D/elevator.set_deferred("disabled", 0)
				$player.scale = Vector2(0.8, 0.8)
				$player.position = Vector2(0, -25)
			else:
				allow_move()
				$map/hallway/boundaries/StaticBody2D/elevator.set_deferred("disabled", 1)
				$player.scale = Vector2(1, 1)
				$player.position = Vector2(0, -11)
				

func _on_area_part1_body_entered(body: Node2D) -> void:
	if body == $player:
		var tween = create_tween()
		tween.tween_property($map/part1/dark, "modulate:a", 0.0, 0.5)
func _on_area_part1_body_exited(body: Node2D) -> void:
	if body == $player:
		var tween = create_tween()
		tween.tween_property($map/part1/dark, "modulate:a", 1.0, 0.5)
func _on_area_part2_body_entered(body: Node2D) -> void:
	if body == $player:
		var tween = create_tween()
		tween.tween_property($map/part2/dark, "modulate:a", 0.0, 0.5)
func _on_area_part2_body_exited(body: Node2D) -> void:
	if body == $player:
		var tween = create_tween()
		tween.tween_property($map/part2/dark, "modulate:a", 1.0, 0.5)
func _on_area_hallway_body_entered(body: Node2D) -> void:
	if body == $player:
		var tween = create_tween()
		tween.tween_property($map/hallway/dark, "modulate:a", 0.0, 0.5)
func _on_area_hallway_body_exited(body: Node2D) -> void:
	if body == $player:
		var tween = create_tween()
		tween.tween_property($map/hallway/dark, "modulate:a", 1.0, 0.5)
func _on_area_part3_body_entered(body: Node2D) -> void:
	if body == $player:
		var tween = create_tween()
		tween.tween_property($map/part3/dark, "modulate:a", 0.0, 0.5)
func _on_area_part3_body_exited(body: Node2D) -> void:
	if body == $player:
		var tween = create_tween()
		tween.tween_property($map/part3/dark, "modulate:a", 1.0, 0.5)
func _on_area_part4_body_entered(body: Node2D) -> void:
	if body == $player:
		var tween = create_tween()
		tween.tween_property($map/part4/dark, "modulate:a", 0.0, 0.5)
func _on_area_part4_body_exited(body: Node2D) -> void:
	if body == $player:
		var tween = create_tween()
		tween.tween_property($map/part4/dark, "modulate:a", 1.0, 0.5)
		

func _on_elevator_area_body_entered(body: Node2D) -> void:
	if body == $player:
		elevator_area = 1
func _on_elevator_area_body_exited(body: Node2D) -> void:
	if body == $player:
		elevator_area = 0

func _on_elevator_go_pressed() -> void:
	print("goon")
	print($map/hallway/elevator/close1.size.x)
	var tween = create_tween()
	tween.set_parallel(1)
	tween.tween_property($map/hallway/elevator/close1, "size:x", 100, 1.0)
	tween.tween_property($map/hallway/elevator/close2, "size:x", 100, 1.0)
