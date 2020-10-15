extends Node
class_name AudioManage
var enable = OS.has_feature('JavaScript')
var isLoaddedAllAudios = false;
var startLoadFiles = false
export var _audioMotorPath = ["res://howler.min.js","res://howler.spatial.min.js","res://audioEngine.js"]
export var audios_list_names = {}
export var js_object_name = "audioEngine"
var audio_playing = {}
var group_audios_config = {}
var orientation_listener = [] setget update_orientation_listener

export var engine_to_js = {
	"loadAudios":"initAudios",
	"statusLoad":"statusFilesLoadAudio",
	"play":"playAudio",
	"statusPlay":"statusAudioPlaying",
	"stop":"stopAudio",
	"pause":"pauseAudio",
	"updateConfig":"updateConfigAudio",
	"updateListener":"updateListenerPosition",
	"updateOrientationListener":"updateListenerOrientation",
	"listenerPos":"getListenerPosition",
	"sourcePos":"getAudioSourcePosition",
	"updateSourcePosition":"setSourcePosition",
	"updateSourceOrientation":"setSourceOrientation"
}

signal updateProgressLoad;
signal loadedAllAudios;
signal audioEnd;


func _init():
	if enable:
		JavascriptManager.init(_audioMotorPath)
		JavascriptManager._run("var "+js_object_name+" = new AudioEngine();")
		

### LOAD AUDIO 
func loadAudios( filePaths: Array, _pathRelative, _config = {}):
	isLoaddedAllAudios = false
	audios_list_names[_pathRelative] = filePaths
	group_audios_config[_pathRelative] = _config.duplicate()
	if enable:
		JavascriptManager._js_method_call(js_object_name,engine_to_js["loadAudios"],[filePaths,_pathRelative,_config])
		yield(get_tree(),"idle_frame")
		if !startLoadFiles:
			startLoadFiles = true
			yield_audio_load()
	else:
		if !startLoadFiles:
			startLoadFiles = true
			yield(get_tree().create_timer(1),"timeout")
			emit_signal("loadedAllAudios")

func yield_audio_load():
	var percent = JavascriptManager._js_method_call(js_object_name,engine_to_js["statusLoad"])
	emit_signal("updateProgressLoad",percent)
	
	if float(percent)<1:
		yield(get_tree().create_timer(0.1),"timeout")
		yield_audio_load()
	else:
		emit_signal("loadedAllAudios")
		startLoadFiles = false
		isLoaddedAllAudios = true

func get_group_audio(audio_name):
	var ret = -1;
	for key in audios_list_names:
		if audios_list_names[key].find(audio_name)>-1:
			ret = key;
	return ret

### Spatial control
func update_listener(new_pos):
	JavascriptManager._js_method_call(js_object_name,engine_to_js["updateListener"],[new_pos])
	pass

func update_orientation_listener(new_orientation):
	orientation_listener = new_orientation
	JavascriptManager._js_method_call(js_object_name,engine_to_js["updateOrientationListener"],[new_orientation])

func update_source_pos(new_pos,audio_name=""):
	JavascriptManager._js_method_call(js_object_name,engine_to_js["updateSourcePosition"],[new_pos,audio_playing[audio_name],audio_name])

func update_source_orientation(new_or,audio_name=""):
	JavascriptManager._js_method_call(js_object_name,engine_to_js["updateSourceOrientation"],[new_or,audio_playing[audio_name],audio_name])

func get_pos_listner():
	var ret = JavascriptManager._js_method_call(js_object_name,engine_to_js["listenerPos"],[])
	return ret

func get_pos_source(audio):
	return JavascriptManager._js_method_call(js_object_name,engine_to_js["sourcePos"],[audio,audio_playing[audio]])

##### Audio Control
### PLAY 
func play(_audio_name,_config={}):
	if enable and isLoaddedAllAudios:
		var group_audio = get_group_audio(_audio_name)
		if typeof(group_audio)== TYPE_INT and group_audio == -1:
			push_warning("Audio is not Loaded: "+_audio_name+". Please use loadAudios first.")
			return 0;
		
		var _config_converted = {}
		if _config != {}:
			_config_converted = convert_config(_config)
			group_audios_config[group_audio] = _config
		else:
			_config_converted = convert_config(group_audios_config[group_audio])
		
		var _id = JavascriptManager._js_method_call(js_object_name,engine_to_js["play"],[_audio_name,_config_converted])
		audio_playing[_audio_name] = _id;
		yield_audio_end(_audio_name)
	else:
		emit_signal("audioEnd",_audio_name)
	pass


func update_config(_new_config,_group_name):
	var _audio_update = audio_playing.keys()
	
	var _audios = audios_list_names[_group_name]
	if _audios.size()>0:
		_audio_update = _audios
	
	var _config_converted = {}
	if _new_config != {}:
		group_audios_config[_group_name] = _new_config.duplicate()
		_config_converted = convert_config(_new_config)
	
	if _audio_update.size()==0:
		push_warning("Audios empty on Group")
		return 0;
	
	if enable and isLoaddedAllAudios:
		JavascriptManager._js_method_call(js_object_name,engine_to_js["updateConfig"],[_config_converted,_audio_update])


func update_config_audio(_new_config,_audio_name):
	var _audio_update = [_audio_name]
	
	var _config_converted = {}
	if _new_config != {}:
		_config_converted = convert_config(_new_config)
	
	if _audio_update.size()==0:
		push_warning("Audio vazio ")
		return 0;
	
	if enable and isLoaddedAllAudios:
		JavascriptManager._js_method_call(js_object_name,engine_to_js["updateConfig"],[_config_converted,_audio_update])


func convert_config(_config):
	var _new_config = []
	for key in _config:
		_new_config.push_back({"name":key,"params":[_config[key]]})
	return _new_config


func yield_audio_end(_audio_name):
	var index = JavascriptManager._js_method_call(js_object_name,engine_to_js["statusPlay"],[_audio_name])
	if index >-1:
		yield(get_tree().create_timer(0.1),"timeout")
		yield_audio_end(_audio_name);
	else:
		audio_playing.erase(_audio_name)
		emit_signal("audioEnd",_audio_name)


func process_audio_config(_audio_name, _config_name, process_all = false):
	if _audio_name=="":
		push_error("Need a audio_name to pause")
		return 0;
	
	if audio_playing.has(_audio_name):
		JavascriptManager._js_method_call(js_object_name,engine_to_js[_config_name],[_audio_name])
	else:
		var group_playing = get_audios_playing_on_group(_audio_name)
		if group_playing.size()>0:
			for _audio in group_playing:
				JavascriptManager._js_method_call(js_object_name,engine_to_js[_config_name],[_audio])
		else:
			if process_all:
				for key in audio_playing:
					JavascriptManager._js_method_call(js_object_name,engine_to_js[_config_name],[key])
			else:
				push_warning("no one audio to "+_config_name+", "+_audio_name+" not find")


func get_audios_playing_on_group(group_name):
	var ret = []
	if !audios_list_names.has(group_name):
		return []
	
	for key in audio_playing:
		if audios_list_names[group_name].find(key)>-1:
			ret.push_back(key)
	
	return ret
	
func pause(_audio_name):
	process_audio_config(_audio_name,"pause")

func stop(_audio_name="",process_all = false):
	process_audio_config(_audio_name,"stop",process_all)

func mute(_audio_name=""):
	process_audio_config(_audio_name,"mute")
