extends Node2D

var pingables :Array[Pingable]
var timer : Timer
var menu_scene = preload("res://scenes/start_menu.tscn")
var menu_instance : StartMenu
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pingables = []
	for child in get_children():
		if child is Pingable:
			pingables.append(child)
	
	# adding a timer here to prevent multiple Timers in multiple scenes on lvls
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(Callable(self, "on_timer_timeout"))
	timer.wait_time = 3
	timer.one_shot = false
	timer.start()
	on_timer_timeout()

func on_timer_timeout() -> void:
	for pingable in pingables:
		pingable.ping()

func _input(event: InputEvent) -> void:
	if event.is_action("action_pause") && event.is_pressed():
		if menu_instance == null:
			menu_instance = menu_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED) as StartMenu 
			menu_instance.start_n_pause = false
			menu_instance.set_global_position(get_viewport().get_visible_rect().size / 2.0)
			add_child(menu_instance)
		else:
			menu_instance.queue_free()
			menu_instance = null
		
