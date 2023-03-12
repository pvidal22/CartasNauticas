extends KinematicBody2D

export var tamany_mm := Vector2(10, 10);

var comu = load("res://Scripts/comu.gd").new("Llapis");
var perpendicular_a_ultima_colisio: Vector2 = Vector2.ZERO;
var principal = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Collision_shape.disabled = true;
	comu.assignar_objecte(self);
	
func assignar_principal(p_principal):
	principal = p_principal;

func _physics_process(delta):
	if principal != null and principal.estem_descomptant: return;
	if comu.esta_movent(): moure();
	if comu.esta_girant(): girar();
	var resultat: Array = comu.mostrar(delta);
	if not resultat.empty():
		perpendicular_a_ultima_colisio = resultat[1]
		perpendicular_a_ultima_colisio = Vector2(-perpendicular_a_ultima_colisio.y, perpendicular_a_ultima_colisio.x);
	
func comencar_girar():
	comu.comencar_girar();
	
func comencar_moure():
	get_viewport().warp_mouse(get_position() );
	comu.comencar_moure();
	
func parar():
	comu.parar();
	
func moure():
	comu.moure(get_viewport().get_mouse_position());

func girar():
	comu.girar(get_viewport().get_mouse_position());
	
func voltejar():
	comu.voltejar($Sprite)

func actualitzar_posicio(nova_posicio: Vector2):
	comu.actualitzar_posicio(nova_posicio);

func re_escalar(nova_escala: float):
	comu.re_escalar(nova_escala);		
	
func assignar_factor_escala(_p_px_vs_mm: Vector2):	
	var factor_escala = Vector2(1.0, 1.0);
	scale = factor_escala;
	comu.assignar_escala_basica(factor_escala);

func obtenir_perpendicular_a_colisio() -> Array:
	print("get_pend" + str(self.perpendicular_a_ultima_colisio));
	return [get_position(), self.perpendicular_a_ultima_colisio];
