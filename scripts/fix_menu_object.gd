extends Node

var def_scale

func _ready() -> void:
	print(self)
	def_scale = self.scale

func _process(delta: float) -> void:
	pass
	
func hover_on():
	if self.modulate == Color(1.0, 1.0, 1.0, 0.0): return
	var tween = create_tween()
	tween.set_parallel(1)
	tween.tween_property(self, "modulate", Color(1.9, 1.9, 1.9), 0.15)
	tween.tween_property(self, "scale", def_scale * Vector2(1.01,1.01) , 0.15)
func hover_off():
	if self.modulate == Color(1.0, 1.0, 1.0, 0.0): return
	var tween = create_tween()
	tween.set_parallel(1)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.15)
	tween.tween_property(self, "scale", def_scale , 0.15)
