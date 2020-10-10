extends Panel
signal add_log

var _list_group =[] setget update_group_list
var _list_audio =[] setget update_audio_list
var selected_audio = ""
var group_select = ""
var _config = {"mute":false}
var selected_index = {}

func _ready():
	_config["pan"] = $Control/Pan.value;
	_config["volume"] = $Control/Vollume.value;
	_config["pitch"] = $Control/Pitch.value;
	_config["loop"] = false;

func update_group_list(_new_list):
	_list_group = _new_list
	$Lists/groupList.clear()
	for _item in _list_group:
		$Lists/groupList.add_item(_item)

func update_audio_list(_new_list):
	_list_audio = _new_list
	$Lists/ItemList.clear()
	for _item in _list_audio:
		$Lists/ItemList.add_item(_item)

func audio_end(_audio_name):
	$Lists/ItemList.set_item_icon(selected_index[_audio_name],null )

func _on_groupList_item_selected(index):
	group_select = $Lists/groupList.get_item_text(index)
	owner.addLog("Change Group to "+group_select)
	
	if !AudioManager.group_audios_config.has(group_select):
		return 0;
	var group_object_config = AudioManager.group_audios_config[group_select]
	_config = group_object_config;
	
	owner.addLog(str(group_object_config))
	$Control/Loop.pressed = group_object_config["loop"]
	$Control/Pan.value = group_object_config["pan"]
	$Control/Vollume.value = group_object_config["volume"]
	$Control/Pitch.value = group_object_config["pitch"]
	updateAudioList()
	pass # Replace with function body.

func updateAudioList():
	$Lists/ItemList.clear()
	for audio in owner.audio_path_names[group_select]:
		$Lists/ItemList.add_item(audio)
		if AudioManager.audio_playing.has(audio):
			$Lists/ItemList.set_item_icon(selected_index[audio], preload("res://icon.png"))

func _on_ItemList_item_selected(index):
	selected_audio = $Lists/ItemList.get_item_text(index)
	owner.addLog("Select Audio To Play: " +selected_audio)
	selected_index[selected_audio] = index
	
	#PLAY
	if(!$Lists/ItemList.get_item_icon(index)):
		$Lists/ItemList.set_item_icon(selected_index[selected_audio], preload("res://icon.png"))
		AudioManager.play(selected_audio,_config)
		owner.addLog("Play: " +selected_audio)
	else:
	#STOP
		owner.addLog("Stop: " +selected_audio)
		AudioManager.stop(selected_audio)
	pass # Replace with function body.

func config_changed():
	if AudioManager.audio_playing.size()>0:
		AudioManager.change_property()
	pass

func _on_Pan_value_changed(value):
	owner.addLog("PAN change: " +str(value))
	_config["pan"] = value;
	AudioManager.update_config(_config,group_select)
	pass # Replace with function body.


func _on_Vollume_value_changed(value):
	owner.addLog("VOL change: " +str(value))
	_config["volume"] = value;
	AudioManager.update_config(_config,group_select)
	pass # Replace with function body.


func _on_Loop_toggled(button_pressed):
	_config["loop"] = button_pressed;
	AudioManager.update_config(_config,group_select)
	pass # Replace with function body.


func _on_Pitch_value_changed(value):
	_config["pitch"] = value;
	AudioManager.update_config(_config,group_select)
	pass # Replace with function body.

