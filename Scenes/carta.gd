extends TextureRect

export var size_mm: Vector2 = Vector2(602, 442);

var size: Vector2 = Vector2.ZERO;
var scale_factor: Vector2 = Vector2.ZERO;
var previous_mouse_position: Vector2 = Vector2.ZERO;
var common = load("res://Scripts/common.gd").new("Nautical Chart");

# Called when the node enters the scene tree for the first time.
func _ready():
	size = get_viewport_rect().size;
	print("Size: " + str(size));


func start_moving():
	#common.start_moving(get_viewport().get_mouse_position());
	common.start_moving();

func stop_it():
	common.stop_it();
	
func _process(_delta):
	if common.get_moving(): move_it();
	
func move_it():
	var mouse_position := get_viewport().get_mouse_position();	
	var canvas := get_viewport_rect().size;
	var this_position = get_position();
	
	var difference := mouse_position - previous_mouse_position;
	if difference.length() <= 10:
		this_position += difference;
	
	# Clamping it.
	if this_position.x > 0: this_position.x = 0;
	if this_position.x + get_size().x < canvas.x: this_position.x = canvas.x - get_size().x;
	if this_position.y > 0: this_position.y = 0;
	if this_position.y + get_size().y < canvas.y: this_position.y = canvas.y - get_size().y;

	previous_mouse_position = mouse_position;
	set_position(this_position);
