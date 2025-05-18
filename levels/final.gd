extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "ПОБЕДА! ТЫ НАБРАЛ ОЧКОВ: " + str(GlobalVars.score)
	await $AudioStreamPlayer.finished
	get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
