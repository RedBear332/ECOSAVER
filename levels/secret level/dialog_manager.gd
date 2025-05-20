extends CanvasLayer
@export var text_speed: float = 0.05
@export var test_dialog: PackedStringArray = [" "]

@onready var dialog_box: Panel = $DialogBox
@onready var rich_text: RichTextLabel = $DialogBox/MarginContainer/RichTextLabel
@onready var indicator: TextureRect = $DialogBox/NextIndicator
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var current_lines: PackedStringArray
var current_line: int = 0
var is_typing: bool = false
var text_progress: float = 0.0

signal dialog_started
signal dialog_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialog_box.hide()
	#if test_dialog.size() > 0:
		#start_dialog(test_dialog)
func start_dialog(lines: PackedStringArray) -> void:
	current_lines = lines
	current_line = 0
	dialog_box.show()
	anim_player.play("window_slide")
	await  anim_player.animation_finished
	_start_typing()
	emit_signal("dialog_started")
func _start_typing() -> void:
	rich_text.text  = current_lines[current_line]
	rich_text.visible_ratio = 0.0
	is_typing = true
	text_progress = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_typing: return
	text_progress += delta
	var ratio = text_progress / (text_speed * rich_text.get_total_character_count())
	rich_text.visible_ratio = clamp(ratio, 0.0, 1.0)
	if ratio >= 1.0:
		_finish_typing()

func _finish_typing() -> void :
	is_typing = false
	indicator.show()
	anim_player.play("indicator_blink")
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if  is_typing:
			rich_text.visible_ratio = 1.0
			_finish_typing()
		else:
			_next_line()

func _next_line() -> void :
	current_line += 1
	indicator.hide()
	anim_player.stop()
	if current_line >= current_lines.size():
		end_dialog()
		return
	_start_typing()

func end_dialog() -> void:
	anim_player.play_backwards("window_slide")
	await anim_player.animation_finished
	dialog_box.hide()
	emit_signal("dialog_finished")
	queue_free()
