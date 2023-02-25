extends TextureRect

export var size_mm: Vector2 = Vector2(602, 442);

var size: Vector2 = Vector2.ZERO;
var compass_visible: bool = false;
var protractor_visible: bool = false;
var triangle_rule_visible: bool = false;
var previous_mouse_position: Vector2 = Vector2.ZERO;
var is_first := true;

enum Popup_options {\
	MOVE_CHART \
	, SHOW_COMPASS, HIDE_COMPASS\
	, SHOW_PROTRACTOR, HIDE_PROTRACTOR, MOVE_PROTRACTOR, TURN_PROTRACTOR, FLIP_PROTRACTOR\
	, SHOW_PENCIL, HIDE_PENCIL, MOVE_PENCIL, FLIP_PENCIL \
	, SHOW_TRIANGLE, HIDE_TRIANGLE\
	, CANCEL\
	, QUIT_YES, QUIT_NO};

var common = load("res://school_items.gd").new("Nautical Chart");

# Called when the node enters the scene tree for the first time.
func _ready():
	size = get_viewport_rect().size;
	print("Size: " + str(size));

	var scale_factor: Vector2 = get_size();
	scale_factor = Vector2(scale_factor.x / size_mm.x, scale_factor.y / size_mm.y);
	$protractor.set_scale_factor(scale_factor);

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


func check_popup_menus():
	### NOT USED !!!!
	if !Input.is_action_just_pressed("click_right"):
		return;
		
	var popup_menu: PopupMenu = PopupMenu.new();
	
	var submenu: PopupMenu = PopupMenu.new();
	submenu.set_name("sub_compass");
	if $compass.visible:
		submenu.add_item("Ocultar compas", Popup_options.HIDE_COMPASS);
	else:
		submenu.add_item("Mostrar compas", Popup_options.SHOW_COMPASS);
	
	submenu.connect("id_pressed", self, "_on_popup_menu_id_pressed");
	popup_menu.add_child(submenu);
	
	submenu = PopupMenu.new();	
	submenu.set_name("sub_protractor");
	if $protractor.visible:
		submenu.add_item("Ocultar transportador", Popup_options.HIDE_PROTRACTOR);
	else:
		submenu.add_item("Mostrar transportador", Popup_options.SHOW_PROTRACTOR);
	
	submenu.connect("id_pressed", self, "_on_popup_menu_id_pressed");
	popup_menu.add_child(submenu);
	
	submenu = PopupMenu.new();
	submenu.set_name("sub_triangle");
	if $triangle_ruler.visible:
		submenu.add_item("Ocultar cartabón", Popup_options.HIDE_TRIANGLE);
	else:
		submenu.add_item("Mostrar cartabón", Popup_options.SHOW_TRIANGLE);
		
	submenu.connect("id_pressed", self, "_on_popup_menu_id_pressed");
	popup_menu.add_child(submenu);
	
	popup_menu.add_submenu_item("Compas", "sub_compass");
	popup_menu.add_submenu_item("Transportador de ángulos", "sub_protractor");
	popup_menu.add_submenu_item("Cartabón", "sub_triangle");
	popup_menu.set_name("popup_menu");
	self.add_child(popup_menu);	
	popup_menu.add_item("Cancel", Popup_options.CANCEL);
	popup_menu.visible = true
		
func _on_popup_menu_id_pressed(id):
	match id:
		Popup_options.HIDE_COMPASS:
			$compass.visible = false;
		Popup_options.SHOW_COMPASS:
			$compass.visible = true;
		Popup_options.SHOW_PROTRACTOR:
			$protractor.visible = true;
		Popup_options.HIDE_PROTRACTOR:
			$protractor.visible = false;
			$protractor.stop_it();
		Popup_options.MOVE_PROTRACTOR:
			$protractor.start_moving();
		Popup_options.TURN_PROTRACTOR:
			$protractor.start_turning();
		Popup_options.FLIP_PROTRACTOR:
			$protractor.flip_it();
		Popup_options.SHOW_PENCIL:
			$pencil.visible = true;
		Popup_options.HIDE_PENCIL:
			$pencil.visible = false;
			$pencil.stop_it();
		Popup_options.MOVE_PENCIL:
			$pencil.start_moving();
		Popup_options.FLIP_PENCIL:
			$pencil.flip_it();
		Popup_options.SHOW_TRIANGLE:
			$triangle_ruler.visible = true;
		Popup_options.HIDE_TRIANGLE:
			$triangle_ruler.visible = false;
		Popup_options.MOVE_CHART:
			move_chart();
		Popup_options.QUIT_NO:
			pass;
		Popup_options.QUIT_YES:
			print("Nos vemos!!!");
			get_tree().quit();
		_:
			print("Option not identified in _on_popup_menu_id_pressed: " + str(id));

func _on_compass_menu_pressed():	
	var menu = $options_menu/compass_menu.get_popup();
	menu.clear();	
	if not $compass.visible:
		menu.add_item("Mostrar compas", Popup_options.SHOW_COMPASS);
	else:
		menu.add_item("Ocultar compas", Popup_options.HIDE_COMPASS);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");

func _on_protractor_menu_pressed():	
	var menu = $options_menu/protractor_menu.get_popup();
	menu.clear();
	if not $protractor.visible:
		menu.add_item("Mostrar transportador", Popup_options.SHOW_PROTRACTOR);
	else:
		menu.add_item("Ocultar transportador", Popup_options.HIDE_PROTRACTOR);
		menu.add_item("Mover transportador", Popup_options.MOVE_PROTRACTOR);
		menu.add_item("Girar transportador", Popup_options.TURN_PROTRACTOR);
		menu.add_item("Voltear transportador", Popup_options.FLIP_PROTRACTOR);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");

func _on_triangle_menu_pressed():
	var menu = $options_menu/triangle_menu.get_popup();
	menu.clear();
	if not $triangle_ruler.visible:
		menu.add_item("Mostrar cartabón", Popup_options.SHOW_TRIANGLE);
	else:
		menu.add_item("Ocultar cartabón", Popup_options.HIDE_TRIANGLE);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");

func _on_carta_menu_pressed():
	var menu = $options_menu/carta_menu.get_popup();
	menu.clear();
	menu.add_item("Mover carta náutica", Popup_options.MOVE_CHART);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");

func _on_pencil_menu_pressed():
	var menu = $options_menu/pencil_menu.get_popup();
	menu.clear();
	
	if not $pencil.visible:
		menu.add_item("Mostrar lápiz", Popup_options.SHOW_PENCIL);
	else:
		menu.add_item("Ocultar lápiz", Popup_options.HIDE_PENCIL);
		menu.add_item("Mover lápiz", Popup_options.MOVE_PENCIL);
		menu.add_item("Voltear lápìz", Popup_options.FLIP_PENCIL);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");

func _on_quit_menu_pressed():
	var menu = $options_menu/quit_menu.get_popup();
	menu.clear();
	menu.add_item("Estoy seguro", Popup_options.QUIT_YES);
	menu.add_item("Cancelar", Popup_options.QUIT_NO);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");
	
func move_chart():
	common.start_moving(get_viewport().get_mouse_position());
	
func _process(delta):
	if is_first:		
		var texture = get_size() / 2;
		var this_size = size / 2;
		set_position(this_size - texture);
		
		is_first = false;
		

	if common.get_moving(): move_it();
	
func move_it():
	var mouse_position := get_viewport().get_mouse_position();	
	var canvas := get_viewport_rect().size;
	var texture = $TextureRect.get_size();
	var this_position = $TextureRect.get_position();
	if previous_mouse_position != Vector2.ZERO:
		var delta := Vector2(mouse_position - previous_mouse_position);
		this_position += Vector2(delta.x if abs(delta.x) < 10 else 0, delta.y if abs(delta.y) < 10 else 0);
		
	# Clamping it.
	if this_position.x > 0: this_position.x = 0;
	if this_position.x + texture.x < canvas.x: this_position.x = canvas.x - texture.x;
	if this_position.y > 0: this_position.y = 0;
	if this_position.y + texture.y < canvas.y: this_position.y = canvas.y - texture.y;

	$TextureRect.set_position(this_position);
	previous_mouse_position = mouse_position;
