extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_g_exit_pressed() -> void:
	get_tree().quit()


func _on_g_start_pressed() -> void:
	GlobalVars.score = 0
	GlobalVars.live = 3
	if not GlobalVars.hi_score:
		GlobalVars.hi_score = 0
	get_tree().change_scene_to_file("res://levels/level_1.tscn")
