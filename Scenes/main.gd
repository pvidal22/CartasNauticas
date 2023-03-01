extends Node

var common = load("res://Scripts/common.gd").new("Main");

# Called when the node enters the scene tree for the first time.
func _ready():
	# To center it.
	var this_screen_size = OS.get_screen_size(-1);
	var this_window_size = OS.get_window_size();
	OS.set_window_position(this_screen_size*0.5 - this_window_size*0.5);

	var scale_factor = $chart.texture.get_size();
	scale_factor = Vector2(scale_factor.x / $chart.size_mm.x, scale_factor.y / $chart.size_mm.y);
	$protractor.set_scale_factor(scale_factor);
	$triangle.set_scale_factor(scale_factor);

func _input(ev):
	if ev is InputEventMouseButton:
		ev = ev as InputEventMouseButton
		if ev.pressed:
			match ev.button_index:
				BUTTON_WHEEL_UP:
					zoom_in();
				BUTTON_WHEEL_DOWN:
					zoom_out();
		if ev.button_index == 1 and ev.doubleclick:
			print("Stop all");
			common.stop_it();
			$chart.stop_it();
			$protractor.stop_it();
#			$compass.stop_it();
			$triangle.stop_it();
			$pencil.stop_it()

func _on_options_menu_option_pressed(id):
	match id:
		common.Popup_options.SHOW_COMPASS:
			$compass.visible = true;
			$compass/Collision_shape.disabled = false;
			$options_menu.set_visibility(common.Item_types.COMPASS, true);
		common.Popup_options.HIDE_COMPASS:
			$compass.visible = false;
			$compass/Collision_shape.disabled = true;
			$options_menu.set_visibility(common.Item_types.COMPASS, false);
		common.Popup_options.SHOW_PROTRACTOR:
			$protractor.visible = true;
			$protractor/Collision_shape.disabled = false;
			$options_menu.set_visibility(common.Item_types.PROTRACTOR, true);
		common.Popup_options.HIDE_PROTRACTOR:
			$protractor.visible = false;
			$protractor/Collision_shape.disabled = true;
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
			$pencil/Collision_shape.disabled = false;
			$options_menu.set_visibility(common.Item_types.PENCIL, true);
		common.Popup_options.HIDE_PENCIL:
			$pencil.visible = false;
			$pencil/Collision_shape.disabled = true;
			$pencil.stop_it();
			$options_menu.set_visibility(common.Item_types.PENCIL, false);
		common.Popup_options.MOVE_PENCIL:
			$pencil.start_moving();
		common.Popup_options.TURN_PENCIL:
			$pencil.start_turning();
		common.Popup_options.FLIP_PENCIL:
			$pencil.flip_it();
		common.Popup_options.DOT_PENCIL:
			var pencil_position = $pencil.get_position();
			$drawings.add_circle(pencil_position, 0);
			$drawings.add_circle(pencil_position, 1);
			$drawings.add_circle(pencil_position, 2);			
		common.Popup_options.LINE_PENCIL:
			var position = $pencil.get_line_normal_to_collision()[0];
			var direction_vector = $pencil.get_line_normal_to_collision()[1];
			var new_position = position + 10000 * direction_vector;
			$drawings.add_line(position, new_position);
			new_position = position - 10000 * direction_vector;
			$drawings.add_line(position, new_position);
		common.Popup_options.SHOW_TRIANGLE:
			$triangle.visible = true;
			$triangle/Collision_shape.disabled = false;
			$options_menu.set_visibility(common.Item_types.TRIANGLE, true);
		common.Popup_options.HIDE_TRIANGLE:
			$triangle.visible = false;
			$triangle/Collision_shape.disabled = true;
			$triangle.stop_it();
			$options_menu.set_visibility(common.Item_types.TRIANGLE, false);
		common.Popup_options.MOVE_TRIANGLE:
			$triangle.start_moving();
		common.Popup_options.TURN_TRIANGLE:
			$triangle.start_turning();
		common.Popup_options.FLIP_TRIANGLE:
			$triangle.flip_it();
		common.Popup_options.MOVE_CHART:
			$chart.start_moving();
		common.Popup_options.QUIT_NO:
			#test_functions();
			pass;
		common.Popup_options.QUIT_YES:
			print("Nos vemos!!!");
			get_tree().quit();
		_:
			print("Option not identified in _on_popup_menu_id_pressed: " + str(id));
			
func zoom_in():
	print("Zoom in");
	
func zoom_out():
	print("Zoom out");

func test_functions():
	$drawings.add_line(Vector2(0,0), Vector2(500, 500));
	$drawings.add_circle(Vector2(500,500), 30.5);
	$drawings.update();
