extends HBoxContainer

var comu = load("res://Scripts/comu.gd").new("Main");

signal option_pressed(id);

var visibilitat := {};

# Called when the node enters the scene tree for the first time.
func _ready():
	assignar_visibilitat(comu.Tipus_objecte.TRANSPORTADOR, false);
	assignar_visibilitat(comu.Tipus_objecte.COMPAS, false);
	assignar_visibilitat(comu.Tipus_objecte.CARTABO, false);
	assignar_visibilitat(comu.Tipus_objecte.LLAPIS, false);
	
func assignar_visibilitat(clau: int, estat: bool):
	visibilitat[clau] = estat;

func _on_popup_menu_id_pressed(id):
	emit_signal("option_pressed", id);

func _on_compass_menu_pressed():	
	var menu = $menu_compas.get_popup();
	menu.clear();	
	if not visibilitat[comu.Tipus_objecte.COMPAS]:
		menu.add_item("Mostrar compas", comu.Opcions_popup.MOSTRAR_COMPAS);
	else:		
		menu.add_item("Ocultar compas", comu.Opcions_popup.AMAGAR_COMPAS);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");

func _on_protractor_menu_pressed():	
	var menu = $menu_transportador.get_popup();
	menu.clear();
	if not visibilitat[comu.Tipus_objecte.TRANSPORTADOR]:
		menu.add_item("Mostrar transportador", comu.Opcions_popup.MOSTRAR_TRANSPORTADOR);
	else:
		menu.add_item("Ocultar transportador", comu.Opcions_popup.AMAGAR_TRANSPORTADOR);
		menu.add_item("Mover transportador", comu.Opcions_popup.MOURE_TRANSPORTADOR);
		menu.add_item("Girar transportador", comu.Opcions_popup.GIRAR_TRANSPORTADOR);
		#menu.add_item("Voltear transportador", comu.Opcions_popup.VOLTEJAR_TRANSPORTADOR);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");

func _on_triangle_menu_pressed():
	var menu = $menu_cartabo.get_popup();
	menu.clear();
	if not visibilitat[comu.Tipus_objecte.CARTABO]:
		menu.add_item("Mostrar cartabón", comu.Opcions_popup.MOSTRAR_CARTABO);
	else:
		menu.add_item("Ocultar cartabón", comu.Opcions_popup.AMAGAR_CARTABO);
		menu.add_item("Mover cartabón", comu.Opcions_popup.MOURE_CARTABO);
		menu.add_item("Girar cartabón", comu.Opcions_popup.GIRAR_CARTABO);
		#menu.add_item("Voltear cartabón", comu.Opcions_popup.VOLTEJAR_CARTABO);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");

func _on_chart_menu_pressed():
	var menu = $menu_carta.get_popup();
	menu.clear();
	menu.add_item("Mover carta náutica", comu.Opcions_popup.MOURE_CARTA);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");

func _on_pencil_menu_pressed():
	var menu = $menu_llapis.get_popup();
	menu.clear();
	
	if not visibilitat[comu.Tipus_objecte.LLAPIS]:
		menu.add_item("Mostrar lápiz", comu.Opcions_popup.MOSTRAR_LLAPIS);
	else:
		menu.add_item("Ocultar lápiz", comu.Opcions_popup.AMAGAR_LLAPIS);
		menu.add_item("Mover lápiz", comu.Opcions_popup.MOURE_LLAPIS);
		menu.add_item("Girar lápiz", comu.Opcions_popup.GIRAR_LLAPIS);
		menu.add_item("Hacer un punto", comu.Opcions_popup.PUNT_LLAPIS);
		menu.add_item("Hacer una línea", comu.Opcions_popup.LINIA_LLAPIS);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");

func _on_quit_menu_pressed():
	var menu = $menu_sortir.get_popup();
	menu.clear();
	menu.add_item("Estoy seguro", comu.Opcions_popup.SORTIR_SI);
	menu.add_item("Cancelar", comu.Opcions_popup.SORTIR_NO);
	menu.add_item("Versión: 20230308_02", comu.Opcions_popup.SORTIR_NO);
	
	menu.connect("id_pressed", self, "_on_popup_menu_id_pressed");
