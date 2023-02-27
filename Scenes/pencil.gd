extends KinematicBody2D

export var size_mm := Vector2(10, 10);

var common = load("res://Scripts/common.gd").new("Pencil");
var normal_to_latest_collision: Vector2 = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Collision_shape.disabled = true;
	
func _physics_process(delta):
	if common.get_moving(): move_it();
	if common.get_turning(): turn_it();
	var result: Array = common.display(self, delta);
	if not result.empty():
		normal_to_latest_collision = result[1]
		normal_to_latest_collision = Vector2(-normal_to_latest_collision.y, normal_to_latest_collision.x);
	
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
	
func get_line_normal_to_collision() -> Array:
	return [get_position(), self.normal_to_latest_collision];
