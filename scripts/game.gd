extends Node2D

var try = global.try

func init_game():
	init_lights()
	init_collect()

func init_collect():
	
	$garage/garage/mob.visible = 0
	$map/collectables/part1_tire.visible = 1
	$map/collectables/part3_tire.visible = 1
	$map/collectables/part4_tire.visible = 1
	$map/collectables/part1_battery.visible = 1
	$map/collectables2/part3_keys.visible = 0
	$map/collectables2/part2_keys.visible = 0
	
	
	$garage/elevator_items/tire1.visible = 0
	$garage/elevator_items/tire2.visible = 0
	$garage/elevator_items/tire3.visible = 0
	$garage/elevator_items/tire4.visible = 0
	$garage/elevator_items/keys.visible = 0
	$garage/elevator_items/battery.visible = 0
	
	$map/elevator_items/tire1.visible = 0
	$map/elevator_items/tire2.visible = 0
	$map/elevator_items/tire3.visible = 0
	$map/elevator_items/tire4.visible = 0
	$map/elevator_items/keys.visible = 0
	$map/elevator_items/battery.visible = 0
	

func init_lights():
	#$map/black.visible = 1
	
	
	$player/flash.visible = 1
	$map/part3/black.visible = 1
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

func subtitles(msg, time = 1):
	$CanvasLayer/subtitles.text = msg
	

func _ready() -> void:
	subtitles("", 0)
	$him.player = $player
	var tween = create_tween()
	tween.tween_property($".", "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	$him.position = Vector2(-1190.0, -414.0)
	$him.rotation = 0
	$him.move = 0
	#$player.position = Vector2(0, -11)
	$map/part2/him_spawn_col/CollisionShape2D.set_deferred("disabled", 0)
	init_game()
	#$him.position = Vector2(-771, -22)
	#$him.rotation = 90
	#$him.move = 0
	
	#
	#await get_tree().create_timer(2.0).timeout
	#$player.hide = 1
	#await get_tree().create_timer(2.0).timeout
	#$player.hide = 0

var elevator_area = 0
var pc_area = 0
var elevator_in = 0
var pc_on = 0

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("interact"):
		if dead: return
		
		if elevator_area && abs($him.position.x-$player.position.x) > 350:
			if !elevator_in:
				elevator_in = 1 
				$player.hide = 1
				disable_move()
				$map/hallway/boundaries/StaticBody2D/elevator.set_deferred("disabled", 0)
				$player.scale = Vector2(0.8, 0.8)
				$player.position = Vector2(0, -25)
				$CanvasLayer/elevator.visible = 1
			else:
				elevator_in = 0
				$player.hide = 0
				allow_move()
				$map/hallway/boundaries/StaticBody2D/elevator.set_deferred("disabled", 1)
				$player.scale = Vector2(1, 1)
				$player.position = Vector2(0, -11)
				$CanvasLayer/elevator.visible = 0
		
		if garage_elevator_area:
			if !elevator_in:
				elevator_in = 1 
				$player.hide = 1
				disable_move()
				$garage/garage/boundaries/StaticBody2D/elevator.set_deferred("disabled", 0)
				$player.scale = Vector2(0.8, 0.8)
				$player.position = Vector2(1672.0, 1552.0)
				$CanvasLayer/elevator.visible = 1
			else:
				elevator_in = 0
				$player.hide = 0
				allow_move()
				$garage/garage/boundaries/StaticBody2D/elevator.set_deferred("disabled", 1)
				$player.scale = Vector2(1, 1)
				$player.position = Vector2(1672.0, 1606.0)
				$CanvasLayer/elevator.visible = 0
		if pc_area:
			return
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
		
		if back_tires_area:
			if equipped_tires && back_tires_exist < 2:
				print("back tire put", back_tires_exist)
				equipped_tires -= 1
				$garage/garage/car/back_tires.get_child(back_tires_exist).visible = 1
				back_tires_exist += 1
				for i in $map/elevator_items.get_children():
					if i.visible:
						i.visible = 0
						break
				for i in $garage/elevator_items.get_children():
					if i.visible:
						i.visible = 0
						break
				
				
			elif !equipped_tires:
				print("no tires")
				subtitles("You have no tires", 1)
			elif back_tires_exist == 2:
				print("fullD")
				subtitles("back tires are full", 1)
		if front_tires_area:
			if equipped_tires && front_tires_exist < 2:
				print("front tire put", front_tires_exist)
				
				equipped_tires -= 1
				$garage/garage/car/front_tires.get_child(front_tires_exist).visible = 1
				front_tires_exist += 1
				for i in $map/elevator_items.get_children():
					if i.visible:
						i.visible = 0
						break
				for i in $garage/elevator_items.get_children():
					if i.visible:
						i.visible = 0
						break
				
				
			elif !equipped_tires:
				print("no tires")
				subtitles("You have no tires", 1)
				
			elif back_tires_exist == 2:
				print("fullD")
				subtitles("front tires are full", )
				
		
		if car_ride_area:
			#print("trying to ride")
			if back_tires_exist + front_tires_exist != 4 && !car_battery_exist:
				subtitles(str(4-(back_tires_exist + front_tires_exist))+" tires and battery are missing.")
			else:
				if back_tires_exist + front_tires_exist != 4:
					#print(back_tires_exist," back tires is missing")
					subtitles(str(4-(back_tires_exist + front_tires_exist))+" tires missing.")
				#if front_tires_exist != 2:
					#print(front_tires_exist," front tires is missing")
				if !car_battery_exist:
					print("car_battery_missing")
					subtitles("Battery is missing")
					
			if back_tires_exist == 2 && front_tires_exist == 2 && car_battery_exist:
				if !can_escape:
					all_collected_except_keys = 1
					print("keys missing")
					subtitles("I forgot the keys.", )
				elif can_escape && !car_keys_taken:
					print('The keys are with him')
					subtitles("The keys are with him", )
					
					can_kill = 1
					$map/collectables2/part1_crawbar.visible = 1
				elif can_escape && car_keys_taken:
					print("WIN")
					subtitles("I'm safe now", )
					
					
		
		if car_battery_area:
			if car_battery_taken:
				print('battery put')
				car_battery_taken = 0
				car_battery_exist = 1
				$map/elevator_items/battery.visible = 0
				$garage/elevator_items/battery.visible = 0
			elif car_battery_exist:
				print('alr put')
				subtitles("Battery is alright.", )
				
			else:
				print("no batt")
				subtitles("You don't have battery", )
				
			
		if wardrobe_area:
			if wardrobe_hide:
				subtitles("He can't see me now.", )
				if crowbar_equipped && wardrobe_area_him:
					print("killed him")
					subtitles("I think he's dead.", )
					$him.awake = 0
					$him.move = 0
					$map/collectables2/part3_keys.visible = 1
					$him.position = Vector2(-771, 21)
					$him.rotation = 90
				$player.hide = 0
				wardrobe_hide = 0
				$map/part3/wardrobe/wardrone_hide_collisoin/CollisionShape2D.set_deferred("disabled", 1)
				allow_move()
				$map/part3/wardrobe/hide.visible = 0
				$player.position = Vector2(1004, 33)
				
				
			elif abs($him.position.x-$player.position.x) > 350:
				wardrobe_hide = 1
				$player.hide = 1
				
				disable_move()
				$map/part3/wardrobe/hide.visible = 1
				$map/part3/wardrobe/wardrone_hide_collisoin/CollisionShape2D.set_deferred("disabled", 0)
				$player.position = Vector2(982.0, 4.0)
				
		if sofa_area:
			if sofa_hide:
				#print(crowbar_equipped, " crowbar_equipped")
				#print(sofa_area_him, " sofa_area_him")
				
				if crowbar_equipped && sofa_area_him:
					print("him_killed")
					subtitles("I think he's dead.", )
					
					$him.awake = 0
					$him.move = 0
					$map/collectables2/part2_keys.visible = 1
					$him.position = Vector2(-771, 21)
					$him.rotation = 90
				$player.hide = 0
				sofa_hide = 0
				$map/part2/sofa.z_index = 0
				allow_move()
				
				
			elif abs($him.position.x-$player.position.x) > 350:
				$player.hide = 1
				$player.position.x = -878.0
				$map/part2/sofa.z_index = 1
				sofa_hide = 1
				disable_move()
				



var can_kill = 0
var sofa_hide = 0
var wardrobe_area =0
var wardrobe_hide = 0

var car_battery_taken = 0
var car_keys_taken = 0
var car_battery_exist = 0
var back_tires_exist = 0
var front_tires_exist = 1
var all_collected_except_keys = 0

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


	
var apartment_area = 1

func _on_garage_pressed() -> void:
	if apartment_area:
		#print("goon")
		#print($amp/hallway/elevator/close1.size.x)
		global.try += 1
		var tween = create_tween()
		tween.set_parallel(1)
		tween.tween_property($map/hallway/elevator/close1, "size:x", 100, 1.0)
		tween.tween_property($map/hallway/elevator/close2, "size:x", 100, 1.0)
		#await get_tree().create_timer(1.0).timeout #edit
		
		#var tween2 d= create_tween()
		#tween2.tween_property($".", "modulate", Color(0.0, 0.0, 0.0, 1.0), 1.0)
		#
		#await get_tree().create_timer(1.0).timeout
		#
		elevator_in = 0
		$player.hide = 0
		
		$map/hallway/elevator/close1.size.x = 0
		$map/hallway/elevator/close2.size.x = 0
		$garage/garage/elevator/close1.size.x = 0
		$garage/garage/elevator/close2.size.x = 0
		if all_collected_except_keys:
			all_collected_except_keys = 0
			
			
		allow_move()
		$map/hallway/boundaries/StaticBody2D/elevator.set_deferred("disabled", 1)
		$garage/garage/boundaries/StaticBody2D/elevator.set_deferred("disabled", 1)
		$player.scale = Vector2(1, 1)
		$player.position = Vector2(1672.0, 1606.0)
		$CanvasLayer/elevator.visible = 0
		
		#var tween3 = create_tween()
		#tween3.tween_property($".", "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	#
		
		apartment_area = 0
		
func _on_apartment_pressed() -> void:
	if !apartment_area:
		#print("goon")
		print($garage/garage/elevator/close1.size.x)
		global.try += 1
		var tween = create_tween()
		tween.set_parallel(1)
		tween.tween_property($garage/garage/elevator/close1, "size:x", 100, 1.0)
		tween.tween_property($garage/garage/elevator/close2, "size:x", 100, 1.0)
		#await get_tree().create_timer(1.0).timeout #edit
		
		#var tween2 = create_tween()
		#tween2.tween_property($".", "modulate", Color(0.0, 0.0, 0.0, 1.0), 1.0)
		#
		#await get_tree().create_timer(1.0).timeout
		#
		elevator_in = 0
		$player.hide = 0
		$map/hallway/elevator/close1.size.x = 0
		$map/hallway/elevator/close2.size.x = 0
		$garage/garage/elevator/close1.size.x = 0
		$garage/garage/elevator/close2.size.x = 0
		allow_move()
		if all_collected_except_keys:
			#$map/collectables2/part3_keys.visible = 1
			back_tires_exist = 0
			front_tires_exist = 1
			car_battery_exist = 0
			#all_collected_except_keys = 0
			$map/part2/sofa/blood.visible = 1
			#$garage/garage/car/front_tires/tire1.visible = 0
			$garage/garage/car/front_tires/tire2.visible = 0
			$garage/garage/car/back_tires/tire1.visible = 0
			$garage/garage/car/back_tires/tire2.visible = 0
			
			
		$garage/garage/boundaries/StaticBody2D/elevator.set_deferred("disabled", 1)
		$map/hallway/boundaries/StaticBody2D/elevator.set_deferred("disabled", 1)
		$player.scale = Vector2(1, 1)
		$player.position = Vector2(0, -11)
		$CanvasLayer/elevator.visible = 0
		#var tween3 = create_tween()
		#tween3.tween_property($".", "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
		#
		apartment_area = 1
		


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
		equipped_tires += 1
		$map/collectables/part4_tire.visible = 0
		$map/elevator_items/tire1.visible = 1
		$garage/elevator_items/tire1.visible = 1
		
func _on_part1_tire_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		print("tire taken")
		equipped_tires += 1
		$map/collectables/part1_tire.visible = 0
		$map/elevator_items/tire2.visible = 1
		$garage/elevator_items/tire2.visible = 1
		
func _on_part3_tire_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		print("tire taken")
		equipped_tires += 1
		$map/collectables/part3_tire.visible = 0
		$map/elevator_items/tire3.visible = 1
		$garage/elevator_items/tire3.visible = 1
		
#
#func match_try():
	#match try:
		#1:
			#$map/collectables/part4_tire.visible = 1
		#2:
			#$map/collectables/part1_tire.visible = 1
		#3:
			#$map/collectables/part1_battery.visible = 1
		#4:
			#$map/collectables2/part3_keys.visible = 1
		#5:
			#$map/collectables/part3_tire.visible = 1
		#

var note_area = 0

func _on_note_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event) && note_area:
		$CanvasLayer/note.visible = !$CanvasLayer/note.visible 

func _on_note_big_body_entered(body: Node2D) -> void:
	if body == $player:
		note_area = 1
func _on_note_big_body_exited(body: Node2D) -> void:
	if body == $player:
		$CanvasLayer/note.visible = 0
		note_area = 0

func _on_part_1_battery_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		print("battery taken")
		car_battery_taken = 1
		$map/collectables/part1_battery.visible = 0
		$map/elevator_items/battery.visible = 1
		$garage/elevator_items/battery.visible = 1
		

func _on_key_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		print("keys taken")
		$map/collectables2/part3_keys.visible = 0
		$map/collectables2/part2_keys.visible = 0	
		$map/elevator_items/keys.visible = 1
		$garage/elevator_items/keys.visible = 1
		car_keys_taken = 1

var equipped_tires = 0
var garage_elevator_area = 0


func _on_garage_elevator_area_body_entered(body: Node2D) -> void:
	if body == $player:
		garage_elevator_area = 1
func _on_garage_elevator_area_body_exited(body: Node2D) -> void:
	if body == $player:
		garage_elevator_area = 0

var back_tires_area = 0
var front_tires_area = 0

func _on_back_tires_area_body_entered(body: Node2D) -> void:
	if body == $player: 
		back_tires_area = 1
func _on_back_tires_area_body_exited(body: Node2D) -> void:
	if body == $player: 
		back_tires_area = 0

func _on_front_tires_area_body_entered(body: Node2D) -> void:
	if body == $player: 
		front_tires_area = 1
func _on_front_tires_area_body_exited(body: Node2D) -> void:
	if body == $player: 
		front_tires_area = 0

var car_ride_area = 0
func _on_car_ride_body_entered(body: Node2D) -> void:
	if body == $player: 
		car_ride_area = 1
func _on_car_ride_body_exited(body: Node2D) -> void:
	if body == $player: 
		car_ride_area = 0
var can_escape = 0
var sofa_blood_discovered = 0
var sofa_blood_area = 0
func _on_sofa_blood_area_body_entered(body: Node2D) -> void:
	if body == $player: 
		if $map/part2/sofa/blood.visible:
			sofa_blood_area = 1
			print("blood to be cleaned")
			subtitles("I should clean this blood.", )
			if !sofa_blood_discovered:
				sofa_blood_discovered = 1
				print("Ther's a mob in the garage")
				$garage/garage/mob.visible = 1
		elif him_spawn_ready && !spawned:
			spawned = 1
			#disable_move()
			print("spawwned")
			subtitles("!!!", )
			can_escape = 1
			if !can_kill && !first_spawn:
				$map/collectables/part1_battery.visible = 1
				#$map/collectables2/part3_keys.visible = 1
				$map/collectables/part4_tire.visible = 1
				$map/collectables/part3_tire.visible = 1
				$map/collectables/part1_tire.visible = 1
			elif can_kill:
				$map/collectables2/part1_crawbar.visible = 1
			$map/part2/him_spawn_col/CollisionShape2D.set_deferred("disabled", 1)
			first_spawn = 1
			await get_tree().create_timer(1.0).timeout
			$him.move = 1
			
var first_spawn = 0
var him_spawn_ready = 0
var mob_taken = 0
func _on_sofa_blood_area_body_exited(body: Node2D) -> void:
	if body == $player: 
		sofa_blood_area = 0
func _on_mob_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		print('mob taken')
		$garage/garage/mob.visible = 0
		mob_taken = 1
		$map/part2/sofa/blood.visible = 0
		him_spawn_ready = 1
		
var car_battery_area = 0

func _on_car_battery_area_body_entered(body: Node2D) -> void:
	if body == $player:
		car_battery_area = 1
func _on_car_battery_area_body_exited(body: Node2D) -> void:
	if body == $player:
		car_battery_area = 0


func _on_wardrobe_area_body_entered(body: Node2D) -> void:
	if body == $player:
		wardrobe_area = 1
	if body == $him:
		wardrobe_area_him = 1
func _on_wardrobe_area_body_exited(body: Node2D) -> void:
	if body == $player:
		wardrobe_area = 0
	if body == $him:
		wardrobe_area_him = 0

var sofa_area = 0
var wardrobe_area_him = 0
var sofa_area_him = 0

func _on_sofa_area_body_entered(body: Node2D) -> void:
	if body == $player:
		sofa_area = 1
	#print(body)
	if body == $him:
		sofa_area_him = 1
func _on_sofa_area_body_exited(body: Node2D) -> void:
	if body == $player:
		sofa_area = 0
	if body == $him:
		sofa_area_him = 0
var spawned = 0
var dead = 0
func _on_him_kill_body_entered(body: Node2D) -> void:
	if body == $player && !$player.hide && $him.awake:
		dead = 1
		spawned = 0
		print("dead")
		$him.move = 0
		$him.position = Vector2(-1157.0, -417.0)
		$map/part2/him_spawn_col/CollisionShape2D.set_deferred("disabled", 1)
		
		modulate = Color(0.0, 0.0, 0.0, 1.0)
		disable_move()
		$player.position = Vector2(0, 28)
		
		await get_tree().create_timer(1.0).timeout
		var tween = create_tween()
		tween.tween_property($".", "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
		allow_move()
		$him.move = 1
		$map/part2/him_spawn_col/CollisionShape2D.set_deferred("disabled", 0)
			
		if !can_kill:
			$map/elevator_items/tire1.visible = 0
			$map/elevator_items/tire2.visible = 0
			$map/elevator_items/tire3.visible = 0
			$map/elevator_items/battery.visible = 0
			$map/elevator_items/keys.visible = 0
			
			$garage/elevator_items/tire1.visible = 0
			$garage/elevator_items/tire2.visible = 0
			$garage/elevator_items/tire3.visible = 0
			$garage/elevator_items/battery.visible = 0
			$garage/elevator_items/keys.visible = 0
			
			if !car_battery_exist:
				$map/collectables/part1_battery.visible = 1
			#print(equipped_tires, " equipped_tires")
			if equipped_tires:
				$map/collectables/part4_tire.visible = 1
				equipped_tires -= 1
			if equipped_tires:
				$map/collectables/part3_tire.visible = 1
				equipped_tires -= 1
			if equipped_tires:
				$map/collectables/part1_tire.visible = 1
				equipped_tires -= 1
				
			equipped_tires = 0
			car_battery_taken = 0
		if can_kill: 
			$map/collectables2/part1_crawbar.visible = 1
			$player/crowbad.visible = 0
			crowbar_equipped = 0
	dead = 0

var crowbar_equipped = 0

func _on_crowbar_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		$map/collectables2/part1_crawbar.visible = 0
		$player/crowbad.visible = 1
		crowbar_equipped = 1
