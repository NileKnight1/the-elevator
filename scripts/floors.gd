extends Node2D

var floor = global.floor
var touch = global.touch

var sound_click = preload("res://audio/buttonpress.mp3")
var sound_subtitle = preload("res://audio/subtitle.wav")
var sound_collect = preload("res://audio/collect.mp3")
var sound_spawn = preload("res://audio/dragon-studio-monster-growl-390285.mp3")
var sound_bite = preload("res://audio/bite.mp3")
var sound_blood = preload("res://audio/blood.mp3")
var sound_elevator = preload("res://audio/elevator.mp3")
var sound_error = preload("res://audio/error.wav")
var sound_tire_put = preload("res://audio/dragon-studio-impact-thud-372473.mp3")
var sound_spark = preload("res://audio/freesound_community-jump-and-spark-6136.mp3")
var sound_keys = preload("res://audio/ellvdr-llaves-3keys-3-338165_qoALM9z0.mp3")
var sound_wardrobe = preload("res://audio/freesound_community-lock-a-door-43194.mp3")
var sound_sofa = preload("res://audio/tanweraman-wave-cape-cloth-in-wind-350430_3Ji9NeqF.mp3")
var sound_car_engine = preload("res://audio/dragon-studio-car-engine-roaring-376881.mp3")
var sound_wall_break = preload("res://audio/freesound_community-rock-destroy-6409.mp3")
var sound_car_move = preload("res://audio/spinopel-car-driving-away-345709.mp3")
var sound_iseeyou = preload("res://audio/dragon-studio-i-see-you-creepy-ghost-whisper-401711.mp3")


# mob taken

var sound_hit = preload("res://audio/hit.mp3")


func play_sound(sound, vol = 0.0):
	var temp = AudioStreamPlayer.new()
	temp.stream = sound
	temp.volume_db = vol
	add_child(temp)
	
	temp.finished.connect(temp.queue_free)
	temp.play()

	
func init_game():
	init_lights()

func init_lights():
	
	$garage/black.visible = 1
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

func subtitles(msg, time = 3):
	play_sound(sound_subtitle)
	$CanvasLayer/subtitles.text = tr(msg)
	
	await get_tree().create_timer(time).timeout
	if $CanvasLayer/subtitles.text == msg:
		$CanvasLayer/subtitles.text = ""

func guide(msg):
	print(tr(msg))
	$CanvasLayer/press_e.text = tr("press") + tr(str(msg))
	if msg == "": $CanvasLayer/press_e.text = ""
	
	
func guide2(msg):
	$CanvasLayer/press_e.text = tr("click") + tr(str(msg))
	if msg == "": $CanvasLayer/press_e.text = ""
	
func guide3(msg):
	$CanvasLayer/press_e.text = tr(str(msg))


func _ready() -> void:
	$player.position = Vector2(0, -52)
	
	$map/hallway/elevator/floor.text = str(floor)
	match_floor()
	anomaly_apply()
	print("floor ",floor)
	
	$CanvasLayer/mobile.visible = touch
	translation()
	
	no_interact = 0
	

		
	
	
	modulate = Color(0.0, 0.0, 0.0, 1.0)
	$sfx/bg.volume_db = -25
	var tween2 = create_tween()
	tween2.tween_property($sfx/bg, "volume_db", 0, 3.0)
	var tween = create_tween()
	tween.tween_property($".", "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	$map/part2/him_spawn_col/CollisionShape2D.set_deferred("disabled", 0)
	init_game()
	if global.mistakes == 3:
		game_lose()
	
	
	

var no_interact = 1
var elevator_area = 0
var pc_area = 0
var elevator_in = 0
var pc_on = 0

@onready var walking_sound = $sfx/walking_sound

func _process(delta: float) -> void:
	#print(car_battery_area)
	
	if $player.walk && $player.move:
		if !walking_sound.playing:
			walking_sound.play()
		if $player.sprint:
			walking_sound.pitch_scale = 2.0
		else:
			walking_sound.pitch_scale = 1
	else:
		walking_sound.stop()
	
	
	if Input.is_action_just_pressed("interact"):
		#print("interacted")
		if no_interact: return
		
		if elevator_area:
			if !elevator_in:
				elevator_in = 1 
				$player.hide = 1
				disable_move()
				$map/hallway/boundaries/StaticBody2D/elevator.set_deferred("disabled", 0)
				$player.scale = Vector2(0.8, 0.8)
				$player.position = Vector2(0, -66)
				
				$CanvasLayer/elevator/up.visible = 1
				$CanvasLayer/elevator/down.visible = 1
				
			else:
				elevator_in = 0
				$player.hide = 0
				allow_move()
				$map/hallway/boundaries/StaticBody2D/elevator.set_deferred("disabled", 1)
				$player.scale = Vector2(1, 1)
				$player.position = Vector2(0, -52)
				$CanvasLayer/elevator/up.visible = 0
				$CanvasLayer/elevator/down.visible = 0
				
		
		if car_ride_area:
			no_interact = 1
			print("WIN")
			$CanvasLayer.visible = 0
			guide2("")
			disable_move()
			$player.visible = 0
			play_sound(sound_car_engine)
			$garage/garage/car/flash.visible = 1
			$garage/garage/car/front_light.visible = 1
			$garage/garage/car/back_light.visible = 1
			
			await get_tree().create_timer(1.0).timeout
			var tween = create_tween()
			tween.tween_property($".", "modulate", Color(0.0, 0.0, 0.0, 1.0), 1.0)
			await get_tree().create_timer(2.0).timeout
			play_sound(sound_car_move)
			await get_tree().create_timer(1.0).timeout
			play_sound(sound_wall_break)
			await get_tree().create_timer(2.0).timeout
			play_sound(sound_car_move)
			var tween2 = create_tween()
			tween2.tween_property($sfx/bg, "volume_db", -25, 3)
			await get_tree().create_timer(3.0).timeout
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		
		if wardrobe_area:
			if wardrobe_hide:
				
				play_sound(sound_wardrobe)
				$player.hide = 0
				wardrobe_hide = 0
				$map/part3/wardrobe/wardrone_hide_collisoin/CollisionShape2D.set_deferred("disabled", 1)
				allow_move()
				$map/part3/wardrobe/hide.visible = 0
				$player.position = Vector2(1004, -49)
				
				
			else:
				guide("")
				play_sound(sound_wardrobe)
				wardrobe_hide = 1
				$player.hide = 1
				disable_move()
				$map/part3/wardrobe/hide.visible = 1
				$map/part3/wardrobe/wardrone_hide_collisoin/CollisionShape2D.set_deferred("disabled", 0)
				$player.position = Vector2(1000, -37)
				
		if sofa_area:
			if sofa_hide:
				play_sound(sound_sofa)
				
				$player.hide = 0
				sofa_hide = 0
				$map/part2/sofa.z_index = 0
				allow_move()
				
				
			else:
				guide("")
				play_sound(sound_sofa)
				$player.hide = 1
				$player.position.x = -878.0
				$map/part2/sofa.z_index = 1
				sofa_hide = 1
				disable_move()
				

func elevator_taken(dir):
	if anomaly == dir:
		global.floor += 1
	else:
		global.mistakes +=1
	
	no_interact = 1
	$CanvasLayer/elevator/up.visible = 0
	$CanvasLayer/elevator/down.visible = 0
	guide("")
	play_sound(sound_elevator)
	
	var tween = create_tween()
	tween.set_parallel(1)
	tween.tween_property($map/hallway/elevator/close1, "size:x", 100, 1.0)
	tween.tween_property($map/hallway/elevator/close2, "size:x", 100, 1.0)
	await get_tree().create_timer(1.0).timeout
	
	var tween2 = create_tween()
	tween2.tween_property($".", "modulate", Color(0.0, 0.0, 0.0, 1.0), 1.0)
	
	await get_tree().create_timer(1.0).timeout
	
	if global.floor != 10:
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	else:
		elevator_in = 0
		$map/hallway/elevator/close1.size.x = 0
		$map/hallway/elevator/close2.size.x = 0
		$garage/garage/elevator/close1.size.x = 0
		$garage/garage/elevator/close2.size.x = 0
		
		allow_move()
		$map/hallway/boundaries/StaticBody2D/elevator.set_deferred("disabled", 1)
		$garage/garage/boundaries/StaticBody2D/elevator.set_deferred("disabled", 1)
		$player.scale = Vector2(1, 1)
		$player.position = Vector2(1672.0, 4176)
		$CanvasLayer/elevator/garage.visible = 0
		
		var tween3 = create_tween()
		tween3.tween_property($".", "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	
		no_interact = 0

func _on_up_pressed() -> void:
	elevator_taken(1)
func _on_down_pressed() -> void:
	elevator_taken(0)


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
		if !no_interact:
			guide("to ride the elevator")
func _on_elevator_area_body_exited(body: Node2D) -> void:
	if body == $player:
		elevator_area = 0
		guide("")

func _on_pc_area_body_entered(body: Node2D) -> void:
	if body == $player:
		pc_area = 1
		guide("to open the computer")
func _on_pc_area_body_exited(body: Node2D) -> void:
	if body == $player:
		pc_area = 0
		guide("")
func _on_mypc_pressed() -> void:
	print("my_pc")
func _on_note_pressed() -> void:
	$map/part3/pc/desktop/note_panel2.visible = !$map/part3/pc/desktop/note_panel2.visible 

func _on_tire_1_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		print("tire taken")
		play_sound(sound_collect)
		equipped_tires += 1
		$map/collectables/part4_tire.visible = 0
		$map/elevator_items/tire1.visible = 1
		$garage/elevator_items/tire1.visible = 1
		
func _on_part1_tire_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		print("tire taken")
		play_sound(sound_collect)
		equipped_tires += 1
		$map/collectables/part1_tire.visible = 0
		$map/elevator_items/tire2.visible = 1
		$garage/elevator_items/tire2.visible = 1
		
func _on_part3_tire_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		print("tire taken")
		play_sound(sound_collect)
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
		guide2("to open the note")
func _on_note_big_body_exited(body: Node2D) -> void:
	if body == $player:
		$CanvasLayer/note.visible = 0
		note_area = 0
		guide2("")
		


var equipped_tires = 0
var garage_elevator_area = 0



var back_tires_area = 0
var front_tires_area = 0



var car_ride_area = 0
func _on_car_ride_body_entered(body: Node2D) -> void:
	if body == $player: 
		car_ride_area = 1
		guide("to ride the car")
		
func _on_car_ride_body_exited(body: Node2D) -> void:
	if body == $player: 
		car_ride_area = 0
		guide("")

var can_escape = 0
var sofa_blood_discovered = 0
var sofa_blood_area = 0


var mob_taken = 0
func _on_sofa_blood_area_body_exited(body: Node2D) -> void:
	if body == $player: 
		sofa_blood_area = 0


func _on_wardrobe_area_body_entered(body: Node2D) -> void:
	if body == $player:
		wardrobe_area = 1
		guide("to hide")
	
func _on_wardrobe_area_body_exited(body: Node2D) -> void:
	if body == $player:
		wardrobe_area = 0
		guide("")
	

var sofa_area = 0
var wardrobe_area_him = 0
var sofa_area_him = 0

func _on_sofa_area_body_entered(body: Node2D) -> void:
	if body == $player:
		sofa_area = 1
		guide("to hide")
		
	#print(body)

func _on_sofa_area_body_exited(body: Node2D) -> void:
	if body == $player:
		sofa_area = 0
		guide("")
	
var spawned = 0
var dead = 0

var crowbar_equipped = 0

func _on_crowbar_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		$map/collectables2/part1_crawbar.visible = 0
		$player/crowbad.visible = 1
		crowbar_equipped = 1

func _on_continue_pressed() -> void:
	$CanvasLayer/pause.visible = !$CanvasLayer/pause.visible
func _on_settings_pressed() -> void:
	$CanvasLayer/pause/settings.visible = !$CanvasLayer/pause/settings.visible
func _on_main_menu_pressed() -> void:
	#$CanvasLayer/pause.visible = 0
	disable_move()
	$CanvasLayer.visible = 0
	await get_tree().create_timer(1.0).timeout
	var tween = create_tween()
	tween.tween_property($".", "modulate", Color(0.0, 0.0, 0.0, 1.0), 1.0)
	await get_tree().create_timer(2.0).timeout
	var tween2 = create_tween()
	tween2.tween_property($sfx/bg, "volume_db", -25, 3)
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
func _on_pause_button_pressed() -> void:
	$CanvasLayer/pause.visible = !$CanvasLayer/pause.visible

func _on_en_pressed() -> void:
	lang("en")
func _on_ar_pressed() -> void:
	lang("ar")
func _on_eg_pressed() -> void:
	lang("eg")

func lang(ln):
	play_sound(sound_click)
	print(ln)
	TranslationServer.set_locale(ln)
	translation()

func translation():
	$CanvasLayer/pause/settings/language.text = tr("language")
	$CanvasLayer/pause/settings/mobile.text = tr("touch")
	$CanvasLayer/elevator/apartment.text = tr("apartment")
	$CanvasLayer/elevator/garage.text = tr("garage")
	$CanvasLayer/pause/buttons/buttons/continue.text = tr("continue")
	$CanvasLayer/pause/buttons/buttons/settings.text = tr("settings")
	$CanvasLayer/pause/buttons/buttons/main_menu.text = tr("main_menu")

func _on_touch_check_toggled(toggled_on: bool) -> void:
	global.touch = toggled_on
	touch = toggled_on
	$CanvasLayer/mobile.visible = toggled_on

var anomalies_dif1 = [
	{"id"= 0, "show"= null ,"hide"= ^"map/part2/tv/tv", "dif" = 1},
	{"id"= 1, "show"= null ,"hide"= ^"map/part2/sofa", "dif" = 1},
	{"id"= 2, "show"= null ,"hide"= ^"map/part1/shelf4", "dif" = 1},
	{"id"= 3, "show"= null ,"hide"= ^"map/part1/shelf3", "dif" = 1},
	{"id"= 4, "show"= null ,"hide"= ^"map/part4/fridge", "dif" = 1},
	{"id"= 5, "show"= null ,"hide"= ^"map/part4/sink", "dif" = 1},
	{"id"= 6, "show"= null ,"hide"= ^"map/part4/sink", "dif" = 1},
	{"id"= 7, "show"= null ,"hide"= ^"map/part3/pc", "dif" = 1},
	{"id"= 8, "show"= null ,"hide"= ^"map/part3/wardrobe", "dif" = 1},
	{"id"= 9, "show"= ^"map/part1/shelf5" ,"hide"= null, "dif" = 1},
	
]

var anomalies_dif2 = [
	{"id"= 10, "show"= null ,"hide"= ^"map/part3/chair", "dif" = 2},
	{"id"= 11, "show"= null ,"hide"= ^"map/part4/box9", "dif" = 2},
	{"id"= 12, "show"= null ,"hide"= ^"map/part1/pipe2", "dif" = 2},
	{"id"= 13, "show"= null ,"hide"= ^"map/part2/plant2", "dif" = 2},
	
	{"id"= 14, "show"= ^"map/part1/pipe3" ,"hide"= null , "dif" = 2},
	{"id"= 15, "show"= ^"map/part3/box8" ,"hide"= null , "dif" = 2},
	{"id"= 16, "show"= ^"map/part4/box10" ,"hide"= null , "dif" = 2},
	{"id"= 17, "show"= ^"map/part2/sofa/pillow3" ,"hide"= null , "dif" = 2},
	
]

var anomalies_dif3 = [
	{"id"= 18, "show"= null ,"hide"= ^"map/part1/bin", "dif" = 3},
	{"id"= 19, "show"= null ,"hide"= ^"map/part2/sofa/pillow2", "dif" = 3},
	{"id"= 20, "show"= null ,"hide"= ^"map/part3/clock/analogs", "dif" = 3},
	{"id"= 21, "show"= null ,"hide"= ^"map/part4/sink/han", "dif" = 3},
	{"id"= 22, "show"= ^"map/part1/bin2" ,"hide"= ^"map/part1/bin", "dif" = 3},
	
]


var dif1_prob = 10
var dif2_prob = 20
var anomaly = 0

func anomaly_apply():
	#get_node_or_null(anomalies[0]["hide"]).visible = 0
	var temp = randi_range(0,2)
	if temp == 0:
		print("anomaly skipped")
		anomaly = 0
		return
	else:
		anomaly = 1
		temp = randi_range(1, 30)
		
		
		if temp <= dif1_prob:
			var temp2 = randi_range(0, anomalies_dif1.size()-1)
			temp = anomalies_dif1[temp2]
		elif temp <= dif1_prob+dif2_prob:
			var temp2 = randi_range(0, anomalies_dif2.size()-1)
			temp = anomalies_dif2[temp2]
		else:
			var temp2 = randi_range(0, anomalies_dif3.size()-1)
			temp = anomalies_dif3[temp2]
		
		if temp["show"] != null:
			get_node_or_null(temp["show"]).visible = 1
		if temp["hide"] != null:
			get_node_or_null(temp["hide"]).visible = 0
		print("anomaly happen")
		print(temp)

func match_floor():
	match floor:
		1: 
			dif1_prob = 20
			dif2_prob = 7
		2: 
			dif1_prob = 20
			dif2_prob = 5
		3: 
			dif1_prob = 18
			dif2_prob = 5
		4: 
			dif1_prob = 15
			dif2_prob = 10
		5: 
			dif1_prob = 7
			dif2_prob = 15
		6: 
			dif1_prob = 5
			dif2_prob = 15
		7: 
			dif1_prob = 5
			dif2_prob = 10
		8: 
			dif1_prob = 5
			dif2_prob = 5
		9: 
			dif1_prob = 0
			dif2_prob = 0
		

func game_lose():
	no_interact = 1
	$map/doorway_right.visible = 0
	$map/doorway_left.visible = 0
	$map/doorway_mistake_right.visible = 1
	$map/doorway_mistake_left.visible = 1
	$map/doorway_mistake_right/StaticBody2D/CollisionShape2D.set_deferred("disabled", 0)
	$map/doorway_mistake_left/StaticBody2D/CollisionShape2D.set_deferred("disabled", 0)
	$map/part2/box4.visible = 0
	$map/hallway/elevator/close1.z_index = 0
	$map/hallway/elevator/close2.z_index = 0
	
	var tween = create_tween()
	tween.set_parallel(1)
	tween.tween_property($map/hallway/elevator/close1, "size:x", 100, 1.0)
	tween.tween_property($map/hallway/elevator/close2, "size:x", 100, 1.0)

	await get_tree().create_timer(3.0).timeout
	play_sound(sound_iseeyou)
	await get_tree().create_timer(5.0).timeout
	$him.apartment_area = 1
	$him.player = $player
	$him.visible = 1
	$him.move = 1
	$him.awake = 1


func _on_kill_entered(body: Node2D) -> void:
	if body == $player && $him.move:
		print("kill")
		global.floor = 0
		global.mistakes = 0
		$CanvasLayer/red.visible = 1
		disable_move()
		$player.rotation = 90
		$him.move = 0
		$CanvasLayer/pause_button.visible = 0
		$CanvasLayer/restart.visible = 1
		


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")







#
