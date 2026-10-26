extends CharacterBody2D

# Crates base variables for jumping and running
var SPEED = 400.0
var JUMP_VELOCITY = -650.0
var isDead = false
var rCount = 0


#Links the sprite animation to the code
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D  
func _physics_process(delta: float) -> void:
	
	if isDead:
		return
	
		
	# Crates variables that dictate how fallign works
	var gravity = get_gravity()
	var flightMode
	
	# Changes the speed and gravity depending on if the player wants to glide
	if Input.is_action_pressed("glide") and velocity.y > 0:
		flightMode = gravity/3
		JUMP_VELOCITY = -150
		SPEED = 800
	else:
		flightMode = gravity
		JUMP_VELOCITY = -650
		SPEED = 400
	
	# make the player jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# makes the player fall based on if its gliding or not
	if not is_on_floor():
		velocity += flightMode * delta	
	
	# Decides which direction the player rmoves
	var direction := Input.get_axis("moveLeft", "moveRight")

	#flips sprite depending on diraction moving
	if direction > 0:
		animated_sprite.flip_h = false
	if direction < 0:
		animated_sprite.flip_h = true
		
	#plays animation based on what the playe ris doing
	if not is_on_floor() and velocity.y > 0 and Input.is_action_pressed("glide"):
		animated_sprite.play("princeAir")
	elif direction == 0:
		animated_sprite.play("princeIdle")
	else:
		animated_sprite.play("princeWalking")
	
	#moves the player
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("Restart"):
		rCount = rCount + 1
		
	if rCount >= 3:
		death()
	
	if global_position.y > 500 :
		death()
		
	if globalFiles.isPlayerDead:
		death()
	
	#mantsains fluid motion by preventing harsh stops
	move_and_slide()
 
func death() -> void:
	isDead = true
	velocity = Vector2.ZERO
	animated_sprite.play("princeDeath")
	await get_tree().create_timer(1.2).timeout
	rCount = 0
	isDead = false
	global_position = globalFiles.lastCheckpointPos
	
	
