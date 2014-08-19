extends RigidBody

func _ready():
    # Initalization here
    pass

var walk_speed = 5
var turn_speed = 0.8
var jump_speed = 2

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

    var on_floor = true
    if state.get_contact_count() == 0:
        on_floor = false

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
            velocity += direction * walk_speed
            animate("walk")
        if backward:
            velocity -= direction * walk_speed
            animate("walk")

        if jump:
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
