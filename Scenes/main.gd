extends Node
var compass_visible: bool = false;
var protractor_visible: bool = false;
var triangle_rule_visible: bool = false;
var previous_mouse_position: Vector2 = Vector2.ZERO;

var common = load("res://Scripts/common.gd").new("Main");

# Called when the node enters the scene tree for the first time.
func _ready():
	# To center it.
	var this_screen_size = OS.get_screen_size(-1);
	var this_window_size = OS.get_window_size();
	OS.set_window_position(this_screen_size*0.5 - this_window_size*0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.	
func _input(ev):
	if ev is InputEventMouseButton:
		ev = ev as InputEventMouseButton
		if ev.pressed:
			match ev.button_index:
				BUTTON_WHEEL_UP:
					print("up")
				BUTTON_WHEEL_DOWN:
					print("down")
		if ev.button_index == 1 and ev.doubleclick:
			print("Stop all");
			common.stop_it();
			$protractor.stop_it();
			#$compass.stop_it();
			#$triangle_ruler.stop_it();

func _on_options_menu_option_pressed(id):
	match id:
		common.Popup_options.HIDE_COMPASS:
			$compass.visible = false;
		common.Popup_options.SHOW_COMPASS:
			$compass.visible = true;
		common.Popup_options.SHOW_PROTRACTOR:
			$protractor.visible = true;			
			$options_menu.set_visibility(common.Item_types.PROTRACTOR, true);
		common.Popup_options.HIDE_PROTRACTOR:
			$protractor.visible = false;
			$protractor.stop_it();
			$options_menu.set_visibility(common.Item_types.PROTRACTOR, false);
		common.Popup_options.MOVE_PROTRACTOR:
			$protractor.start_moving();
		common.Popup_options.TURN_PROTRACTOR:
			$protractor.start_turning();
		common.Popup_options.FLIP_PROTRACTOR:
			$protractor.flip_it();
		common.Popup_options.SHOW_PENCIL:
			$pencil.visible = true;
			$options_menu.set_visibility(common.Item_types.PENCIL, true);
		common.Popup_options.HIDE_PENCIL:
			$pencil.visible = false;
			$pencil.stop_it();
			$options_menu.set_visibility(common.Item_types.PENCIL, false);
		common.Popup_options.MOVE_PENCIL:
			$pencil.start_moving();
		common.Popup_options.FLIP_PENCIL:
			$pencil.flip_it();
		common.Popup_options.SHOW_TRIANGLE:
			$triangle_ruler.visible = true;
		common.Popup_options.HIDE_TRIANGLE:
			$triangle_ruler.visible = false;
		common.Popup_options.MOVE_CHART:
			pass;
			#move_chart();
		common.Popup_options.QUIT_NO:
			pass;
		common.Popup_options.QUIT_YES:
			print("Nos vemos!!!");
			get_tree().quit();
		_:
			print("Option not identified in _on_popup_menu_id_pressed: " + str(id));
