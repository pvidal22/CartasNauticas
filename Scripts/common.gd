enum Popup_options {\
	MOVE_CHART \
	, SHOW_COMPASS, HIDE_COMPASS\
	, SHOW_PROTRACTOR, HIDE_PROTRACTOR, MOVE_PROTRACTOR, TURN_PROTRACTOR, FLIP_PROTRACTOR\
	, SHOW_PENCIL, HIDE_PENCIL, MOVE_PENCIL, TURN_PENCIL, FLIP_PENCIL \
	, SHOW_TRIANGLE, HIDE_TRIANGLE\
	, CANCEL\
	, QUIT_YES, QUIT_NO};

enum Item_types {PROTRACTOR, COMPASS, PENCIL, TRIANGLE};

var turning: bool = false;
var moving: bool = false;
var item_target_position: Vector2 = Vector2.ZERO;
var movement_vector: Vector2 = Vector2.ZERO;
var angle_rotation = null;
var item_name: String = "";
var flip_position := 0;
var movement_speed = 500;

func _init(p_item_name: String):
	self.item_name = p_item_name; 
	
func get_moving() -> bool:
	return moving;

func get_turning() -> bool:
	return turning;

func display(item):
	if angle_rotation != null:
		item.rotation_degrees = angle_rotation;
	if get_moving():
		var distance = item_target_position - item.get_position();
		distance = distance.length();
		var this_movement_speed = movement_speed;
		if distance < 10:
			this_movement_speed = 10;
		var v = get_movement_vector() * this_movement_speed;
		item.move_and_slide(v)

func get_movement_vector() -> Vector2:
	return self.movement_vector;
	
func start_turning():
	turning = true;
	moving = false;
	
func start_moving():
	turning = false;
	moving = true;	
	
func stop_it():
	turning = false;
	moving = false;
	print(str(OS.get_time()) + ". Stop " + item_name);

func move_it(current_position: Vector2, target_position: Vector2, canvas_size: Vector2):
	target_position.x = clamp(target_position.x, 0, canvas_size.x);
	target_position.y = clamp(target_position.y, 0, canvas_size.y);
	if target_position == current_position:		
		movement_vector = Vector2.ZERO;
	else:
		movement_vector = current_position.direction_to(target_position); # (target-current).normalized()		
	item_target_position = target_position;

func turn_it(current_position, mouse_position: Vector2):
	var angle = (mouse_position - current_position).angle();#	var shift := mouse_position - previous_mouse_position;
	angle = rad2deg(angle);
	angle_rotation = angle + 90;
	
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
