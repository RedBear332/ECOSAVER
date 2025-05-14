extends CanvasLayer
@onready var bgm_music: AudioStreamPlayer = $BGMMusic
var music_on : bool = true
@export var music : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Тут сделать музыку

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if not $ConfirmMenu.visible:
			show_menu()
		else: hide_menu()

func _on_pause_pressed() -> void:
	show_menu()

func _process(delta: float) -> void:
	$MarginContainer/HBoxContainer/Live.text = "Жизни: " + str(GlobalVars.live)
	$MarginContainer/HBoxContainer/Score.text = "Очки: " + str(GlobalVars.score)
	$MarginContainer/HBoxContainer/HiScore.text = "Лучший рекорд: " + str(GlobalVars.hi_score)

func music_switch():
	if music_on == true:
		bgm_music.stream_paused = true
		music_on = false
	else:
		bgm_music.stream_paused = false
		music_on = true

func _on_music_pressed() -> void:
	music_switch()

func show_menu():
	$ConfirmMenu.show()
	$MarginContainer/HBoxContainer/Pause.disabled = true
	music_switch()
	get_tree().paused = true
func hide_menu():
	$ConfirmMenu.hide()
	$MarginContainer/HBoxContainer/Pause.disabled = false
	music_switch()
	get_tree().paused = false
func _on_button_yes_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menues/main_menu.tscn")
func _on_button_no_pressed() -> void:
	hide_menu()
