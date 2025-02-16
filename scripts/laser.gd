extends Turnable
class_name Laser

func _on_area_2d_body_entered(atomPlayer: AtomPlayer) -> void:
	atomPlayer.hit()

func turn_on() -> void:
	$Area2D.set_deferred("monitoring",true)
	visible = true

func turn_off() -> void:
	$Area2D.monitoring = false
	visible = false

func ping() -> void:
	$AnimationPlayer.play("laser_animation")
