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
	$buttons/buttons/story.text = tr("story")
	$buttons/buttons/floors.text = tr("floors")
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
	$tutorial_story.modulate = Color(0.0, 0.0, 0.0, 1.0)
	$tutorial_floors.modulate = Color(0.0, 0.0, 0.0, 1.0)
	$tutorial_story.visible = 0
	$tutorial_floors.visible = 0
	
	rand_light(0)

func _process(delta: float) -> void:
	pass

var game_scene = "res://scenes/story.tscn"
var tutorial: Node2D

func start():
	play_sound(sound_click)
	var tween = create_tween()
	tween.tween_property($".", "modulate", Color(0.0, 0.0, 0.0, 1.0), 0.5)
	await get_tree().create_timer(0.5).timeout
	tutorial.visible = 1
	$black.visible = 0
	$lights.visible = 0
	
	switch_boxes()
	var tween3 = create_tween()
	tween3.set_parallel(true)
	tween3.tween_property(tutorial, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5)
	tween3.tween_property($".", "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5)
	print("tut on")
	
	var tween2 = create_tween()
	tween2.tween_property($bg_sound, "volume_db", -15, 3.0)

func _on_story_pressed() -> void:
	game_scene = "res://scenes/story.tscn"
	tutorial = $tutorial_story
	start()
func _on_floors_pressed() -> void:
	game_scene = "res://scenes/floors.tscn"
	tutorial = $tutorial_floors
	start()

func run_game():
	play_sound(sound_click)
	var tween = create_tween()
	tween.tween_property($".", "modulate", Color(0.0, 0.0, 0.0, 1.0), 0.5)
	await get_tree().create_timer(0.5).timeout
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
	play_sound(sound_click)
	active_boxes[0] -= 1
	active_boxes[1] -= 1
	active_boxes[2] -= 1
	switch_boxes()

func _on_right_tutorial_story_pressed() -> void:
	if active_boxes[2] == 4: return
	play_sound(sound_click)
	active_boxes[0] += 1
	active_boxes[1] += 1
	active_boxes[2] += 1
	switch_boxes()

func switch_boxes():
	for i in tutorial.get_node("boxes").get_children():
		i.visible = 0
	
	for i in active_boxes:
		tutorial.get_node("boxes").get_child(i).visible = 1
	if active_boxes[0] == 0:
		tutorial.get_node("left").disabled = 1
	else: tutorial.get_node("left").disabled = 0
	if active_boxes[2] == 4:
		tutorial.get_node("right").disabled = 1
	else: tutorial.get_node("right").disabled = 0


func _on_checkpoints_toggled(toggled_on: bool) -> void:
	$tutorial_story/checkpoints.button_pressed = toggled_on
	$tutorial_story/button.button_pressed = toggled_on
	global.story_checkpoints = toggled_on
