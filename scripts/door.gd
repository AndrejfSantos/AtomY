extends Pingable

@export var to_lvl :String

func _on_area_2d_body_entered(_body: Node2D) -> void:
	get_tree().call_deferred("change_scene_to_file","res://scenes/lvls/lvl_"+to_lvl+".tscn")

func ping() -> void:
	$AnimationPlayer.play("door_animation")
