extends Node

var def_scale
var def_position

func _ready() -> void:
	#print(self)
	def_scale = self.scale
	def_position = self.position
	

func _process(delta: float) -> void:
	pass
	
func hover_on():
	if self.modulate == Color(1.0, 1.0, 1.0, 0.0): return
	global.fix_menu_shown = 1
	var tween = create_tween()
	tween.set_parallel(1)
	tween.tween_property(self, "modulate", Color(1.9, 1.9, 1.9), 0.15)
	tween.tween_property(self, "scale", def_scale * Vector2(1.01,1.01) , 0.15)
func hover_off():
	if self.modulate == Color(1.0, 1.0, 1.0, 0.0): return
	if self == global.fix_selected_node && global.fix_menu_shown: return
	var tween = create_tween()
	tween.set_parallel(1)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.15)
	tween.tween_property(self, "scale", def_scale , 0.15)
func force_hover_off():
	if self.modulate == Color(1.0, 1.0, 1.0, 0.0): return
	var tween = create_tween()
	tween.set_parallel(1)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.15)
	tween.tween_property(self, "scale", def_scale , 0.15)
func show():
	var tween = create_tween()
	tween.set_parallel(1)
	tween.tween_property(self, "modulate", Color(1.9, 1.9, 1.9), 0.15)
	tween.tween_property(self, "scale", def_scale * Vector2(1.01,1.01) , 0.15)
func change_position():
	#print(self)
	#print(self.get_path())
	
	for i in global.anomalies_data:
		#print("/root/game/"+str(i["node"]))
		#print(get_node_or_null(i["node"]))
		if str(self.get_path()) == "/root/game/"+str(i["node"]):
			if self.position == def_position:
				var tween = create_tween()
				tween.tween_property(self, "position", i["second_position"], 0.15)
				#self.position = i["second_position"]
			else:
				var tween = create_tween()
				tween.tween_property(self, "position", def_position, 0.15)
				#self.position = def_position
			
