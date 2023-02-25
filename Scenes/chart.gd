extends TextureRect

export var size_mm: Vector2 = Vector2(602, 442);

var size: Vector2 = Vector2.ZERO;
var scale_factor: Vector2 = Vector2.ZERO;
var common = load("res://Scripts/common.gd").new("Nautical Chart");

# Called when the node enters the scene tree for the first time.
func _ready():
	size = get_viewport_rect().size;
	print("Size: " + str(size));

	scale_factor = get_size();
	scale_factor = Vector2(scale_factor.x / size_mm.x, scale_factor.y / size_mm.y);

func move_chart():
	common.start_moving(get_viewport().get_mouse_position());
	
func _process(delta):
	if common.get_moving(): move_it();
	
func move_it():
	var mouse_position := get_viewport().get_mouse_position();	
	var canvas := get_viewport_rect().size;
	var texture = $TextureRect.get_size();
	var this_position = $TextureRect.get_position();
		
	# Clamping it.
	if this_position.x > 0: this_position.x = 0;
	if this_position.x + texture.x < canvas.x: this_position.x = canvas.x - texture.x;
	if this_position.y > 0: this_position.y = 0;
	if this_position.y + texture.y < canvas.y: this_position.y = canvas.y - texture.y;

	$TextureRect.set_position(this_position);
