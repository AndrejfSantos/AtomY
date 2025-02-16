extends Control
class_name StartMenu

const OPTIONS_SAVE_PATH ="user://options.cfg"
const OPTIONS_SECTION = "options"
const OPTIONS_KEY_LANG = "lang"
const OPTIONS_KEY_SFX = "sfx"
var config = ConfigFile.new()
@export var start_n_pause = false

func _ready() -> void:
	if start_n_pause:
		$Title.visible = true
		$Title_tm.visible = true
		$StartContainer/Play.visible = true
		$StartContainer/Play.grab_focus()
		$StartContainer/Resume.visible = false
		visible = true
	else:
		$Title.visible = false
		$Title_tm.visible = false
		$StartContainer/Play.visible = false
		$StartContainer/Resume.visible = true
		$StartContainer/Resume.grab_focus()
	
	get_node("StartContainer").visible=true
	get_node("OptionsContainer").visible=false
	
	load_or_save_defaults()

	load_lang_from_options()
	load_sound_from_options()


func load_or_save_defaults():
	# no need to read _err, self fix ahead
	var _err = config.load(OPTIONS_SAVE_PATH)

	var sfx = config.get_value(OPTIONS_SECTION, OPTIONS_KEY_SFX,null)
	if sfx == null:
		var cb = get_node("OptionsContainer/SoundCheckBox/CheckBox") as CheckBox
		cb.button_pressed = false
		_on_sound_check_box_toggled()
		
	var lang = config.get_value(OPTIONS_SECTION, OPTIONS_KEY_LANG,null)
	if lang == null:
		_on_option_button_item_selected(0)
	

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/lvls/lvl_1.tscn")

func _on_options_pressed() -> void:
	get_node("StartContainer").visible=false
	get_node("OptionsContainer").visible=true
	$OptionsContainer/SoundCheckBox.grab_focus()

func _on_option_button_item_selected(index: int) -> void:
	var lang :String
	match index:
		0:
			lang="en"
		1:
			lang ="pt"
		2:
			lang="de"
	
	config.set_value(OPTIONS_SECTION, OPTIONS_KEY_LANG, lang)
	config.save(OPTIONS_SAVE_PATH)
	load_lang_from_options()

func load_lang_from_options():
	var lang = config.get_value(OPTIONS_SECTION, OPTIONS_KEY_LANG)
	TranslationServer.set_locale(lang)
	
	var ob = get_node("OptionsContainer/LangOption") as OptionButton
	match lang:
		"en":
			ob.selected = 0
		"pt":
			ob.selected = 1
		"de":
			ob.selected = 2
	
	call_deferred("update_tm_position")
	
func update_tm_position() -> void:
	# used to update the Title_tm position due to lenght change on Title
	$Title_tm.set_global_position(Vector2($Title.global_position.x+$Title.size.x,42))

func _on_sound_check_box_toggled() -> void:
	var cb = get_node("OptionsContainer/SoundCheckBox/CheckBox") as CheckBox
	var toggled_on = !cb.is_pressed()
	config.set_value(OPTIONS_SECTION, OPTIONS_KEY_SFX, toggled_on)
	config.save(OPTIONS_SAVE_PATH)
	load_sound_from_options()

func load_sound_from_options():
	var sfx = config.get_value(OPTIONS_SECTION, OPTIONS_KEY_SFX)
	var sfx_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(sfx_bus,!sfx)
	var cb = get_node("OptionsContainer/SoundCheckBox/CheckBox") as CheckBox
	cb.button_pressed = sfx

func _on_back_pressed() -> void:
	get_node("StartContainer").visible=true
	if start_n_pause:
		$StartContainer/Play.grab_focus()
	else:
		$StartContainer/Resume.grab_focus()
	get_node("OptionsContainer").visible=false


func _on_resume_pressed():
	get_tree().paused = false
	queue_free()
