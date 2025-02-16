extends Turnable

var turnables :Array[Turnable]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Turnable:
			turnables.append(child)
			child.visible = false
	for turnable in turnables:
		turnable.turn_off()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	$AudioStreamPlayer.play()
	$Sprite2D.visible = false
	$Area2D.set_deferred("monitoring",false)
	for turnable in turnables:
		turnable.turn_on()
	
func ping() -> void:
	for turnable in turnables:
		turnable.ping()
		
func turn_on() -> void:
	$Area2D.set_deferred("monitoring",true)
	visible = true

func turn_off() -> void:
	$Area2D.monitoring = false
	visible = false
