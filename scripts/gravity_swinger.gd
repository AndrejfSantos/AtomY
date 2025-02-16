extends Pingable
class_name GravitySwinger

const FAN_ANIMATION_SPEED_IDLE = 0.666
const FAN_ANIMATION_SPEED_OC = 3

@export var directions: Array[DIRECTION]
enum DIRECTION {UP,RIGHT,LEFT,DOWN}

var player_inside: AtomPlayer
var direction: DIRECTION
var direction_idx : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$fanAnimationPlayer.speed_scale = FAN_ANIMATION_SPEED_IDLE
	direction_idx = 0


func set_direction(new_direction:DIRECTION) -> void:
	direction = new_direction
	match direction:
		DIRECTION.UP:
			$ArrowWarnings.rotation_degrees = 90.0
		DIRECTION.DOWN:
			$ArrowWarnings.rotation_degrees = -90.0
		DIRECTION.RIGHT:
			$ArrowWarnings.rotation_degrees = 180.0
		DIRECTION.LEFT:
			$ArrowWarnings.rotation_degrees = 0.0
	$ArrowsAnimationPlayer.play("new_animation")
	if player_inside!=null:
		apply_force_to_player()

func apply_force_to_player() -> void:
	match direction:
		DIRECTION.UP:
			player_inside.apply_y_force(-1.25)
		DIRECTION.DOWN:
			player_inside.apply_y_force(1.25)
		DIRECTION.RIGHT:
			player_inside.apply_x_force(1.25)
		DIRECTION.LEFT:
			player_inside.apply_x_force(-1.25)


func _on_area_2d_body_entered(player: AtomPlayer) -> void:
	player_inside = player
	apply_force_to_player()

func _on_area_2d_body_exited(_player: AtomPlayer) -> void:
	player_inside.reset_apply_force()
	player_inside = null

func ping() -> void:
	$fanAnimationPlayer.speed_scale = FAN_ANIMATION_SPEED_OC
	$Timer.start()

func _on_timer_timeout() -> void:
	$fanAnimationPlayer.speed_scale = FAN_ANIMATION_SPEED_IDLE
	direction_idx +=1
	if direction_idx >= directions.size():
		direction_idx = 0
	
	set_direction(directions[direction_idx])
