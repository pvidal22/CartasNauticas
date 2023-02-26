enum Popup_options {\
	MOVE_CHART \
	, SHOW_COMPASS, HIDE_COMPASS\
	, SHOW_PROTRACTOR, HIDE_PROTRACTOR, MOVE_PROTRACTOR, TURN_PROTRACTOR, FLIP_PROTRACTOR\
	, SHOW_PENCIL, HIDE_PENCIL, MOVE_PENCIL, TURN_PENCIL, FLIP_PENCIL \
	, SHOW_TRIANGLE, HIDE_TRIANGLE\
	, CANCEL\
	, QUIT_YES, QUIT_NO};

enum Item_types {PROTRACTOR, COMPASS, PENCIL, TRIANGLE};
enum Rotation {CLOCK, COUNTER_CLOCK};
enum Quadrant {ONE, TWO, THREE, FOUR}; # Clockwise from 0 to 360.

var turning: bool = false;
var moving: bool = false;
var previous_mouse_position: Vector2 = Vector2.ZERO;
var latest_position: Vector2 = Vector2.ZERO;
var angle_rotation := 0;
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
	item.rotation_degrees = angle_rotation;
	
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

func move_it(current_position, canvas_size, _item_size: Vector2 = Vector2.ZERO):
	var position := \
		Vector2(current_position.x, current_position.y)
	
	position.x = clamp(position.x, 0, canvas_size.x);
	position.y = clamp(position.y, 0, canvas_size.y);
	self.latest_position = position;

func turn_it(mouse_position: Vector2):
	var shift := mouse_position - previous_mouse_position;
	if shift == Vector2.ZERO:
		return;

	var quadrant = mouse_position - latest_position;
	if quadrant.x == 0 or quadrant.y == 0:
		return;

	if quadrant.x > 0 and quadrant.y < 0:
		quadrant = Quadrant.ONE;
	elif quadrant.x > 0 and quadrant.y > 0:
		quadrant = Quadrant.TWO;
	elif quadrant.x < 0 and quadrant.y > 0:
		quadrant = Quadrant.THREE;
	elif quadrant.x < 0 and quadrant.y < 0:
		quadrant = Quadrant.FOUR;
		
	var rotation = Rotation.COUNTER_CLOCK;
	if quadrant == Quadrant.ONE:
		if shift.x == 0:
			if shift.y > 0:
				rotation = Rotation.CLOCK;
		elif shift.x > 0 and shift.y > 0:
			rotation = Rotation.CLOCK;
		elif shift.y == 0:
			if shift.x > 0:
				rotation = Rotation.CLOCK;

	if quadrant == Quadrant.TWO:
		if shift.x == 0:
			if shift.y > 0:
				rotation = Rotation.CLOCK;
		elif shift.x < 0 and shift.y > 0:
			rotation = Rotation.CLOCK;
		elif shift.y == 0:
			if shift.x < 0:
				rotation = Rotation.CLOCK;
			
	if quadrant == Quadrant.THREE:
		if shift.x == 0:
			if shift.y < 0:
				rotation = Rotation.CLOCK;
		elif shift.x < 0 and shift.y < 0:
			rotation = Rotation.CLOCK;
		elif shift.y == 0:
			if shift.x < 0:
				rotation = Rotation.CLOCK;
			
	if quadrant == Quadrant.FOUR:
		if shift.x == 0:
			if shift.y < 0:
				rotation = Rotation.CLOCK;
		elif shift.x > 0 and shift.y < 0:
			rotation = Rotation.CLOCK;
		elif shift.y == 0:
			if shift.x > 0:
				rotation = Rotation.CLOCK;
	
	if rotation == Rotation.CLOCK:
		angle_rotation += 1;
	else:
		angle_rotation -= 1;

	if angle_rotation < 1: angle_rotation = angle_rotation + 360;
	if angle_rotation > 360: angle_rotation = angle_rotation - 360;

	previous_mouse_position = mouse_position;
	
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
