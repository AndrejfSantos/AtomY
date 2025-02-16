extends CharacterBody2D
class_name AtomPlayer

const INITIAL_SPEED_MODIFIER = 3

# The impact of the gravity swings depends on the number of electrons
const APPLIED_FORCE_ELECTRON_MODIFIER = [1,0.85,0.7,0.6,0.5,0.4]
# The impact of the gravity swings depends on secondary Axis
const APPLIED_FORCE_OTHER_AXIS_ELECTRON_MODIFIER = [0.2,0.3,0.35,0.4,0.45,0.5]

var speed_base = 42.0
var speed = speed_base*INITIAL_SPEED_MODIFIER
var electron_nodes :Array[Node2D]
var electrons : int

var applied_force :bool
var applied_force_x :float
var applied_force_y :float

# used for decorations
@export var show_all_eletrons = false

func _ready() -> void:
	electrons = 0
	reset_apply_force()
	electron_nodes = []
	electron_nodes.append($"eletrons/1")
	electron_nodes.append($"eletrons/2")
	electron_nodes.append($"eletrons/3")
	electron_nodes.append($"eletrons/4")
	electron_nodes.append($"eletrons/5")
	
	for electron in electron_nodes:
		electron.visible = show_all_eletrons

func apply_x_force(directionX:float)-> void:
	applied_force = true
	applied_force_x = directionX * APPLIED_FORCE_ELECTRON_MODIFIER[electrons]
	applied_force_y = 0.0

func apply_y_force(directionY:float)-> void:
	applied_force = true
	applied_force_x = 0.0
	applied_force_y = directionY * APPLIED_FORCE_ELECTRON_MODIFIER[electrons]

func reset_apply_force()-> void:
	applied_force = false
	applied_force_x = 0.0
	applied_force_y = 0.0

func _physics_process(_delta: float) -> void:
	var directionX := Input.get_axis("move_l", "move_r")
	var directionY := Input.get_axis("move_up", "move_down")
	if applied_force:
		physics_process_applied_force(directionX,directionY)
	else:
		physics_process_normal(directionX,directionY)
	move_and_slide()

func physics_process_normal(directionX: float,directionY: float) -> void:
	if directionX:
		velocity.x = directionX * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if directionY:
		velocity.y = directionY * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)


func physics_process_applied_force(directionX: float,directionY: float) -> void:

	if applied_force_x :
		directionX += applied_force_x
		directionY *= APPLIED_FORCE_OTHER_AXIS_ELECTRON_MODIFIER[electrons]
	elif applied_force_y:
		directionX *= APPLIED_FORCE_OTHER_AXIS_ELECTRON_MODIFIER[electrons]
		directionY += applied_force_y
	
	if directionX:
		velocity.x = directionX * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if directionY:
		velocity.y = directionY * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

func eletron_picked():
	$PickUpAudio.play()
	electrons += 1
	speed += speed_base
	speed_base -= 4
	for electron in electron_nodes:
		if !electron.visible:
			electron.visible = true
			break

func hit():
	if electrons == 0:
		speed *= 0.1
		$DieAudio.play()
		await get_tree().create_timer(0.75).timeout
		get_tree().call_deferred("reload_current_scene")
		
	else:
		$HitAudio.play()
		electrons -= 1
		speed_base += 4
		speed -= speed_base
		for electron in electron_nodes:
			if electron.visible:
				electron.visible = false
				break
		
