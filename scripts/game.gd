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

func check_click(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		return 1

func _ready() -> void:
	#init_game()
	
	pass

var elevator_area = 0
var pc_area = 0
var elevator_in = 0
var pc_on = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if elevator_area:
			if !elevator_in:
				elevator_in = 1 
				disable_move()
				$map/hallway/boundaries/StaticBody2D/elevator.set_deferred("disabled", 0)
				$player.scale = Vector2(0.8, 0.8)
				$player.position = Vector2(0, -25)
			else:
				elevator_in = 0
				allow_move()
				$map/hallway/boundaries/StaticBody2D/elevator.set_deferred("disabled", 1)
				$player.scale = Vector2(1, 1)
				$player.position = Vector2(0, -11)
		
		if pc_area:
			if !pc_on:
				pc_on = 1
				$player/cam.enabled = 0
				$map/part3/pc/cam.enabled = 1
				$player.visible = 0
				disable_move()
			else:
				pc_on = 0
				$player/cam.enabled = 1
				$map/part3/pc/cam.enabled = 0
				$player.visible = 1
				allow_move()
			
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


func _on_pc_area_body_entered(body: Node2D) -> void:
	if body == $player:
		pc_area = 1
func _on_pc_area_body_exited(body: Node2D) -> void:
	if body == $player:
		pc_area = 0
func _on_mypc_pressed() -> void:
	print("my_pc")
func _on_note_pressed() -> void:
	$map/part3/pc/desktop/note_panel2.visible = !$map/part3/pc/desktop/note_panel2.visible 

func _on_tire_1_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		print("tire taken")
		$map/collectables/part4_tire.visible = 0
		$map/elevator_items/tire.visible = 1
