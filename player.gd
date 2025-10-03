extends CharacterBody3D
signal hit
signal dead
signal squish

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse  =20
@export var bounce_impulse = 16
@export var health = 3
@export var score = 0

var target_velocity = Vector3.ZERO


func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	 
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	elif Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	velocity = target_velocity
	move_and_slide()
	
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		
		# needed incase mobs already been deleted this frame
		if collision.get_collider() == null:
			continue
			 
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			
			# checking if hitting mob from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impulse
				score += 1
				squish.emit()
				break # to prvent duplicate calls


func _on_mob_detector_body_entered(body: Node3D) -> void:
	damaged()
	if health == 0:
		die()
	
func damaged():
	health -= 1
	hit.emit()
	
func die():
	dead.emit()
	queue_free()
	
