extends Control

var yes_btn : FinalBtn
var no_btn : FinalBtn
@export var allow_input = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yes_btn = $CenterContainer/DialogVBoxContainer/HBoxContainer/MarginContainer/Yes
	no_btn = $CenterContainer/DialogVBoxContainer/HBoxContainer/MarginContainer2/No
	$AudioStreamPlayer.play()
	update_tm_position()


func update_tm_position() -> void:
	# used to update the Title_tm position due to lenght change on Title
	$Title_tm.set_global_position(Vector2($Title.global_position.x+$Title.size.x,42))
	
func _input(event: InputEvent) -> void:
	if !allow_input:
		return
	if event.is_action("ui_left"):
		yes_btn.select()
		no_btn.deselect()
	elif event.is_action("ui_right"):
		yes_btn.deselect()
		no_btn.select()

func show_final_msg_and_move_on(label:Label) -> void:
	$CenterContainer/DialogVBoxContainer.visible=false
	label.visible = true
	await get_tree().create_timer(5.0).timeout
	get_tree().call_deferred("change_scene_to_file","res://scenes/start_menu.tscn")
	
	
func _on_yes_pressed() -> void:
	show_final_msg_and_move_on($CenterContainer/LabelWin)


func _on_no_pressed() -> void:
	show_final_msg_and_move_on($CenterContainer/LabelLose)
