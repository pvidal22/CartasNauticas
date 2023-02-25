
var turning: bool = false;
var moving: bool = false;
var previous_mouse_position: Vector2 = Vector2.ZERO;
var latest_position: Vector2 = Vector2.ZERO;
var item_name: String = "";
var flip_position := 0;

func _init(p_item_name: String):
	self.item_name = p_item_name; 
	
func get_moving() -> bool:
	return moving;

func get_turning() -> bool:
	return turning;

func display(item):
	item.set_position(latest_position);
	
func start_turning():
	turning = true;
	moving = false;
	
func start_moving(initial_position):
	turning = false;
	moving = true;
	latest_position = initial_position;
	
func stop_it():
	turning = false;
	moving = false;
	print(str(OS.get_time()) + ". Stop " + item_name);

func move_it(current_position, canvas_size, item_size):
	var position := \
		Vector2(current_position.x - item_size.x / 2, current_position.y - item_size.y / 2)
	
	position.x = clamp(position.x, 0, canvas_size.x - item_size.x);
	position.y = clamp(position.y, 0, canvas_size.y - item_size.y);
	self.latest_position = position;

func turn_it():
	print(str(OS.get_time()) + ". Turn it");
	
func flip_it(item):
	self.flip_position += 1;
	self.flip_position = flip_position % 4;
	match flip_position:
		0:
			item.flip_h = false;
			item.flip_v = false;
		1:
			item.flip_h = true;
			item.flip_v = false;
		2:
			item.flip_h = true;
			item.flip_v = true;
		3:
			item.flip_h = false;
			item.flip_v = true;
	
func _input(ev: InputEvent):
	if ev is InputEventMouseButton:
		ev = ev as InputEventMouseButton;
		if ev.button_index == 1 and ev.doubleclick:
			stop_it();
