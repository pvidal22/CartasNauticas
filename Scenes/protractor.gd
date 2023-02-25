extends Area2D

export var size_mm := Vector2(100, 100);

var common = load("res://Scripts/common.gd").new("Protractor");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if common.get_moving(): move_it();
	if common.get_turning(): turn_it();
	common.display(self);	
	
func start_turning():
	common.start_turning();
	
func start_moving():
	get_viewport().warp_mouse(get_position());
	common.start_moving(get_viewport().get_mouse_position());
	
func stop_it():
	common.stop_it();
	
func move_it():
	common.move_it(get_viewport().get_mouse_position()\
		, get_viewport_rect().size, \
		Vector2($Sprite.texture.get_size().x * $Sprite.scale.x\
			, $Sprite.texture.get_size().y * $Sprite.scale.y));

func turn_it():
	common.turn_it();
	
func flip_it():
	common.flip_it($TextureRect)
	
func set_scale_factor(chart_scale_factor: Vector2):
	var scale_factor: Vector2 = $Sprite.texture.get_size();
	scale_factor = Vector2(chart_scale_factor.x * size_mm.x / scale_factor.x \
		, chart_scale_factor.y * size_mm.y / scale_factor.y);
	scale = scale_factor;	
	
#func _input(ev: InputEvent):
#	if ev is InputEventMouseButton:
#		ev = ev as InputEventMouseButton;
#		if ev.button_index == 1 and ev.doubleclick:
#			stop_it();
