extends CharacterBody2D

@onready var hero: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound: AudioStreamPlayer = $Appear
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var can_move: bool = false

func _ready() -> void:
	sound.play()
	hero.play("Appearing")
	await hero.animation_finished
	can_move = true

func _physics_process(delta: float) -> void:
	if can_move == false: return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	update_animation()
	move_and_slide()
	if position.y > 360: on_death()

func update_animation():
	if velocity.x:
		hero.play("Run")
	else: hero.play("Idle")
	if velocity.y < 0:
		hero.play("Jump")
	elif velocity.y > 0:
		hero.play("Fall")
	if velocity.x < 0:
		hero.flip_h = 1
	else: hero.flip_h = 0 

func on_death():
	GlobalVars.live -= 1
	var music_players = get_tree().get_nodes_in_group("background_music")
	if music_players: music_players[0].stop()
	if GlobalVars.live > 0:
		$OnHit.play()
		can_move = false
		hero.play("Death")
		await  $OnHit.finished
		can_move = true
		queue_free()
		#Тут добавить повтор уровня
	else:
		$OnDeath.play()
		can_move = false
		hero.play("Death")
		await  $OnDeath.finished
		can_move = true
		queue_free()
		get_tree().change_scene_to_file("res://menues/main_menu.tscn")


func _on_pickup_area_entered(area: Area2D) -> void:
	if area.has_method("on_pickup"):
		area.on_pickup(self)
