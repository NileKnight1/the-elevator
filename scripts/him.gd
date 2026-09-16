extends CharacterBody2D

var sound_iseeyou = preload("res://audio/dragon-studio-i-see-you-creepy-ghost-whisper-401711.mp3")


var def_speed = 300

var SPEED = 250.0
var sprint = 0
var move = 0
var walk = 0 
var targeting = 0

var awake = 1 
var left = -2885.0
var right = 2600.0
var cur = 2600.0
var targeting_time = 0

var player



func play_sound(sound, vol = 0.0):
	var temp = AudioStreamPlayer.new()
	temp.stream = sound
	temp.volume_db = vol
	add_child(temp)
	
	temp.finished.connect(temp.queue_free)
	temp.play()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	
	if !move: 
		$sprite.play("idle")
		velocity.x = 0
		move_and_slide()
		return

	var direction = 0.0
	if abs(player.position.x - position.x) < 350 && !player.hide: 
		cur = player.position.x
		targeting = 1
		targeting_time += 1
		SPEED = 350
		if targeting_time == 1:
			play_sound(sound_iseeyou)
		
		if global_position.x < cur:
			direction = 1.0
		elif global_position.x > cur:
			direction = -1.0
			
	else:
		targeting = 0
		targeting_time = 0
		SPEED = 250
		if global_position.x < cur:
			direction = 1.0
		elif global_position.x > cur:
			direction = -1.0
			
		if abs(global_position.x - cur) < 5.0:
			if cur == right:
				cur = left
			else:
				cur = right

	if velocity.y != 0 || velocity.x == 0:
		walk = 0
	else:
		walk = 1
	
	if sprint:
		$sprite.play("sprint")
	elif walk:
		$sprite.play("walk")
	else:
		$sprite.play("idle")
	
	if direction != 0:
		velocity.x = direction * SPEED
		if direction < 0:
			$sprite.flip_h = 1
		else:
			$sprite.flip_h = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
