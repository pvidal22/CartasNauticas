enum Popup_options {\
	MOUSE_CARTA \
	, MOSTRAR_COMPAS, AMAGAR_COMPAS\
	, MOSTRAR_TRANSPORTADOR, AMAGAR_TRANSPORTADOR, MOURE_TRANSPORTADOR, GIRAR_TRANSPORTADOR, VOLTEJAR_TRANSPORTADOR\
	, MOSTRAR_LLAPIS, AMAGAR_LLAPIS, MOURE_LLAPIS, GIRAR_LLAPIS, VOLTEJAR_LLAPIS, PUNT_LLAPIS, LINIA_LLAPIS \
	, MOSTRAR_CARTABO, AMAGAR_CARTABO, MOURE_CARTABO, GIRAR_CARTABO, VOLTEJAR_CARTABO\
	, CANCELAR\
	, SORTIR_SI, SORTIR_NO};

enum Item_types {TRANSPORTADOR, COMPAS, LLAPIS, CARTABO};

var girant: bool = false;
var movent: bool = false;
var posicio_objectiu: Vector2 = Vector2.ZERO;
var vector_moviment: Vector2 = Vector2.ZERO;
var angle_rotacio = null;
var nom_objecte: String = "";
var posicio_voltejar := 0;
var velocitat_moviment = 500;

func _init(p_nom_objecte: String):
	self.nom_objecte = p_nom_objecte; 
	
func esta_movent() -> bool:
	return movent;

func esta_girant() -> bool:
	return girant;

func mostrar(objecte, delta) -> Array:
	if angle_rotacio != null:
		objecte.rotation_degrees = angle_rotacio;
	if esta_movent():
		var distancia = posicio_objectiu - objecte.get_position();
		distancia = distancia.length();
		var aqui_velocitat_moviment = velocitat_moviment;
		if distancia < 10:
			aqui_velocitat_moviment = 10;
		var velocitat = obtenir_vector_moviment() * aqui_velocitat_moviment;
		var colisio = objecte.move_and_collide(velocitat * delta);
		if colisio:
			return [Vector2(colisio.position), colisio.normal]; # Returnem la posició de la colisió i un vector perpendicular a la colisió
			
	return [];

func obtenir_vector_moviment() -> Vector2:
	return self.vector_moviment;
	
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

func moure(p_posicio_actual: Vector2, p_posicio_objectiu: Vector2, tamany_canvas: Vector2):
	p_posicio_objectiu.x = clamp(p_posicio_objectiu.x, 0, tamany_canvas.x);
	p_posicio_objectiu.y = clamp(p_posicio_objectiu.y, 0, tamany_canvas.y);
	if p_posicio_objectiu == p_posicio_actual:
		vector_moviment = Vector2.ZERO;
	else:
		vector_moviment = p_posicio_actual.direction_to(p_posicio_objectiu); # (target-current).normalized()
	posicio_objectiu = p_posicio_objectiu;

func girar(p_posicio_actual: Vector2, p_posicio_ratoli: Vector2):
	var angle = ( p_posicio_ratoli - p_posicio_actual).angle();
	angle = rad2deg(angle); # Per passar radians a graus
	angle_rotacio = angle + 90;
	
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

func _input(ev: InputEvent):
	if ev is InputEventMouseButton:
		ev = ev as InputEventMouseButton;
		if ev.button_index == 1 and ev.doubleclick:
			parar();
