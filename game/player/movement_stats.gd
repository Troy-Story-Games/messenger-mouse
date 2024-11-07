extends Resource
class_name MovementStats

@export_group("Ground Movement")
## Horizontal acceleration for a character
@export var ground_acceleration: = 300.0
## Max horizontal speed
@export var ground_max_speed: = 200.0
## Friction applied to stop the charater when not moving
@export var ground_friction: = 1500.0
## Force applied when jumping off the ground
@export var ground_jump_force: = 350.0
## Friction applied to stop the character when sliding
@export var ground_slide_friction: = 90.0
## Amount added to current speed when pressing the slide button
@export var ground_slide_boost: = 70.0
## Boost applied to ground_jump_force when crouch launching
@export var ground_slide_launch_boost: = 100.0
## Max speed while crouch walking
@export var ground_crouch_walk_max_speed: = 12.0

@export_group("Air Movement")
## Fall acceleration (e.g. gravity)
@export var gravity: = 1000.0
## Max fall speed
@export var terminal_velocity: = 300.0
## Horizontal acceleration in the air
@export var air_acceleration: = 300.0
## Max horizontal speed in the air
@export var air_max_speed: = 200.0
## Friction applied to stop horizontal movement in the air
@export var air_friction: = 300.0
## Force applied when jumping while in the air (double, triple, quadruple, etc. jump)
@export var air_jump_force: = 350.0

@export_group("Wall Movement")
## Fall acceleration when wall sliding
@export var wall_slide_acceleration: = 100.0
## Max fall speed when attached to a wall
@export var wall_slide_max_speed: = 50.0
## Upward force when wall jumping
@export var wall_jump_force: = 350.0
## Horizontal speed when wall jumping
@export var wall_jump_speed: = 50.0
