extends PathFollow2D

const SPEED = 250.0

func _physics_process(delta):
	progress += SPEED*delta

	if progress_ratio == 1.0:
		queue_free()
	
