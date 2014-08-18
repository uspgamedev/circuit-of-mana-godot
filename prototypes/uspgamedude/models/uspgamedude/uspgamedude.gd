
extends RigidBody

func _ready():
	# Initalization here
	pass

var base_scalar_v = 10
var base_angular_v = .7

func _integrate_forces(st):
	var forw = Input.is_action_pressed("forward")
	var back = Input.is_action_pressed("backward")
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var jump = Input.is_action_pressed("jump")
	
	if forw or back:
		var force = (get_node("Direction").get_global_transform().origin - get_translation()) * base_scalar_v
		force.y += 2
		if forw:
			st.add_force(force, Vector3(0, 1.7, 0))
		if back:
			st.add_force(-force, Vector3(0, 1.7, 0))
	
	if left and not right:
		st.set_angular_velocity(Vector3(0, base_angular_v, 0))
	if right and not left:
		st.set_angular_velocity(Vector3(0, -base_angular_v, 0))
	if not (right or left) or (right and left):
		st.set_angular_velocity(Vector3(0, 0, 0))
	
	if jump:
		pass
