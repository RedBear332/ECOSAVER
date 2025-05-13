extends Area2D
func _ready() -> void:
	pass # Replace with function body.
func _process(delta: float) -> void:
	pass
func on_pickup(body):
	$Sound.play()
	await $Sound.finished
	queue_free()
