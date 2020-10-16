extends Node2D



export var listner_orientation = [0,0,0] setget change_rect

func _ready():
	set_notify_transform(true)
	set_notify_local_transform(true)


func change_rect(new_orientation):
	listner_orientation = new_orientation
	AudioManager.update_listener([global_position[0],global_position[1],-0.5])
	AudioManager.update_orientation_listener(listner_orientation)
	
	pass

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED and is_inside_tree(): 
		change_rect(listner_orientation)
