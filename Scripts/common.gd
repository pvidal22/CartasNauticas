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
var item_target_position: Vector2 = Vector2.ZERO;
var movement_vector: Vector2 = Vector2.ZERO;
var angle_rotation := 0;
var item_name: String = "";
var flip_position := 0;
var collision_items: Array = [];
var movement_speed = 500;

func _init(p_item_name: String):
	self.item_name = p_item_name; 
	
func get_moving() -> bool:
	return moving;

func get_turning() -> bool:
	return turning;

func display(item, delta):
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
	var shift := mouse_position - previous_mouse_position;
	if shift == Vector2.ZERO:
		return;

	var quadrant = mouse_position - current_position;
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

func add_collision_area(area_name: String):
	if area_name in collision_items:
		return;
	collision_items.append(area_name);
	print("Collision_items: " + str(collision_items));

func remove_collision_area(area_name: String):
	while area_name in collision_items:
		collision_items.erase(area_name);
	print("Collision_items: " + str(collision_items));

func _input(ev: InputEvent):
	if ev is InputEventMouseButton:
		ev = ev as InputEventMouseButton;
		if ev.button_index == 1 and ev.doubleclick:
			stop_it();
