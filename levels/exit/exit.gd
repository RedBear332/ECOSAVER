extends Node2D
@export var next_scene: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "MainCharacter":
		return
	else:
		$AudioStreamPlayer2D.play()
		body.set_physics_process(false)
		body.get_node("AnimatedSprite2D").play("Disappering")
		await body.get_node("AnimatedSprite2D").animation_finished
		body.set_physics_process(true)
		get_tree().change_scene_to_file(next_scene)
