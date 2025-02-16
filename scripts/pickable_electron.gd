extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.seek(RandomNumberGenerator.new().randf_range(0.1, 0.9))


func _on_area_2d_body_entered(player: AtomPlayer) -> void:
	player.eletron_picked()
	queue_free()
