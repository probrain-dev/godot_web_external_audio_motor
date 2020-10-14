tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("JavascriptManager","res://addons/WebAudioExternal/JavascriptManager.gd")
	add_autoload_singleton("AudioManager","res://addons/WebAudioExternal/AudioManager.gd")
	
	add_custom_type("AudioSpacial2D", "Node2D", load("res://addons/WebAudioExternal/AudioSpacial2D.gd"), load("res://addons/WebAudioExternal/icon.png"))
	add_custom_type("AudioListener2D", "Node2D", load("res://addons/WebAudioExternal/AudioListener2D.gd"), load("res://addons/WebAudioExternal/listener.png"))
	pass


func _exit_tree():
	remove_autoload_singleton("JavascriptManager")
	remove_autoload_singleton("AudioManager")
	
	remove_custom_type("AudioSpacial2D")
	remove_custom_type("AudioListener2D")
	pass
