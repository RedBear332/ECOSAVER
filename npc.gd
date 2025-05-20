extends CharacterBody2D

@export var dialog_lines: PackedStringArray = ["Привет! Я NPC."]
@export var npc_name: String = "Учитель C++"


@onready var animation_player: AnimatedSprite2D = $Sprite2D
@onready var interaction_area: Area2D = $InteractionArea


var can_interact: bool = false
var is_talking: bool = false

func _ready() -> void:
	animation_player.play("idle")
	
func _physics_process(delta: float) -> void:
	if is_talking:
		face_player()


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_interact = true
		


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_interact = false

func _input(event: InputEvent) -> void:
	if can_interact and event.is_action_pressed("interact"):
		start_dialog()
		$AudioStreamPlayer.play()
		can_interact = false

func face_player() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		animation_player.flip_h = player.global_position.x < global_position.x
		
func start_dialog() -> void:
	if dialog_lines.is_empty():
		push_warning("У NPC нет диалоговых строк!")
		return
	is_talking = true
	var dialog = preload("res://levels/secret level/DialogManager.tscn").instantiate()
	dialog.dialog_finished.connect(end_dialog)
	get_parent().add_child(dialog)
	dialog.start_dialog(dialog_lines)

func end_dialog() -> void:
	is_talking = false
	can_interact = true
	$AudioStreamPlayer.stop()
