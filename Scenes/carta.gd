extends TextureRect

export var tamany_mm: Vector2 = Vector2(602, 442);

var tamany: Vector2 = Vector2.ZERO;
var factor_escala: Vector2 = Vector2.ZERO;
var posicio_anterior_ratoli: Vector2 = Vector2.ZERO;
var comu = load("res://Scripts/comu.gd").new("Carta Nàutica");
var dibuixos = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	tamany = get_viewport_rect().size;
	print("Tamany: " + str(tamany));

func comencar_moure(p_dibuixos):
	dibuixos = p_dibuixos;
	comu.comencar_moure();

func parar():
	comu.parar();
	dibuixos = null;
	
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

	if dibuixos != null:
		dibuixos.actualitzar_posicio(posicio, get_position()); # ON ha d'anar i on es troba ara
	posicio_anterior_ratoli = posicio_ratoli;
	set_position(posicio);
	
func zoom_in(p_dibuixos):
	print("Position: " + str(get_position()) + ". " + str(rect_scale.x));
	self.rect_scale.x += 0.1;
	self.rect_scale.y += 0.1;	
	print("Position: " + str(get_position()) + ". " + str(rect_scale.x));
	p_dibuixos.re_escalar(get_position(), rect_scale.x);
	
func zoom_out(p_dibuixos):
	self.rect_scale.x -= 0.1;
	self.rect_scale.y -= 0.1;
	p_dibuixos.re_escalar(get_position(), rect_scale.x);