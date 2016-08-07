extends Area2D

func _ready():
	set_process(true)

func _process(delta):
	set_z(get_global_pos().y)

func get_direction():
	return Vector2(0, 0)

func get_state():
	return "idle"

func on_attack1(attacker):
	pass