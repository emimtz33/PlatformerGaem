extends CharacterBody2D

var SPEED = 400.0
var JUMP_VELOCITY = -650.0
var isDead: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if isDead:
		return

	var gravity = get_gravity()
	var flight = gravity
	var direction := Input.get_axis("moveLeft", "moveRight")
		
	if Input.is_action_pressed("glide") and velocity.y > 0:
		flight = gravity/4
		JUMP_VELOCITY = -150
		SPEED = 650
	else:
		flight = gravity
		JUMP_VELOCITY = -650
		SPEED = 400
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if not is_on_floor():
		velocity += flight * delta	

	if direction > 0 and not isDead:
		animated_sprite.flip_h = false
	if direction < 0 and not isDead:
		animated_sprite.flip_h = true
		
	if not is_on_floor() and velocity.y > 0 and not Input.is_action_pressed("glide"):
		animated_sprite.play("princeIdle")
		
	if not is_on_floor() and velocity.y > 0 and Input.is_action_pressed("glide"):
		animated_sprite.play("princeAir")
		
	if is_on_floor() and velocity.x > 0:
		animated_sprite.play("princeWalking")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if position.y > 500 and not isDead:
		dead()

	
	move_and_slide()
		
	
	
	


		
	
func dead()-> void:
	if not isDead:
		isDead = true
		animated_sprite.play("princeDeath")
		await get_tree().create_timer(1.0).timeout
		get_tree().reload_current_scene()
		return
