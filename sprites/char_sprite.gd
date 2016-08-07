extends Sprite

const Char = preload("./char.gd")

const frame_numbers = {
	Vector2(0,  -1) : 0,
	Vector2(-1, -1) : 1,
	Vector2(-1, 0)  : 2,
	Vector2(-1, 1)  : 3,
	Vector2(0,  1)  : 4,
	Vector2(1,  1)  : 5,
	Vector2(1,  0)  : 6,
	Vector2(1, -1)  : 7
}

var base_frame = 0
var anim_frame = 0
var parent

export var anim_speed = 7

func _ready():
	set_process(true)
	
	parent = get_parent()
	
	if not (parent extends Char):
		printerr("This node must be a child node of a Char")

func _process(delta):
	var direction = parent.get_direction()
	var state = parent.get_state()
	if direction in frame_numbers:
		base_frame = frame_numbers[direction]
	
	if state == "walk":
		anim_frame += anim_speed * delta
		var frame = (int(anim_frame) % 4) * 8 + 8 + base_frame
		set_frame(frame)
	elif state == "attack1":
		set_frame(base_frame + 40)
	else:
		set_frame(base_frame)