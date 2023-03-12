extends KinematicBody2D

export var tamany_mm := Vector2(250, 150);

var comu = load("res://Scripts/comu.gd").new("Cartabo");
var principal = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Collision_shape.disabled = true;
	comu.assignar_objecte(self);

func assignar_principal(p_principal):
	principal = p_principal;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if principal != null and principal.estem_descomptant: return;
	if comu.esta_movent(): moure();
	if comu.esta_girant(): girar();
	comu.mostrar(delta);
	
func comencar_girar():
	comu.comencar_girar();
	
func comencar_moure():
	get_viewport().warp_mouse(get_position());
	comu.comencar_moure();
	
func parar():
	comu.parar();
	
func moure():
	comu.moure(get_viewport().get_mouse_position());

func girar():
	comu.girar(get_viewport().get_mouse_position());
	
func voltejar():
	comu.voltejar($Sprite);
	
func actualitzar_posicio(nova_posicio: Vector2):
	comu.actualitzar_posicio(nova_posicio);

func re_escalar(nova_escala: float):
	comu.re_escalar(nova_escala);	
	
func assignar_factor_escala(p_px_vs_mm: Vector2):
	var tamany_imatge: Vector2 = $Sprite.texture.get_size();
	var factor_escala = Vector2(\
		p_px_vs_mm.x * tamany_mm.x / tamany_imatge.x \
		, p_px_vs_mm.y * tamany_mm.y / tamany_imatge.y);
	scale = factor_escala;
	comu.assignar_escala_basica(factor_escala);
