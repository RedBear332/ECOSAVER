extends Area2D
var is_picked : bool = false
func _ready() -> void:
	pass # Replace with function body.
func _process(delta: float) -> void:
	pass
func on_pickup(body):
	if is_picked: return
	is_picked = true
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property($".","position:y",position.y-20, 0.4)
	tween.tween_property($AnimatedSprite2D, "self_modulate:a", 0.0, 0.4)
	$Sound.play()
	await $Sound.finished
	GlobalVars.score += 1
	if (GlobalVars.score > GlobalVars.hi_score): GlobalVars.hi_score = GlobalVars.score
	
	queue_free()
