extends HBoxContainer

var common = load("res://Scripts/common.gd").new("Main");

signal option_pressed(id);

var visibility := {};

# Called when the node enters the scene tree for the first time.
func _ready():
	set_visibility(common.Item_types.PROTRACTOR, false);
	set_visibility(common.Item_types.COMPASS, false);
	set_visibility(common.Item_types.TRIANGLE, false);
	set_visibility(common.Item_types.PENCIL, false);
	
func set_visibility(key: int, status: bool):
	visibility[key] = status;

func _on_popup_menu_id_pressed(id):
	emit_signal("option_pressed", id);

func _on_compass_menu_pressed():	
	var menu = $compass_menu.get_popup();
	menu.clear();	
	if not visibility[common.Item_types.COMPASS]:
		menu.add_item("Mostrar compas", common.Popup_options.SHOW_COMPASS);
	else:		
		menu.add_item("Ocultar compas", common.Popup_options.HIDE_COMPASS);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");

func _on_protractor_menu_pressed():	
	var menu = $protractor_menu.get_popup();
	menu.clear();
	if not visibility[common.Item_types.PROTRACTOR]:
		menu.add_item("Mostrar transportador", common.Popup_options.SHOW_PROTRACTOR);
	else:
		menu.add_item("Ocultar transportador", common.Popup_options.HIDE_PROTRACTOR);
		menu.add_item("Mover transportador", common.Popup_options.MOVE_PROTRACTOR);
		menu.add_item("Girar transportador", common.Popup_options.TURN_PROTRACTOR);
		menu.add_item("Voltear transportador", common.Popup_options.FLIP_PROTRACTOR);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");

func _on_triangle_menu_pressed():
	var menu = $triangle_menu.get_popup();
	menu.clear();
	if not visibility[common.Item_types.TRIANGLE]:
		menu.add_item("Mostrar cartabón", common.Popup_options.SHOW_TRIANGLE);
	else:
		menu.add_item("Ocultar cartabón", common.Popup_options.HIDE_TRIANGLE);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");

func _on_chart_menu_pressed():
	var menu = $carta_menu.get_popup();
	menu.clear();
	menu.add_item("Mover carta náutica", common.Popup_options.MOVE_CHART);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");

func _on_pencil_menu_pressed():
	var menu = $pencil_menu.get_popup();
	menu.clear();
	
	if not visibility[common.Item_types.PENCIL]:
		menu.add_item("Mostrar lápiz", common.Popup_options.SHOW_PENCIL);
	else:
		menu.add_item("Ocultar lápiz", common.Popup_options.HIDE_PENCIL);
		menu.add_item("Mover lápiz", common.Popup_options.MOVE_PENCIL);
		menu.add_item("Voltear lápìz", common.Popup_options.FLIP_PENCIL);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");

func _on_quit_menu_pressed():
	var menu = $quit_menu.get_popup();
	menu.clear();
	menu.add_item("Estoy seguro", common.Popup_options.QUIT_YES);
	menu.add_item("Cancelar", common.Popup_options.QUIT_NO);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");
