extends KinematicBody2D

export var tamany_mm := Vector2(250, 150);

var comu = load("res://Scripts/comu.gd").new("Cartabo");

# Called when the node enters the scene tree for the first time.
func _ready():
	$Collision_shape.disabled = true;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if comu.esta_movent(): moure();
	if comu.esta_girant(): girar();
	comu.mostrar(self, delta);	
	
func comencar_girar():
	comu.comencar_girar();
	
func comencar_moure():
	get_viewport().warp_mouse(get_position());
	comu.comencar_moure();
	
func parar():
	comu.parar();
	
func moure():
	comu.moure(get_position(), get_viewport().get_mouse_position()\
		, get_viewport_rect().size);

func girar():
	comu.girar(get_position(), get_viewport().get_mouse_position());
	
func voltejar():
	comu.voltejar($Sprite);
	
func assignar_factor_escala(p_factor_escala: Vector2):
	var factor_escala: Vector2 = $Sprite.texture.get_size();
	factor_escala = Vector2(p_factor_escala.x * tamany_mm.x / factor_escala.x \
		, p_factor_escala.y * tamany_mm.y / factor_escala.y);
	scale = factor_escala;
