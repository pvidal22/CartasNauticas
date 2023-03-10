extends TextureRect

export var tamany_mm: Vector2 = Vector2(602, 442);

var tamany: Vector2 = Vector2.ZERO;
var factor_escala: Vector2 = Vector2.ZERO;
var posicio_anterior_ratoli: Vector2 = Vector2.ZERO;
var comu = load("res://Scripts/comu.gd").new("Carta Nàutica");
var objectes = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	tamany = get_viewport_rect().size;
	print("Tamany: " + str(tamany));
	get_tree().get_root().connect("size_changed", self, "canvi_tamany_finestra");

func canvi_tamany_finestra():
	#print("Resizing: " + str(get_viewport_rect().size) + ". Position: " + str(get_position()));
	var posicio = get_position();
	if objectes != null:
		for objecte in objectes:
			objecte.actualitzar_posicio(posicio);
	
	
func assignar_objectes(p_objectes: Array):
	self.objectes = p_objectes;

func comencar_moure():
	comu.comencar_moure();

func parar():
	comu.parar();
	
func _process(_delta):
	if comu.esta_movent(): moure();
	
func moure():
	var posicio_ratoli := get_viewport().get_mouse_position();
	var canvas := get_viewport_rect().size;
	var posicio = get_position();
	
	var diferencia := posicio_ratoli - posicio_anterior_ratoli;
	if diferencia.length() <= 10:
		posicio += diferencia;
	
	# Clamping it.	
	if posicio.x > 0: posicio.x = 0;
	if posicio.x + (get_size().x * rect_scale.x) < canvas.x: posicio.x = canvas.x - (get_size().x * rect_scale.x);
	if posicio.y > 0: posicio.y = 0;
	if posicio.y + (get_size().y * rect_scale.y) < canvas.y: posicio.y = canvas.y - (get_size().y * rect_scale.y);

	posicio_anterior_ratoli = posicio_ratoli;
	set_position(posicio);
	if objectes != null:
		for objecte in objectes:
			objecte.actualitzar_posicio(posicio);
	
func zoom_in():
	self.rect_scale.x += 0.01;
	self.rect_scale.y += 0.01;
	if objectes != null:
		for objecte in objectes:
			objecte.re_escalar(rect_scale.x);
	
func zoom_out():
	self.rect_scale.x -= 0.01;
	self.rect_scale.y -= 0.01;
	if objectes != null:
		for objecte in objectes:
			objecte.re_escalar(rect_scale.x);
