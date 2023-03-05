extends KinematicBody2D

export var tamany_mm := Vector2(10, 10);

var comu = load("res://Scripts/comu.gd").new("Llapis");
var perpendicular_a_ultima_colisio: Vector2 = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Collision_shape.disabled = true;
	
func _physics_process(delta):
	if comu.esta_movent(): moure();
	if comu.esta_girant(): girar();
	var resultat: Array = comu.mostrar(self, delta);
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
	comu.moure(get_position(), get_viewport().get_mouse_position()\
		, get_viewport_rect().size);

func girar():
	comu.girar(get_position(), get_viewport().get_mouse_position());
	
func voltejar():	
	comu.flip_it($Sprite)
	
func obtenir_perpendicular_a_colisio() -> Array:
	return [get_position(), self.perpendicular_a_ultima_colisio];
