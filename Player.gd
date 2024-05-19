extends RigidBody3D

# Variables
var jump_force = 20.0  # Adjust as needed for the jump height
var is_on_ground = false  # Track whether the character is on the ground

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_vector := Vector3.ZERO
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.z = Input.get_axis("move_forward", "move_back")
	
	if input_vector != Vector3.ZERO:
		print("Input Vector:", input_vector)
		apply_central_force(input_vector * 1200.0 * delta)
	
	if Input.is_action_just_pressed("move_jump") and is_on_ground:
		apply_central_impulse(Vector3(0, jump_force, 0))

func _integrate_forces(state):
	# Check if the body is on the ground
	is_on_ground = is_on_floor(state)

func is_on_floor(state):
	# Cast a ray down to check for ground contact
	var from = global_transform.origin
	var to = from + Vector3(0, -1, 0)
	var space_state = get_world_3d().direct_space_state
	var params = PhysicsRayQueryParameters3D.new()
	params.from = from
	params.to = to
	params.exclude = [self]
	var result = space_state.intersect_ray(params) 
	return result.size() > 0
