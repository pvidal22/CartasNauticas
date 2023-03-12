extends Node

var versio := "20230312_30";
var comu = load("res://Scripts/comu.gd").new("Principal");
var objectes = null;
var objectes_mostrats := {
	comu.Tipus_objecte.CARTABO: false,
	comu.Tipus_objecte.TRANSPORTADOR: false,
	comu.Tipus_objecte.COMPAS: false,
	comu.Tipus_objecte.LLAPIS: false,
};

# Variables per controlar la doble pulsació i el zoom_in/out en pantalles tàctils
var estem_descomptant := false;
var temps_per_descomptar: = 0.0;
var index_pulsacio := 0;
var ultima_posicio_arrastre = null;
var ultima_diferencia = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	# Per centrar la finestra
	var pantalla_tamany = OS.get_screen_size(-1);
	var finestra_tamany = OS.get_window_size();
	OS.set_window_position(pantalla_tamany * 0.5 - finestra_tamany * 0.5);

	var tamany_imatge_px = $carta.texture.get_size();
	var escala_vs_mm = Vector2(tamany_imatge_px.x / $carta.tamany_mm.x, tamany_imatge_px.y / $carta.tamany_mm.y);
	self.objectes = [$cartabo, $transportador, $llapis, $dibuixos, $compas];
	for objecte in objectes:
		objecte.assignar_factor_escala(escala_vs_mm);
		objecte.assignar_principal(self);
	
	$carta.assignar_objectes(objectes);
	
	$menu_carta.definir_versio(self.versio);
	$Label.text = "";
	
func _process(delta):
	if estem_descomptant:
		temps_per_descomptar -= delta;
		if temps_per_descomptar <= 0:
			estem_descomptant = false;

func _input(ev):
	if ev is InputEventMouseButton:
		var ev_ratoli := ev as InputEventMouseButton
		if ev_ratoli.pressed:
			match ev_ratoli.button_index:
				BUTTON_WHEEL_UP:
					zoom_in();
				BUTTON_WHEEL_DOWN:
					zoom_out();
		if ev_ratoli.button_index == 1 and ev_ratoli.doubleclick:
			parar_tot();
			
	if ev is InputEventScreenTouch:		
		var ev_tocar_pantalla := ev as InputEventScreenTouch;
		str(ev_tocar_pantalla.get_position()) + ";" + str(ev_tocar_pantalla.is_pressed());

		var esta_pressionat := ev_tocar_pantalla.pressed as bool;
		var _posicio := ev_tocar_pantalla.position as Vector2;
		if esta_pressionat and estem_descomptant and index_pulsacio != ev_tocar_pantalla.index:
#			# És una doble pulsació.
			parar_tot();
		elif esta_pressionat and not estem_descomptant:
			# Comencem a descomptar.
			temps_per_descomptar = 0.250; # s
			index_pulsacio = ev_tocar_pantalla.index;
			estem_descomptant = true;

	if ev is InputEventScreenDrag:
		var ev_arrastrar_pantalla := ev as InputEventScreenDrag;
#		$Label.text = "Position: " + str(ev_arrastrar_pantalla.index) + ";" + \
#			str(ev_arrastrar_pantalla.get_position()) + ";" + str(ev_arrastrar_pantalla.get_relative());
		if self.ultima_posicio_arrastre == null:
			ultima_posicio_arrastre = ev_arrastrar_pantalla.get_position();
			return;

#		$Label.text = "Position: " + str(ev_arrastrar_pantalla.index) + ";" + \
#			str(ev_arrastrar_pantalla.get_position()) + ";" + str(ev_arrastrar_pantalla.get_relative()) + ": 01";
		
		if ultima_posicio_arrastre + ev_arrastrar_pantalla.get_relative() == ev_arrastrar_pantalla.get_position():
			# És el mateix dit.
#			$Label.text = "Position: " + str(ev_arrastrar_pantalla.index) + ";" + \
#				str(ev_arrastrar_pantalla.get_position()) + ";" + str(ev_arrastrar_pantalla.get_relative()) + ": 02";
			ultima_posicio_arrastre = ev_arrastrar_pantalla.get_position();
			return;
		
#		$Label.text = "Position: " + str(ev_arrastrar_pantalla.index) + ";" + \
#			str(ev_arrastrar_pantalla.get_position()) + ";" + str(ev_arrastrar_pantalla.get_relative()) + ": 03";

		# No és el mateix dit...
		var diferencia = (ev_arrastrar_pantalla.get_position() - ultima_posicio_arrastre).length();
		ultima_posicio_arrastre = ev_arrastrar_pantalla.get_position();
#		$Label.text = "Position: " + str(ev_arrastrar_pantalla.index) + ";" + \
#			str(ev_arrastrar_pantalla.get_position()) + ";" + str(ev_arrastrar_pantalla.get_relative()) + ": 04";
		if self.ultima_diferencia == null:
			ultima_diferencia = diferencia;
#			$Label.text = "Position: " + str(ev_arrastrar_pantalla.index) + ";" + \
#				str(ev_arrastrar_pantalla.get_position()) + ";" + str(ev_arrastrar_pantalla.get_relative()) + ": 05";
			return;
		
#		$Label.text = "06";
		if diferencia > ultima_diferencia:
			zoom_in();
		else:
			zoom_out();
		ultima_diferencia = diferencia;
#		$Label.text = "Position: " + str(ev_arrastrar_pantalla.index) + ";" + \
#			str(ev_arrastrar_pantalla.get_position()) + ";" + str(ev_arrastrar_pantalla.get_relative()) + ";" + str(ultima_diferencia);
		
		
		

func parar_tot():
	print("Parar tot");
	comu.parar();
	$carta.parar();
	$transportador.parar();
	$compas.parar();
	$cartabo.parar();
	$llapis.parar()

func _on_menu_carta_option_pressed(id):
	match id:
		comu.Opcions_popup.MOSTRAR_COMPAS:
			$compas.actualitzar_posicio($carta.get_position());
			$compas.re_escalar($carta.rect_scale.x);
			$compas.visible = true;
			$compas/Collision_shape.disabled = false;
			$menu_carta.assignar_visibilitat(comu.Tipus_objecte.COMPAS, true);
			es_primer_cop_mostrat($compas, comu.Tipus_objecte.COMPAS);

		comu.Opcions_popup.AMAGAR_COMPAS:
			$compas.visible = false;
			$compas/Collision_shape.disabled = true;
			$compas.parar();
			$menu_carta.assignar_visibilitat(comu.Tipus_objecte.COMPAS, false);

		comu.Opcions_popup.MOURE_COMPAS:
			$compas.comencar_moure();

		comu.Opcions_popup.GIRAR_COMPAS:
			$compas.comencar_girar();

		comu.Opcions_popup.VOLTEJAR_COMPAS:
			$compas.voltejar();
			
		comu.Opcions_popup.AJUSTAR_COMPAS:
			ajustar_compas();
			
		comu.Opcions_popup.PINTAR_AMB_COMPAS:
			var centre = $compas.get_position();
			var radi = $compas.tamany_per_defecte.x * $compas.scale.x;
			$dibuixos.afegir_cercle(centre, radi, $carta);

		comu.Opcions_popup.MOSTRAR_TRANSPORTADOR:
			$transportador.actualitzar_posicio($carta.get_position());
			$transportador.re_escalar($carta.rect_scale.x);
			$transportador.visible = true;
			$transportador/Collision_shape.disabled = false;
			$menu_carta.assignar_visibilitat(comu.Tipus_objecte.TRANSPORTADOR, true);
			es_primer_cop_mostrat($transportador, comu.Tipus_objecte.TRANSPORTADOR);

		comu.Opcions_popup.AMAGAR_TRANSPORTADOR:
			$transportador.visible = false;
			$transportador/Collision_shape.disabled = true;
			$transportador.parar();
			$menu_carta.assignar_visibilitat(comu.Tipus_objecte.TRANSPORTADOR, false);

		comu.Opcions_popup.MOURE_TRANSPORTADOR:
			$transportador.comencar_moure();

		comu.Opcions_popup.GIRAR_TRANSPORTADOR:
			$transportador.comencar_girar();

		comu.Opcions_popup.VOLTEJAR_TRANSPORTADOR:
			$transportador.voltejar();

		comu.Opcions_popup.MOSTRAR_LLAPIS:
			$llapis.actualitzar_posicio($carta.get_position());
			$llapis.re_escalar($carta.rect_scale.x);
			$llapis.visible = true;
			$llapis/Collision_shape.disabled = false;
			$menu_carta.assignar_visibilitat(comu.Tipus_objecte.LLAPIS, true);
			es_primer_cop_mostrat($llapis, comu.Tipus_objecte.LLAPIS);

		comu.Opcions_popup.AMAGAR_LLAPIS:
			$llapis.visible = false;
			$llapis/Collision_shape.disabled = true;
			$llapis.parar();
			$menu_carta.assignar_visibilitat(comu.Tipus_objecte.LLAPIS, false);

		comu.Opcions_popup.MOURE_LLAPIS:
			$llapis.comencar_moure();

		comu.Opcions_popup.GIRAR_LLAPIS:
			$llapis.comencar_girar();

		comu.Opcions_popup.VOLTEJAR_LLAPIS:
			$llapis.voltejar();

		comu.Opcions_popup.PUNT_LLAPIS:
			var llapis_position = $llapis.get_position();
			$dibuixos.afegir_cercle(llapis_position, 0, $carta);
			$dibuixos.afegir_cercle(llapis_position, 1, $carta);
			$dibuixos.afegir_cercle(llapis_position, 2, $carta);
			$dibuixos.afegir_cercle(llapis_position, 6, $carta); # Per destacar la localització

		comu.Opcions_popup.LINIA_LLAPIS:
			var posicio = $llapis.obtenir_perpendicular_a_colisio()[0];
			var vector_direccio = $llapis.obtenir_perpendicular_a_colisio()[1];
			var nova_posicio = posicio + 10000 * vector_direccio;
			$dibuixos.afegir_linia(posicio, nova_posicio, $carta);
			nova_posicio = posicio - 10000 * vector_direccio;
			$dibuixos.afegir_linia(posicio, nova_posicio, $carta);

		comu.Opcions_popup.MOSTRAR_CARTABO:
			$cartabo.actualitzar_posicio($carta.get_position());
			$cartabo.re_escalar($carta.rect_scale.x);
			$cartabo.visible = true;
			$cartabo/Collision_shape.disabled = false;
			$menu_carta.assignar_visibilitat(comu.Tipus_objecte.CARTABO, true);
			es_primer_cop_mostrat($cartabo, comu.Tipus_objecte.CARTABO);

		comu.Opcions_popup.AMAGAR_CARTABO:
			$cartabo.visible = false;
			$cartabo/Collision_shape.disabled = true;
			$cartabo.parar();
			$menu_carta.assignar_visibilitat(comu.Tipus_objecte.CARTABO, false);

		comu.Opcions_popup.MOURE_CARTABO:
			$cartabo.comencar_moure();

		comu.Opcions_popup.GIRAR_CARTABO:
			$cartabo.comencar_girar();

		comu.Opcions_popup.VOLTEJAR_CARTABO:
			$cartabo.voltejar();

		comu.Opcions_popup.MOURE_CARTA:
			$carta.comencar_moure();

		comu.Opcions_popup.SORTIR_NO:
			#probar_funcions();
			pass;

		comu.Opcions_popup.SORTIR_SI:
			print("Nos vemos!!!");
			get_tree().quit();

		_:
			print("Opción no identificada en _on_popup_menu_id_pressed: " + str(id));
			
func zoom_in():
	$carta.zoom_in();
	
func zoom_out():
	$carta.zoom_out();
	
func es_primer_cop_mostrat(objecte, identificador_objecte):
	if not objectes_mostrats[identificador_objecte]:
		objecte.set_position(Vector2(0, 0));
		if identificador_objecte == comu.Tipus_objecte.COMPAS:
			objecte.set_position(Vector2(100, 100));
		objectes_mostrats[identificador_objecte] = true;
		
func ajustar_compas():
	$compas.comencar_a_ajustar();

func probar_funcions():
	$dibuixos.afegir_linia(Vector2(0,0), Vector2(500, 500));
	$dibuixos.afegir_cercle(Vector2(500,500), 30.5);
