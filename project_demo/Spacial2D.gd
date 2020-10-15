extends Panel

func init_panel():
	get_node("Control/orientation_listener/x").connect("value_changed",self,"orietnation_change_listener",[0])
	get_node("Control/orientation_listener/y").connect("value_changed",self,"orietnation_change_listener",[1])
	get_node("Control/orientation_listener/z").connect("value_changed",self,"orietnation_change_listener",[2])
	get_node("Control/orientation/x").connect("value_changed",self,"orietnation_change",[0])
	get_node("Control/orientation/y").connect("value_changed",self,"orietnation_change",[1])
	get_node("Control/orientation/z").connect("value_changed",self,"orietnation_change",[2])

	for control in $Control/Control.get_children():
		var value = "";
		if control.has_signal("value_changed"):
			control.connect("value_changed",self,"hscrol_change",[control.name])
			value = control.value
		elif control.has_signal("item_selected"):
			control.connect("item_selected",self,"options_change",[control.name])
			value = control.get_item_text(control.get_selected_id())
		elif control.has_signal("toggled"):
			control.connect("toggled",self,"hscrol_change",[control.name])
			value = control.pressed
		hscrol_change(value,control.name)

func orietnation_change_listener(newVal, _id):
	var _orientation = AudioManager.orientation_listener
	if !_orientation:
		_orientation = [0,0,0]
	_orientation[_id] = newVal
	var label:Label = $Control/orientation_listener.get_node("Label")
	var _new_label_text :String= label.text
	_new_label_text = _new_label_text.split(":")[0]
	_new_label_text = _new_label_text + ": " + str(_orientation)
	label.text = _new_label_text
	print("orietnation_change_listener")
	owner.addLog("Orientation Listener : "+str(_orientation))
	AudioManager.orientation_listener = _orientation

func orietnation_change(newVal, _id):
	var _orientation = $AudioSource/AudioSpacial2D.orientation
	if !_orientation:
		_orientation = [0,0,0]
	_orientation[_id] = newVal
	var label:Label = $Control/orientation.get_node("Label")
	var _new_label_text :String= label.text
	_new_label_text = _new_label_text.split(":")[0]
	_new_label_text = _new_label_text + ": " + str(_orientation)
	label.text = _new_label_text
	owner.addLog("Orientation Source : "+str(_orientation))
	$AudioSource/AudioSpacial2D["orientation"] = _orientation;

func options_change(index, _name):
	var _val_text = $Control/Control.get_node(_name).get_item_text(index)
	hscrol_change(_val_text, _name)

func hscrol_change(newVal, _name):
	if _name in $AudioSource/AudioSpacial2D:
		var label:Label = $Control/Control.get_node(_name).get_node("Label")
		var _new_label_text :String= label.text
		_new_label_text = _new_label_text.split(":")[0]
		_new_label_text = _new_label_text + ": " + str(newVal)
		label.text = _new_label_text
		
		$AudioSource/AudioSpacial2D[_name] = newVal;
	else:
		push_warning("method "+_name+", não existe no plugin spacial")

func _on_Spacial2D_visibility_changed():
	$AudioSource/AudioSpacial2D.enable = visible
	set_process_input(visible)
	if visible:
		init_panel()
	$Control/sound.clear()
	for key in AudioManager.audios_list_names:
		for audio in AudioManager.audios_list_names[key]:
			$Control/sound.add_item(audio)
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and is_inside_tree() and event.is_pressed() and visible:
		var pos_mouse = get_viewport().get_mouse_position();
		if pos_mouse[0]< rect_size[0] and pos_mouse[1] < rect_size[1]:
			var newpos = get_viewport().get_mouse_position()-$Listener.position;
			$Listener.translate(newpos)
			$Listener/Label.text = str($AudioSource.position.distance_to(get_viewport().get_mouse_position()))
			$AudioSource/AudioSpacial2D.update_pos()
			var posL = AudioManager.get_pos_listner()
			print(str(posL))
			owner.addLog("Listner Pos: "+str(posL))
			
			var posS = AudioManager.get_pos_source($AudioSource/AudioSpacial2D.audio_name)
			print(str(posS))
			owner.addLog("Source Pos: "+str(posS))
			pass

func _on_Button_button_up():
	$AudioSource/AudioSpacial2D.play()
	pass # Replace with function body.


func _on_sound_item_selected(index):
	$Control/sound/Label.text = $Control/sound.get_item_text($Control/sound.selected)
	$AudioSource/AudioSpacial2D.audio_name = $Control/sound/Label.text
	pass # Replace with function body.


func _on_Button2_button_up():
	AudioManager.stop($Control/sound.get_item_text($Control/sound.selected))
	pass # Replace with function body.
