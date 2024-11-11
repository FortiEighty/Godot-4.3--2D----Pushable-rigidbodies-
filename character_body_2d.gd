extends CharacterBody2D


# Speed for the movement and jump
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Pushing power of the player object that it applies to rigidbody
const PUSH_FORCE := 15.0
const MIN_PUSH_FORCE := 10.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Since it is possible to get multiple collisions during slide
	# We are calculating every possible collisions
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		# If this collision is RigidBody it means we can push it
		if c.get_collider() is RigidBody2D:
			# Applying push force. You can adjust values in the variable section
			var push_force = (PUSH_FORCE * velocity.length() / SPEED) + MIN_PUSH_FORCE
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
