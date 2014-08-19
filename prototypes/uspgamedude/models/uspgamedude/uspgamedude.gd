extends RigidBody

var camera_style = 0
var CAMERA_COUNT = 3
var cameras

func _ready():
    cameras = [get_node("shoulder_camera"), get_node("head_camera"), get_node("rear_camera")]
    set_process_input(true)

func _input(ie):
    if ie.is_pressed() and not ie.is_echo() and ie.is_action("change_camera"):
        camera_style = (camera_style + 1) % CAMERA_COUNT
        if cameras[camera_style] != null:
            cameras[camera_style].make_current()

var walk_speed = 5
var cur_speed
var run_speed = 25
var turn_speed = 1.2
var jump_speed = 2
var jumping = 0
var jump_max = 0.35
var is_jump = false

func animate(name):
    var player = get_node("animation_player")

    if name == "":
        if player.is_playing():
            player.stop()
    elif player.get_current_animation() != name or not player.is_playing():
        player.play(name)

func _integrate_forces(state):
    var gravity = state.get_total_gravity()
    var delta = state.get_step()

    var forward = Input.is_action_pressed("forward")
    var backward    = Input.is_action_pressed("backward")
    var left    = Input.is_action_pressed("left")
    var right   = Input.is_action_pressed("right")
    var jump    = Input.is_action_pressed("jump")
    var run    = Input.is_action_pressed("run")
    

    if jumping > 0:
        jumping -= state.get_step()
    else: 
        jumping = 0  

    if run:
        cur_speed = run_speed
    else:
        cur_speed = walk_speed

    var on_floor = true
    is_jump = false
    if state.get_contact_count() == 0:
        on_floor = false
        is_jump = true

    if forward or backward or jump:
        set_friction(0)

        # Get node "body" as a fixed reference attached to the character.
        # The componentes are: [0]: x -> left right
        #                      [1]: y -> up down
        #                      [2]: z -> forward backward
        var direction = get_node("body").get_global_transform()[2]

        var velocity = Vector3()
        var previous_velocity = state.get_linear_velocity()

        if forward:
            velocity += direction * cur_speed
            if is_jump == false :
                animate("walk")
        if backward:
            velocity -= direction * cur_speed
            if is_jump == false:
                animate("walk")

        if jump:
            if on_floor:
                jumping = jump_max
        if jumping > 0:
            animate("shield")
            velocity -= gravity * delta * jump_speed

        # Prevent character from stop falling or jumping.
        velocity.y += state.get_linear_velocity()[1]

        # Finally set the new linear velocity to the character.
        state.set_linear_velocity(velocity)
    else:
        set_friction(1)
        if on_floor:
            state.set_linear_velocity(Vector3(0, 0, 0))
        animate("default")

    # If left or right are pressed, turn. Else stop turning.
    if left:
        state.set_angular_velocity(Vector3(0, turn_speed, 0))
    elif right:
        state.set_angular_velocity(Vector3(0, -turn_speed, 0))
    else: 
        state.set_angular_velocity(Vector3(0, 0, 0))
