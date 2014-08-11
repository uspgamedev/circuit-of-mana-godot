
extends RigidBody

func _ready():
	pass

var velocity = 10

func _integrate_forces(st):
	if Input.is_action_pressed("forward"):
		st.add_force(Vector3(0, 0, -velocity), Vector3(0, 0, 0))
	if Input.is_action_pressed("backward"):
		st.add_force(Vector3(0, 0, velocity), Vector3(0, 0, 0))
	if Input.is_action_pressed("left"):
		st.add_force(Vector3(-velocity, 0, 0), Vector3(0, 0, 0))
	if Input.is_action_pressed("right"):
		st.add_force(Vector3(velocity, 0, 0), Vector3(0, 0, 0))
