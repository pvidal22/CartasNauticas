enum Opcions_popup {\
	MOURE_CARTA \
	, MOSTRAR_COMPAS, AMAGAR_COMPAS\
	, MOSTRAR_TRANSPORTADOR, AMAGAR_TRANSPORTADOR, MOURE_TRANSPORTADOR, GIRAR_TRANSPORTADOR, VOLTEJAR_TRANSPORTADOR\
	, MOSTRAR_LLAPIS, AMAGAR_LLAPIS, MOURE_LLAPIS, GIRAR_LLAPIS, VOLTEJAR_LLAPIS, PUNT_LLAPIS, LINIA_LLAPIS \
	, MOSTRAR_CARTABO, AMAGAR_CARTABO, MOURE_CARTABO, GIRAR_CARTABO, VOLTEJAR_CARTABO\
	, CANCELAR\
	, SORTIR_SI, SORTIR_NO};

enum Tipus_objecte {TRANSPORTADOR, COMPAS, LLAPIS, CARTABO};

var girant: bool = false;
var movent: bool = false;

var angle_rotacio = null;
var nom_objecte: String = "";
var posicio_voltejar := 0;
var velocitat_moviment = 500;
var escala_carta: float = 1;
var posicio_carta = null;
var posicio_actual := Vector2.ZERO; # Sempre respecte escala = 1 i posicio 0,0
var posicio_objectiu := Vector2.ZERO;
var objecte = null;

func _init(p_nom_objecte: String):
	self.nom_objecte = p_nom_objecte; 

func assignar_objecte(p_objecte):
	self.objecte = p_objecte;
	
func esta_movent() -> bool:
	return movent;

func esta_girant() -> bool:
	return girant;

func mostrar(delta) -> Array:
	if angle_rotacio != null:
		objecte.rotation_degrees = angle_rotacio;

	if esta_movent():
		return actualitzar_dibuix_objecte(delta);
		
	return [];
	
func actualitzar_dibuix_objecte(delta) -> Array:
		var posicio_actual_ajustat = posicio_actual + posicio_carta;
		var posicio_objectiu_ajustat = posicio_objectiu + posicio_carta;

		if delta == 0:
			objecte.set_position(posicio_objectiu_ajustat);
		
		#posicio_objectiu_ajustat.x = clamp(posicio_objectiu_ajustat.x, 0, tamany_canvas.x);
		#posicio_objectiu_ajustat.y = clamp(posicio_objectiu_ajustat.y, 0, tamany_canvas.y);

		var distancia = (posicio_objectiu_ajustat - posicio_actual_ajustat).length();	
		var local_velocitat_moviment = velocitat_moviment;
		if distancia < 10:
			local_velocitat_moviment = 10;
		var velocitat = obtenir_vector_moviment(posicio_objectiu_ajustat, posicio_actual_ajustat) * local_velocitat_moviment;
		var colissio = objecte.move_and_collide(velocitat * delta);
		if colissio: # Returnem la posició de la colisió i un vector perpendicular a la colisió
			return [Vector2(colissio.position), colissio.normal];
		
		return [];

func obtenir_vector_moviment(objectiu: Vector2, actual: Vector2) -> Vector2:
	if objectiu == actual:
		return Vector2.ZERO;
	
	return actual.direction_to(objectiu);
	
func comencar_girar():
	girant = true;
	movent = false;
	
func comencar_moure():
	girant = false;
	movent = true;
	
func parar():
	girant = false;
	movent = false;
	print(str(OS.get_time()) + ". Parar " + nom_objecte);

func moure(p_posicio_actual: Vector2, p_posicio_objectiu: Vector2):
	# Traduim a escala 1 i posicio 0,0
	if posicio_carta != null:
		posicio_actual = p_posicio_actual - self.posicio_carta;
		posicio_objectiu = p_posicio_objectiu - self.posicio_carta;

func girar(p_posicio_actual: Vector2, p_posicio_ratoli: Vector2):
	var angle = ( p_posicio_ratoli - p_posicio_actual).angle();
	angle = rad2deg(angle); # Per passar radians a graus
	angle_rotacio = angle + 90;
	# Cas específic pel cartabó per a fer-ho més intuitiu.
	if self.nom_objecte.to_lower() == "cartabo":
		angle_rotacio -= 90;
	
func voltejar(item):
	self.posicio_voltejar += 1;
	self.posicio_voltejar = posicio_voltejar % 4;
	match posicio_voltejar:
		0:
			item.flip_h = false;
			item.flip_v = false;
		1:
			item.flip_h = true;
			item.flip_v = false;
		2:
			item.flip_h = true;
			item.flip_v = true;
		3:
			item.flip_h = false;
			item.flip_v = true;

func actualitzar_posicio(nova_posicio: Vector2):
	self.posicio_carta = nova_posicio;
	actualitzar_dibuix_objecte(0);

func re_escalar(nova_escala: float):
	var increment = 0.2;
	if nova_escala < escala_carta:
		increment *= -1;
	objecte.scale.x += increment;
	objecte.scale.y += increment;
	self.escala_carta = nova_escala;

func _input(ev: InputEvent):
	if ev is InputEventMouseButton:
		ev = ev as InputEventMouseButton;
		if ev.button_index == 1 and ev.doubleclick:
			parar();
