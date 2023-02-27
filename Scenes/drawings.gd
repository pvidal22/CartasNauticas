extends Area2D

var types := [];
var params1 := [];
var params2 := [];

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_line(start: Vector2, end: Vector2):
	types.append("line");
	params1.append(start);
	params2.append(end);
	update();
	
func add_circle(center: Vector2, radius: float):
	types.append("circle");
	params1.append(center);
	params2.append(radius);
	update();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass;

func _draw():
	for lii in range(0, len(types)):
		match types[lii].to_lower():
			"line":
				drawing_line(params1[lii], params2[lii]);
			"circle":
				drawing_circle(params1[lii], params2[lii]);
			_:
				print("Not identified: " + str(types[lii].to_lower()));
				
func drawing_line(start: Vector2, end: Vector2):
	draw_line(start, end, Color(0, 0, 0), 1);
	
func drawing_circle(center: Vector2, radius: float):
	draw_arc(center, radius, 0, 2*PI, 720, Color(0, 0, 0), 1);
