extends Pingable
class_name GreenPath


var green_follow = preload("res://scenes/green_follow.tscn")
# Called when the node enters the scene tree for the first time.

func ping():
	var instance = green_follow.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	add_child(instance)
