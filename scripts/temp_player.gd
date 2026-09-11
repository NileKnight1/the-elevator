extends CharacterBody2D

var sound_jump = preload("res://audio/dragon-studio-simple-whoosh-382724.mp3")

var def_speed = 300
var def_sprint = 400.0
var def_jump = -350.0
var def_sprint_jump = -400

var SPEED = 300.0
var JUMP_VELOCITY = -250.0
var sprint = 0
var move = 1
var walk = 0 

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
		velocity.x = 0
		move_and_slide()
		return
	
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
		
	if Input.is_action_pressed("sprint"):
		SPEED = def_sprint
		JUMP_VELOCITY = def_sprint_jump
		sprint = 1
	else:
		sprint = 0
		SPEED = def_speed
		JUMP_VELOCITY = def_jump
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		play_sound(sound_jump)
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if direction < 0:
			$sprite.flip_h = 1
		else:
			$sprite.flip_h = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
