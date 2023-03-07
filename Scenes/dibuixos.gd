extends Area2D

var tipus := [];
var parametres1 := []; # Sempre respecte 0,0 i escala 1
var parametres2 := []; # Sempre respecte 0,0 i escala 1
var escala_carta: float = 1;
var posicio_carta = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func afegir_linia(comencament: Vector2, final: Vector2, carta):
	verificar_posicio_i_escala(carta);
	comencament = comencament - posicio_carta;
	comencament = comencament / escala_carta;
	final -= posicio_carta;
	final /= escala_carta;
	tipus.append("linia");
	parametres1.append(comencament);
	parametres2.append(final);
	update();
	
func afegir_cercle(centre: Vector2, radi: float, carta):
	verificar_posicio_i_escala(carta);
	centre = centre - posicio_carta; # Corregim posició
	centre = centre / escala_carta; # Corregim escala.

	tipus.append("cercle");
	parametres1.append(centre);
	parametres2.append(radi);
	update();

func verificar_posicio_i_escala(carta):
	if posicio_carta == null:
		posicio_carta = carta.get_position();
		escala_carta = carta.rect_scale.x;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass;

func _draw():
	for lii in range(0, len(tipus)):
		match tipus[lii].to_lower():
			"linia":
				dibuixar_linia(parametres1[lii], parametres2[lii]);
			"cercle":
				dibuixar_cercle(parametres1[lii], parametres2[lii]);
			_:
				print("No identificat: " + str(tipus[lii].to_lower()));
				
func dibuixar_linia(comencament: Vector2, final: Vector2):
	# Ajustant la nova posició
	comencament *= escala_carta;
	comencament += posicio_carta;
	final *= escala_carta;
	final += posicio_carta;
	draw_line(comencament, final, Color(0, 0, 0), 1);
	
func dibuixar_cercle(centre: Vector2, radi: float):	
	# Ajustant la nova posició.	
	centre = centre * self.escala_carta;
	centre = centre + self.posicio_carta;
	draw_arc(centre, radi, 0, 2*PI, 720, Color(0, 0, 0), 1);
	
func actualitzar_posicio(nova_posicio: Vector2):
	self.posicio_carta = nova_posicio;
	update();

func re_escalar(nova_escala: float):
	self.escala_carta = nova_escala;
	update();
