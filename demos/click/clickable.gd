
extends StaticBody

var cam = null
var ray = null
var anim = null


func _ready():
	cam = get_node("../Camera")
	ray = get_node("../Camera/Ray")
	anim = get_node("AnimationPlayer")

	set_process_input(true)
	set_process(true)

func _process(dt):
	if ray.is_enabled() and ray.is_colliding() and not anim.is_playing():
		anim.play("ArmatureAction", -1, 1, false )
		ray.set_enabled(false)

func _input(event):
	if event.type==InputEvent.MOUSE_BUTTON and event.is_pressed():
		
		var pos = event.global_pos
		var dir = cam.project_ray_normal(pos) # Uses camera projection matrix to project mouse 2D coordinates to 3D vector in world space
		
		# Since the direction has to be in local space, we transform it by cameras inverse transformation matrix
		var transform = cam.get_camera_transform().basis.inverse()
		var local_dir = transform * dir
		
		ray.set_cast_to(local_dir * 100)
		ray.set_enabled(true)

