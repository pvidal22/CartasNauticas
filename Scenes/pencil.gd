extends KinematicBody2D

export var size_mm := Vector2(10, 10);

var common = load("res://Scripts/common.gd").new("Pencil");

# Called when the node enters the scene tree for the first time.
func _ready():
	$Collision_shape.disabled = true;
	
func _physics_process(_delta):
	if common.get_moving(): move_it();
	if common.get_turning(): turn_it();
	common.display(self);

func start_turning():
	common.start_turning();
	
func start_moving():
	get_viewport().warp_mouse(get_position() );
	common.start_moving();
	
func stop_it():
	common.stop_it();
	
func move_it():
	common.move_it(get_position(), get_viewport().get_mouse_position()\
		, get_viewport_rect().size);

func turn_it():
	common.turn_it(get_position(), get_viewport().get_mouse_position());
	
func flip_it():	
	common.flip_it($Sprite)
