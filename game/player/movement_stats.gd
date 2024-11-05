extends Resource
class_name MovementStats

@export_group("Ground Movement")
## Horizontal acceleration for a character
@export var ground_acceleration: = 150.0
## Max horizontal speed
@export var ground_max_speed: = 32.0
## Friction applied to stop the charater when not moving
@export var ground_friction: = 150.0
## Force applied when jumping off the ground
@export var ground_jump_force: = 85.0

@export_group("Air Movement")
## Fall acceleration (e.g. gravity)
@export var gravity: = 200.0
## Max fall speed
@export var terminal_velocity: = 85.0
## Horizontal acceleration in the air
@export var air_acceleration: = 120.0
## Max horizontal speed in the air
@export var air_max_speed: = 32.0
## Friction applied to stop horizontal movement in the air
@export var air_friction: = 75.0
## Force applied when jumping while in the air (double, triple, quadruple, etc. jump)
@export var air_jump_force: = 75.0

@export_group("Wall Movement")
## Fall acceleration when wall sliding
@export var wall_slide_acceleration: = 100.0
## Max fall speed when attached to a wall
@export var wall_slide_max_speed: = 30.0
## Upward force when wall jumping
@export var wall_jump_force: = 65.0
## Horizontal speed when wall jumping
@export var wall_jump_speed: = 32.0
