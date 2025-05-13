extends CharacterBody2D

@onready var hero: AnimatedSprite2D = $AnimatedSprite2D
@onready var  sound: AudioStreamPlayer = $AudioStreamPlayer
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
	GlobalVars.live = GlobalVars.live - 1
	#Тут сделать анимацию со звуком
	can_move = false
	hero.play("Death")
	await hero.animation_finished
	can_move=true
	queue_free()
	if GlobalVars.live == 0: get_tree().change_scene_to_file("res://menues/main_menu.tscn")
	else : pass #Сделать повтор уровня


func _on_pickup_area_entered(area: Area2D) -> void:
	if area.has_method("on_pickup"):
		area.on_pickup(self)
