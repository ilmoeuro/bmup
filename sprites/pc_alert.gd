extends Area2D

func _on_area_enter(obj):
	if obj.has_method("on_alert_start"):
		obj.on_alert_start(get_parent())

func _on_alert_zone_area_exit(obj):
	if obj.has_method("on_alert_end"):
		obj.on_alert_end(get_parent())