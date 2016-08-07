extends "char.gd"

const speed = 100
const attack_freq = 10

export(NodePath) var sample_player_node

var direction = Vector2(0, 1)
var state = "walk"
var attack1_counter = attack_freq
var parent
var sample_player

func _ready():
	set_fixed_process(true)
	parent = get_parent()
	if not (parent extends PathFollow2D):
		parent = null
	sample_player = get_node(sample_player_node)
	if not (sample_player extends SamplePlayer2D):
		printerr("Sample Player Node must be a SamplePlayer2D")

func _fixed_process(delta):
	var old_pos = get_global_pos()
	if state == "walk" and parent != null:
		var offset = parent.get_offset()
		parent.set_offset(offset + speed * delta)
		var pos = get_global_pos()
		var angle = (pos - old_pos).angle()
		set_direction_from_angle(angle)
	elif state == "attack1":
		attack1_counter -= 1
		if attack1_counter < 1:
			state = "idle"
			attack1_counter = attack_freq
	elif state == "idle":
		attack1_counter -= 1
		if attack1_counter < 1:
			state = "attack1"
			attack1_counter = attack_freq
			send_attack_notifications()

func send_attack_notifications():
	var play_sample = false
	for obj in get_overlapping_areas():
		if obj.has_method("on_attack1"):
			obj.on_attack1(self)
			play_sample = true
	if play_sample:
		sample_player.play("punch")

func set_direction_from_angle(angle):
	if angle < -(7 * PI)/8:
		direction = Vector2(0, -1)
	elif angle < -(5 * PI)/8:
		direction = Vector2(1, -1)
	elif angle < -(3 * PI)/8:
		direction = Vector2(-1, 0)
	elif angle < -PI/8:
		direction = Vector2(-1, 1)
	elif angle < PI/8:
		direction = Vector2(0, 1)
	elif angle < (3 * PI)/8:
		direction = Vector2(1, 1)
	elif angle < (5 * PI)/8:
		direction = Vector2(1, 0)
	elif angle < (7 * PI)/8:
		direction = Vector2(1, -1)
	else:
		direction = Vector2(0, -1)

func get_direction():
	return direction

func get_state():
	return state

func on_attack1(attacker):
	pass # hide()

func on_alert_start(pc):
	state = "attack1"
	var my_pos = get_global_pos()
	var pc_pos = pc.get_global_pos()
	var angle = (pc_pos - my_pos).angle()
	set_direction_from_angle(angle)

func on_alert_end(pc):
	state = "walk"