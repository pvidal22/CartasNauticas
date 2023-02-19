extends ScrollContainer

export var width_mm: int = 602;
export var height_mm: int = 442;

var size: Vector2 = Vector2.ZERO;
var compass_visible: bool = false;
var protractor_visible: bool = false;
var triangle_rule_visible: bool = false;

enum Popup_options {SHOW_COMPASS, HIDE_COMPASS, SHOW_PROTRACTOR, HIDE_PROTRACTOR, SHOW_TRIANGLE \
	, HIDE_TRIANGLE, CANCEL};

# Called when the node enters the scene tree for the first time.
func _ready():
	size = get_viewport_rect().size;
	print("Size: " + str(size));

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_popup_menus();
	
func _input(event):
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.pressed:
			match event.button_index:
				BUTTON_WHEEL_UP:
					print("up")
				BUTTON_WHEEL_DOWN:
					print("down")

func check_popup_menus():
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
	self.get_node("popup_menu").queue_free();

	match id:
		Popup_options.HIDE_COMPASS:
			$compass.visible = false;
		Popup_options.HIDE_PROTRACTOR:
			$protractor.visible = false;
		Popup_options.HIDE_TRIANGLE:
			$triangle_ruler.visible = false;
		Popup_options.SHOW_COMPASS:
			$compass.visible = true;
		Popup_options.SHOW_PROTRACTOR:
			$protractor.visible = true;
		Popup_options.SHOW_TRIANGLE:
			$triangle_ruler.visible = true;
		_:
			print("Option not identified in _on_popup_menu_id_pressed: " + str(id));
		
