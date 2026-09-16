extends Node2D

var sound_click = preload("res://audio/buttonpress.mp3")

func play_sound(sound, vol = 0.0):
	var temp = AudioStreamPlayer.new()
	temp.stream = sound
	temp.volume_db = vol
	add_child(temp)
	
	temp.finished.connect(temp.queue_free)
	temp.play()

func _ready() -> void:
	$buttons/buttons/play.text = tr("play")
	for i in $lights.get_children():
		i.visible = 1
		i.energy = 0
	$lights.visible = 1
	$black.visible = 1
	rand_light(0)

func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	play_sound(sound_click)
	var tween = create_tween()
	tween.tween_property($".", "modulate", Color(0.0, 0.0, 0.0, 1.0), 1.0)
	var tween2 = create_tween()
	tween2.tween_property($bg_sound, "volume_db", -15, 3.0)
	await get_tree().create_timer(3).timeout
	
	get_tree().change_scene_to_file("res://scenes/game.tscn")

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
