extends Area2D

var tipus := [];
var parametres1 := [];
var parametres2 := [];

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func afegir_linia(comencament: Vector2, final: Vector2):
	tipus.append("linia");
	parametres1.append(comencament);
	parametres2.append(final);
	update();
	
func afegir_cercle(centre: Vector2, radi: float):
	tipus.append("cercle");
	parametres1.append(centre);
	parametres2.append(radi);
	update();

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
	draw_line(comencament, final, Color(0, 0, 0), 1);
	
func dibuixar_cercle(centre: Vector2, radi: float):
	draw_arc(centre, radi, 0, 2*PI, 720, Color(0, 0, 0), 1);
