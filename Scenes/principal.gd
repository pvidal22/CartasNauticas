extends Node

var comu = load("res://Scripts/comu.gd").new("Principal");
var objectes = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	# Per centrar la imatge
	var pantalla_tamany = OS.get_screen_size(-1);
	var finestra_tamany = OS.get_window_size();
	OS.set_window_position(pantalla_tamany * 0.5 - finestra_tamany * 0.5);

	var tamany_imatge_px = $carta.texture.get_size();
	var escala_vs_mm = Vector2(tamany_imatge_px.x / $carta.tamany_mm.x, tamany_imatge_px.y / $carta.tamany_mm.y);
	$transportador.assignar_factor_escala(escala_vs_mm);
	$cartabo.assignar_factor_escala(escala_vs_mm);
	self.objectes = [$cartabo]; #, $transportador, $compas, $llapis, $dibuixos];
	$carta.assignar_objectes(objectes);

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
			print("Parar tot");
			comu.parar();
			$carta.parar();
			$transportador.parar();
#			$compas.parar();
			$cartabo.parar();
			$llapis.parar()
			
	if ev is InputEventScreenTouch:
		ev = ev as InputEventScreenTouch;
		print("Touch screen: " + str(ev.index) + "," + str(ev.pressed) + "," + str(ev.as_text()));
		#if ev.index == 2 and ev.pressed		

func _on_menu_carta_option_pressed(id):
	match id:
		comu.Opcions_popup.MOSTRAR_COMPAS:
			$compas.visible = true;
			$compas/Collision_shape.disabled = false;
			$menu_carta.assignar_visibilitat(comu.Tipus_objecte.COMPAS, true);

		comu.Opcions_popup.AMAGAR_COMPAS:
			$compas.visible = false;
			$compas/Collision_shape.disabled = true;
			$menu_carta.assignar_visibilitat(comu.Tipus_objecte.COMPAS, false);

		comu.Opcions_popup.MOSTRAR_TRANSPORTADOR:
			$transportador.visible = true;
			$transportador/Collision_shape.disabled = false;
			$menu_carta.assignar_visibilitat(comu.Tipus_objecte.TRANSPORTADOR, true);

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
			$llapis.visible = true;
			$llapis/Collision_shape.disabled = false;
			$menu_carta.assignar_visibilitat(comu.Tipus_objecte.LLAPIS, true);

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
	$carta.zoom_in(get_node("dibuixos"));
	
func zoom_out():
	$carta.zoom_out(get_node("dibuixos"));

func probar_funcions():
	$dibuixos.afegir_linia(Vector2(0,0), Vector2(500, 500));
	$dibuixos.afegir_cercle(Vector2(500,500), 30.5);
