extends TextureRect

export var width_mm: int = 100;
export var height_mm: int = 100;
export var speed_x: int = 10;
export var speed_y: int = 10;

var turning: bool = false;
var moving: bool = false;
var previous_mouse_position: Vector2 = Vector2.ZERO;
var latest_position: Vector2 = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving: move_it();
	if turning: turn_it();
	
	self.set_position(latest_position);		
	
func start_turning():
	turning = true;
	moving = false;
	
func start_moving():
	turning = false;
	moving = true;
	
func stop_it():
	turning = false;
	moving = false;
	
func move_it():
	var position = get_viewport().get_mouse_position();	
	position.x = clamp(position.x, 0, get_viewport_rect().size.x - self.texture.get_size().x);
	position.y = clamp(position.y, 0, get_viewport_rect().size.y - self.texture.get_size().y);
	self.latest_position = position;

func turn_it():
	print(str(OS.get_time()) + ". Turn it");
	
func flip_it():
	self.flip_v = not self.flip_v;
	self.flip_h = not self.flip_h;
	
func _input(event: InputEvent):
	Trying to make teh doubleclick work
	if event == InputEvent.MOUSE_TYPE:
		print("double")
