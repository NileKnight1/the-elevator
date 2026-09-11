extends CanvasLayer

func _on_left_button_down() -> void:
	Input.action_press("left")
func _on_left_button_up() -> void:
	Input.action_release("left")



func _on_right_button_down() -> void: Input.action_press("right")
func _on_right_button_up() -> void: Input.action_release("right")

func _on_down_button_down() -> void: Input.action_press("down")
func _on_down_button_up() -> void: Input.action_release("down")


func _on_up_button_down() -> void: Input.action_press("up")
func _on_up_button_up() -> void: Input.action_release("up")


func _on_sprint_button_down() -> void: Input.action_press("sprint")


func _on_sprint_button_up() -> void: Input.action_release("sprint")


func _on_jump_pressed() -> void: 
	Input.action_press("jump")
	Input.action_release("jump")


func _on_interact_pressed() -> void:
	Input.action_press("interact")
	Input.action_release("interact")
