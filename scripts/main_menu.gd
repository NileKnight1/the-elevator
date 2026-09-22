extends Node2D

var sound_click = preload("res://audio/buttonpress.mp3")

func play_sound(sound, vol = 0.0):
	var temp = AudioStreamPlayer.new()
	temp.stream = sound
	temp.volume_db = vol
	add_child(temp)
	
	temp.finished.connect(temp.queue_free)
	temp.play()

func translation():
	$buttons/buttons/play.text = tr("play")
	$buttons/buttons/settings.text = tr("settings")
	$settings/language.text = tr("language")
	$settings/mobile.text = tr("touch")

func _ready() -> void:
	translation()
	for i in $lights.get_children():
		i.visible = 1
		i.energy = 0
	$lights.visible = 1
	$black.visible = 1
	rand_light(0)

func _process(delta: float) -> void:
	pass

var game_scene = "res://scenes/story.tscn"

func start():
	play_sound(sound_click)
	var tween = create_tween()
	tween.tween_property($".", "modulate", Color(0.0, 0.0, 0.0, 1.0), 1.0)
	await get_tree().create_timer(1).timeout
	$tutorial_story.visible = 1
	$black.visible = 0
	$lights.visible = 0
	#$tutorial_story.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	var tween3 = create_tween()
	tween3.set_parallel(true)
	tween3.tween_property($tutorial_story, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	tween3.tween_property($".", "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	print("tut on")
	
	var tween2 = create_tween()
	tween2.tween_property($bg_sound, "volume_db", -15, 3.0)

func _on_story_pressed() -> void:
	game_scene = "res://scenes/story.tscn"
	start()
func _on_floors_pressed() -> void:
	game_scene = "res://scenes/floors.tscn"
	start()

func run_game():
	play_sound(sound_click)
	var tween = create_tween()
	tween.tween_property($".", "modulate", Color(0.0, 0.0, 0.0, 1.0), 1.0)
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(game_scene)


func rand_light(n):
	var temp = randi_range(0,4)
	if temp == n:
		rand_light(temp)
		return
	var tween = create_tween()
	tween.tween_property($lights.get_child(temp), "energy", 1.0, 1.0)
	await get_tree().create_timer(2.0).timeout
	var tween2 = create_tween()
	tween2.tween_property($lights.get_child(temp), "energy", 0, 1.0)
	
	rand_light(temp)


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

func _on_settings_pressed() -> void:
	$settings.visible = !$settings.visible

func _on_touch_check_toggled(toggled_on: bool) -> void:
	global.touch = toggled_on

var active_boxes = [
	0, 1, 2
]
func _on_left_tutorial_story_pressed() -> void:
	if active_boxes[0] == 0: return
	active_boxes[0] -= 1
	active_boxes[1] -= 1
	active_boxes[2] -= 1
	switch_boxes()

func _on_right_tutorial_story_pressed() -> void:
	if active_boxes[2] == 4: return
	active_boxes[0] += 1
	active_boxes[1] += 1
	active_boxes[2] += 1
	switch_boxes()

func switch_boxes():
	for i in $tutorial_story/boxes.get_children():
		i.visible = 0
	
	for i in active_boxes:
		$tutorial_story/boxes.get_child(i).visible = 1
	if active_boxes[0] == 0:
		$tutorial_story/left.disabled = 1
	else: $tutorial_story/left.disabled = 0
	if active_boxes[2] == 4:
		$tutorial_story/right.disabled = 1
	else: $tutorial_story/right.disabled = 0
