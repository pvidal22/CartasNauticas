extends Area2D

var tipus := [];
var parametres_originals1 := [];
var parametres_originals2 := [];
var parametres_dibuix1 := [];
var parametres_dibuix2 := [];

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func afegir_linia(comencament: Vector2, final: Vector2):
	tipus.append("linia");
	parametres_originals1.append(comencament);
	parametres_originals2.append(final);
	parametres_dibuix1.append(comencament);
	parametres_dibuix2.append(final);
	update();
	
func afegir_cercle(centre: Vector2, radi: float):
	tipus.append("cercle");
	parametres_originals1.append(centre);
	parametres_originals2.append(radi);
	parametres_dibuix1.append(centre);
	parametres_dibuix2.append(radi);
	update();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass;

func _draw():
	for lii in range(0, len(tipus)):
		match tipus[lii].to_lower():
			"linia":
				dibuixar_linia(parametres_dibuix1[lii], parametres_dibuix2[lii]);
			"cercle":
				dibuixar_cercle(parametres_dibuix1[lii], parametres_dibuix2[lii]);
			_:
				print("No identificat: " + str(tipus[lii].to_lower()));
				
func dibuixar_linia(comencament: Vector2, final: Vector2):
	draw_line(comencament, final, Color(0, 0, 0), 1);
	
func dibuixar_cercle(centre: Vector2, radi: float):
	print("centre cercle: " + str(centre));
	draw_arc(centre, radi, 0, 2*PI, 720, Color(0, 0, 0), 1);
	
func actualitzar_posicio(nova_posicio: Vector2, posicio_antiga: Vector2):
	var diferencia = nova_posicio - posicio_antiga;
	for lii in range(0, len(tipus)):
		match tipus[lii].to_lower():
			"linia":
				parametres_originals1[lii] += diferencia;
				parametres_originals2[lii] += diferencia;
				
			"cercle":
				parametres_originals1[lii] += diferencia; # Només s'actualitzarà el centre del punt.
				parametres_dibuix1[lii] += diferencia; # Només s'actualitzarà el centre del punt.
			_:
				print("No identificat " + str(tipus[lii].to_lower()));
	update();

func re_escalar(posicio_de_carta: Vector2, nova_escala: float):
	for lii in range(0, len(tipus)):
		match tipus[lii].to_lower():
			"linia":
				pass;
				#parametres1[lii] += diferencia_escala;
				#parametres2[lii] += diferencia_escala;
			"cercle":
				parametres_dibuix1[lii] = parametres_originals1[lii] + Vector2(abs(posicio_de_carta.x), abs(posicio_de_carta.y));
				parametres_dibuix1[lii] *= nova_escala;
				parametres_dibuix1[lii] += Vector2(posicio_de_carta.x, posicio_de_carta.y);
			_:
				print("No identificat " + str(tipus[lii].to_lower()));
	update();
