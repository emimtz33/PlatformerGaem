extends CharacterBody2D

@onready var stateChart = $StateChart
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const baseSpeed = 400.0
const baseJumpVelocity = -650.0
var speed = baseSpeed
var gravity = get_gravity()


func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	
	var direction := Input.get_axis("moveLeft", "moveRight")
	if not is_on_floor():
		velocity += gravity * delta
		
	if direction < 0:
		animated_sprite.flip_h = true
	if direction > 0:
		animated_sprite.flip_h = false
		
	if global_position.y > 500:
		stateChart.send_event("death")
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = baseJumpVelocity
		stateChart.send_event("jump")
		
	if Input.is_action_pressed("glide") and velocity.y > 0:
		speed = 550
		gravity = gravity * 0.9
		stateChart.send_event("glide")
		animated_sprite.play("princeAir")
		
	else:
		speed = baseSpeed
		gravity = get_gravity()
	
	if is_on_floor():
		if velocity.x == 0:
			stateChart.send_event("idle")
			animated_sprite.play("princeIdle")
		else:
			stateChart.send_event("walk")
			animated_sprite.play("princeWalking")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, baseSpeed)
	
	move_and_slide()
	
func _on_idle_state_entered():
	animated_sprite.play("princeIdle")

func _on_walk_state_entered():
	animated_sprite.play("princeWalking")

func _on_jump_state_entered():
	animated_sprite.play("princeAir")

func _on_glide_state_entered():
	animated_sprite.play("princeAir")
