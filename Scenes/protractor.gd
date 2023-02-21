extends Area2D

export var width_mm: int = 100;
export var height_mm: int = 100;
export var speed_x: int = 10;
export var speed_y: int = 10;

var common = load("res://school_items.gd").new("Protractor");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if common.get_moving(): move_it();
	if common.get_turning(): turn_it();
	common.display(self);	
	
func start_turning():
	common.start_turning();
	
func start_moving():	
	get_viewport().warp_mouse(get_position() + $TextureRect.get_size() / 2);
	common.start_moving(get_viewport().get_mouse_position());
	print("Mouse position:  " + str(get_viewport().get_mouse_position()));
	
func stop_it():
	common.stop_it();
	
func move_it():
	common.move_it(get_viewport().get_mouse_position()\
		, get_viewport_rect().size, $TextureRect.get_size());

func turn_it():
	common.turn_it();
	
func flip_it():
	common.flip_it($TextureRect)
	
#func _input(ev: InputEvent):
#	if ev is InputEventMouseButton:
#		ev = ev as InputEventMouseButton;
#		if ev.button_index == 1 and ev.doubleclick:
#			stop_it();
