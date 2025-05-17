extends CharacterBody2D


var SPEED = 60.0
var direction: int = -1
var is_dead: bool = false


func _physics_process(delta: float) -> void:
	if is_dead: return
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	velocity.x = direction * SPEED
	move_and_slide()
	if is_on_wall():
		direction *= -1 
		$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
	if position.y > 640: die()
func die():
	if is_dead: return
	is_dead = true
	set_collision_layer_value(2, false)
	SPEED = 0
	$AnimatedSprite2D.play("hit")
	
	await get_tree().create_timer(0.5).timeout
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_dead:
		die()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_dead:
		body.on_death()
