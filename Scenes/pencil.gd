extends Area2D

export var size_mm := Vector2(10, 10);

var common = load("res://Scripts/common.gd").new("Pencil");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if common.get_moving(): move_it();
	if common.get_turning(): turn_it();
	common.display(self);	

func _physics_process(_delta):
	return;
	if get_overlapping_areas().size() > 0 :
		print("Overlap pencil: " + str(get_overlapping_areas()));
	
func start_turning():
	common.start_turning();
	
func start_moving():
	get_viewport().warp_mouse(get_position() );
	common.start_moving(get_viewport().get_mouse_position());
	
func stop_it():
	common.stop_it();
	
func move_it():
	common.move_it(get_viewport().get_mouse_position()\
		, get_viewport_rect().size, \
		Vector2($Sprite.texture.get_size().x, $Sprite.texture.get_size().y));

func turn_it():
	common.turn_it(get_viewport().get_mouse_position());
	
func flip_it():	
	common.flip_it($Sprite)

func _on_pencil_area_entered(area):
	if not visible or not area.visible:
		return;
	print("Pencil Area entering: " + str(area.get_name()));
