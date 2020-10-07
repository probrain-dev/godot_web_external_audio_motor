extends Node

var selected_audio = ""
var group_select = ""
var selected_index = {}

var audio_path_names = {
	"Sounds/Music":["lobo"],
	"Sounds/FX":["bean"],
	"Sounds/Gameplay":["3rdStar"]
}

onready var modes = {
	"Standard":$Standard,
	"Spacial2D":$Spacial2D
}
var mode = "Standard"

func _ready():
	AudioManager.connect("updateProgressLoad",self,"updateProgress")
	AudioManager.connect("loadedAllAudios",self,"audioLoaded")
	AudioManager.connect("audioEnd",self,"audioEnd")
	AudioManager._audioMotorPath = ["res://howler.min.js","res://howler.spatial.min.js","res://audioEngine.js"]
	
	$Standard._list_group = audio_path_names.keys()
	var _config = $Standard._config
	
	for _path in audio_path_names:
		AudioManager.loadAudios(audio_path_names[_path], _path,_config)
		addLog("LOAD AUDIO: " + str(audio_path_names[_path])+" on path " + _path)
	
	$Standard/Lists/groupList.select(0)
	$Standard._on_groupList_item_selected(0)

func updateProgress(progress):
	if progress!= null:
		$ProgressBar.visible = true
		$ProgressBar.value = progress*100
		addLog("Audio Progress: " + str($ProgressBar.value))

func audioLoaded():
	$ProgressBar.visible = false
	$OptionButton.disabled = false

func addLog(text):
	$RichTextLabel.text = text+"\n"+$RichTextLabel.text;

func audioEnd(_audio_name):
	if $Standard.visible :
		$Standard.audio_end(_audio_name)
	addLog("Audio End");

func update_mode(mode):
	for _mod in modes:
		modes[_mod].visible = false
	
	modes[mode].visible = true;
	pass

func _on_OptionButton_item_selected(index):
	update_mode($OptionButton.get_item_text(index))
	pass # Replace with function body.
