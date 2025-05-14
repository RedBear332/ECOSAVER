extends Area2D
var is_picked : bool = false
func _ready() -> void:
	pass # Replace with function body.
func _process(delta: float) -> void:
	pass
func on_pickup(body):
	if is_picked: return
	is_picked = true
	$Sound.play()
	await $Sound.finished
	GlobalVars.score += 1
	if (GlobalVars.score > GlobalVars.hi_score): GlobalVars.hi_score = GlobalVars.score
	
	queue_free()
