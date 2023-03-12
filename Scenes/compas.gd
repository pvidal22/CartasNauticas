extends KinematicBody2D

var comu = load("res://Scripts/comu.gd").new("Compas");
var tamany_per_defecte = Vector2.ZERO; # Amb escala 1.1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Collision_shape.disabled = true;
	comu.assignar_objecte(self);
	tamany_per_defecte = $Sprite.texture.get_size();
	tamany_per_defecte.x = tamany_per_defecte.x - 10; # Per compensar la diferència entre la punta del compàs i el marge esquerre de la imatge
	print("Tamany_compass: " + str(tamany_per_defecte));

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if comu.esta_movent(): moure();
	if comu.esta_girant(): girar();
	if comu.esta_ajustant(): ajustar();
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

func ajustar():
	comu.ajustar(get_viewport().get_mouse_position(), self.tamany_per_defecte);

func girar():
	comu.girar(get_viewport().get_mouse_position());
	
func voltejar():
	comu.voltejar($Sprite)

func actualitzar_posicio(nova_posicio: Vector2):
	comu.actualitzar_posicio(nova_posicio);

func re_escalar(nova_escala: float):
#	self.escala_carta = nova_escala;
#	scale = Vector2(1,1) * scale * nova_escala;
#	comu.actualitzar_dibuix_objecte(0);
#
#	comu.escala_carta = nova_escala;
	comu.re_escalar(nova_escala);
	
func assignar_factor_escala(_p_px_vs_mm: Vector2):
	var factor_escala = Vector2(1.0, 1.0);
	scale = factor_escala;
	comu.assignar_escala_basica(factor_escala);

func comencar_a_ajustar():
	comu.comencar_a_ajustar();
