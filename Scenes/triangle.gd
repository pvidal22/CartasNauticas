extends KinematicBody2D

export var size_mm := Vector2(250, 150);

var common = load("res://Scripts/common.gd").new("Triangle");

# Called when the node enters the scene tree for the first time.
func _ready():
	$Collision_shape.disabled = true;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if common.get_moving(): move_it();
	if common.get_turning(): turn_it();
	common.display(self, delta);	
	
func start_turning():
	common.start_turning();
	
func start_moving():
	get_viewport().warp_mouse(get_position());
	common.start_moving();
	
func stop_it():
	common.stop_it();
	
func move_it():
	common.move_it(get_position(), get_viewport().get_mouse_position()\
		, get_viewport_rect().size);

func turn_it():
	common.turn_it(get_position(), get_viewport().get_mouse_position());
	
func flip_it():
	common.flip_it($Sprite);
	
func set_scale_factor(chart_scale_factor: Vector2):
	var scale_factor: Vector2 = $Sprite.texture.get_size();
	scale_factor = Vector2(chart_scale_factor.x * size_mm.x / scale_factor.x \
		, chart_scale_factor.y * size_mm.y / scale_factor.y);
	scale = scale_factor;	
