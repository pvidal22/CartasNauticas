extends ScrollContainer

export var width_mm: int = 602;
export var height_mm: int = 442;

var size: Vector2 = Vector2(0,0); 

# Called when the node enters the scene tree for the first time.
func _ready():
	size = get_viewport_rect().size;
	print("Size: " + str(size));

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
