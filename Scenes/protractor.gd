extends Area2D

export var size_mm := Vector2(100, 100);

var common = load("res://Scripts/common.gd").new("Protractor");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;
	
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
		, get_viewport_rect().size, \
		Vector2($TextureRect.get_size().x * $TextureRect.rect_scale.x, $TextureRect.get_size().y * $TextureRect.rect_scale.y));

func turn_it():
	common.turn_it();
	
func flip_it():
	common.flip_it($TextureRect)
	
func set_scale_factor(canvas_scale_factor: Vector2):
	var scale_factor: Vector2 = $TextureRect.get_size();
	scale_factor = Vector2(scale_factor.x / size_mm.x, scale_factor.y / size_mm.y);
	print("Factors:  " + str(canvas_scale_factor) + ";" + str(scale_factor));
#	self.scale.x = canvas_scale_factor.x / scale_factor.x;
#	self.scale.y = canvas_scale_factor.y / scale_factor.y;

	$TextureRect.rect_scale.x = canvas_scale_factor.x / scale_factor.x;
	$TextureRect.rect_scale.y = canvas_scale_factor.y / scale_factor.y;
	
#func _input(ev: InputEvent):
#	if ev is InputEventMouseButton:
#		ev = ev as InputEventMouseButton;
#		if ev.button_index == 1 and ev.doubleclick:
#			stop_it();
