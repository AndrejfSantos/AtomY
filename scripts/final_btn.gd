extends Label
class_name FinalBtn

signal pressed

var electron_nodes :Array[Node2D]
var selected = false
var counter = 0
var electrons = 0
var font_size : int # the original font size
var electrons_scale : Vector2 # the original font size


func _ready() -> void:
	electron_nodes = []
	electron_nodes.append($"eletrons/1")
	electron_nodes.append($"eletrons/2")
	electron_nodes.append($"eletrons/3")
	electron_nodes.append($"eletrons/4")
	electron_nodes.append($"eletrons/5")
	for electron in electron_nodes:
		electron.visible = false
	
	font_size = get_theme_font_size("font_size")
	electrons_scale = $eletrons.scale
	center_electrons()


func center_electrons() -> void:
	# $Title_tm.set_global_position(Vector2($Title.global_position.x+$Title.size.x,42))
	$eletrons.set_global_position(Vector2(global_position.x+size.x/2,global_position.y+size.y/2))


func _process(delta: float) -> void:
	if selected:
		counter += delta
		if counter > 0.42 && electrons<5:
			counter-=0.42
			$eletrons.scale *= 1.1
			add_theme_font_size_override("font_size",get_theme_font_size("font_size")+3)
			electrons+=1
			center_electrons()
			for electron in electron_nodes:
				if !electron.visible:
					electron.visible = true
					break


func _on_mouse_entered() -> void:
	select() 

func _on_mouse_exited() -> void:
	deselect()

func select() -> void:
	selected = true

func deselect() -> void:
	add_theme_font_size_override("font_size",font_size)
	selected = false
	counter = 0
	electrons = 0
	$eletrons.scale = electrons_scale
	for electron in electron_nodes:
		electron.visible = false

func _input(event: InputEvent) -> void:
	if electrons == 5 && event.is_action("action_accept"):
		emit_signal("pressed")
