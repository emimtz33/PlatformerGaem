extends CharacterBody2D


var SPEED = 400.0
var JUMP_VELOCITY = -650.0

var gravity = get_gravity()
var flight


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var gravity = get_gravity()
	var flight
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("glide") and velocity.y > 0:
		flight = gravity/2
		JUMP_VELOCITY = -150
		SPEED = 800
	else:
		flight = gravity
		JUMP_VELOCITY = -650
		SPEED = 400
	
		
	if not is_on_floor():
		velocity += flight * delta	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("moveLeft", "moveRight")
	
	if direction < 0:
		animated_sprite.flip_h = true
	if direction > 0:
		animated_sprite.flip_h = false
	
	if not is_on_floor() and velocity.y > 0:
		animated_sprite.play("princeAir")
	elif direction == 0:
		animated_sprite.play("princeIdle")
	else:
		animated_sprite.play("princeWalking")
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
