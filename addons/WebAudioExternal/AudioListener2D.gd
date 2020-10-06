extends Node2D

signal transform_changed

func _init():
	set_notify_transform(true)
	connect("transform_changed",self,"change_rect")

func change_rect():
	AudioManager.update_listener([global_position[0],global_position[1],-0.5])
	AudioManager.update_orientation_listener([0,0,0])
	
	pass

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED and is_inside_tree(): 
		emit_signal("transform_changed")
