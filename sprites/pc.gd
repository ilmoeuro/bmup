extends "char.gd"

const speed = 100
const actions = {
	"pc%d_left": {
		"dir": Vector2(-1, 0),
		"state": "walk"
	},
	"pc%d_right": {
		"dir": Vector2(1, 0),
		"state": "walk"
	},
	"pc%d_up": {
		"dir": Vector2(0, -1),
		"state": "walk"
	},
	"pc%d_down": {
		"dir": Vector2(0, 1),
		"state": "walk"
	},
	"pc%d_attack1": {
		"dir": Vector2(0, 0),
		"state": "attack1",
		"state_prio": 1,
		"stop": true
	}
}

export(NodePath) var overlay_node
export(NodePath) var sample_player_node
export(int) var character_number = 1

var overlay
var sample_player
var direction = Vector2(0, 0)
var state = "idle"

func is_blocked(pos):
	if (pos.x < 0 or pos.x >= overlay.get_width() or
	    pos.y < 0 or pos.y >= overlay.get_height()):
		return true
	var pixel = overlay.get_pixel(int(pos.x), int(pos.y))
	return  (pixel.r8 == 0 and
	         pixel.g8 == 255 and
	         pixel.b8 == 0 and
	         pixel.a8 == 255)

func _ready():
	set_fixed_process(true)
	var node = get_node(overlay_node)
	if (node extends Sprite):
		var texture = node.get_texture()
		if (texture extends ImageTexture): 
			overlay = texture.get_data()
	sample_player = get_node(sample_player_node)
	if not (sample_player extends SamplePlayer2D):
		printerr("Sample Player Node must be a SamplePlayer2D")

func _fixed_process(delta):
	var pos = get_pos()
	var stop = false
	var state_prio = -1
	var old_state = state
	state = "idle"
	direction = Vector2(0, 0)
	for action in actions:
		var entry = actions[action]
		if Input.is_action_pressed(action % character_number):
			var entry_prio = 0
			if "state_prio" in entry:
				entry_prio = entry.state_prio
			if entry_prio > state_prio:
				state_prio = entry_prio
				state = entry.state
			direction += entry.dir
			if "stop" in entry:
				stop = true
	
	if state != old_state:
		state_change(old_state)
	
	if not stop:
		pos += speed * delta * direction
	
	if not is_blocked(pos):
		set_pos(pos)

func get_direction():
	return direction

func get_state():
	return state

func state_change(old_state):
	var play_sample = false
	if state == "attack1":
		for obj in get_overlapping_areas():
			if obj.has_method("on_attack1"):
				obj.on_attack1(self)
				play_sample = true
	
	if play_sample:
		sample_player.play("punch")

func on_attack1(attacker):
	pass # hide()