# Plugin GODOT - External Web Audio

[![ProBrain](./poweredby-probrain.jpg)](https://probrain.com.br)

Plugin to use external web audio libraries within Godot, for this example we used : [![Howler](./howler.png)](https://howler.js)

# Features
 - You can implement any JS audio plugin in your Godot project
 - Work with hook methods, so you can manage methods with any external JS audio plugin
 - Standard Web Audio Manager
 - 2D Spatial Web Audio Manager
 - Group Audio Config Manager

# Upcoming Features
 - 3D Spatial Web Audio Manager

# Installation
- Paste the addons folder into your game project folder.
- Enable the Plugin "WebAudioExternal" in the Project Settings.

After that, two singletons will be add into your project, "JavascriptManager" and "AudioManager".
- JavascriptManager: Hook methods and properties from GoDot to JS.
- AudioManager: Have all generic methods and properties you can use in your Godot Project.

# Configuration
To config, you need to insert a res:// path to the audio library.
```sh
//Example of a relative path
AudioManager._audioMotorPath = ["res://howler.min.js"]
```
This plugin needs an AudioEngine class to work, it can be inserted at the end of AudioManager._audioMotorPath, the plugin will be instanciated at the end of the array. This plugin already has this class setted for you ;) it uses the Howler Library.
```sh
//Example of a relative path
AudioManager._audioMotorPath = ["res://howler.min.js","res://audioEngine.js"]
```
# Implementation with Howler
## Load Audios / Group Audios
```sh
AudioManager.loadAudios(_audio_names, _path, _config)
```
- _audio_names : list of audios to load, it's going to be related to the group.
- _path : is the path folder with your audios files, this _path will also be the audio_list groups name.

- _config : It's an object, where you can have any kind of properties that are related to the group. The config object will be passed to the audio object. Check some examples below.
```sh
#Example
AudioManager.loadAudios(["bean","correct"], "Sound/FX", {"loop":false, "pan":-1})
# Sound/FX - is the path to the audios, and is also the group's name.
# {"loop":false, "pan":-1} - passes the parameters to the Howler object, and loads the audio within that configuration.
```
## Fallbacks - Godot Signal
Any fallbacks in this plugin makes a request to the AudioEngine file, in order to validate the status of the fallback call.
- **updateProgressLoad** : returns a float that represents the loaded progress (From 0 to 1), to be used in any kinda of progressbar or loading screen.
- **loadedAllAudios** : fallback to sign all loaded audios.
- **audioEnd** : fallback for when the playing audio reaches its end, it returns the _audio_name when the audio finishes playing.

## Audio Control
- **play(audio_name, _config={})**: Begins to play the audio.
        - **audio_name**: Name of the audio you want to play.
        - **_config**: you can pass a config object with any property you may need to change. If nothing is passed, it will load the standard config settings for the group. You can check at [Howler Documentation](https://github.com/goldfire/howler.js#plugin-spatial) all avaiable atributes.
```sh
#Example
AudioManager.play("bean",{"loop":true})
# {"loop":false, "pan":-1} - pass the parameters to the Howler object, and loads the audio with that configuration.
```

- **stop(_name)** : Stops the current playing audio, or a whole Group of Audios.
        - **_name** : Name of the audio you want to stop, or the name of the group of audios you want to stop.
```sh
#Example
AudioManager.stop("bean") // audio
or
AudioManager.stop("Sound/FX") // group
```

- **pause(_name)** : Pauses the current playing audio or a Group of Audios.
        - **_name** : Name of the audio you want to pause, or the name of the group of audios you want to pause.
```sh
#Example
AudioManager.pause("bean") // audio
or
AudioManager.pause("Sound/FX") // group
```

- **mute(_name)** : Mute the current playing audio, or a whole Group of audios.
        - **_name** : Name of the audio you want to mute, or the name of the group of audios you want to mute.
```sh
#Example
AudioManager.mute("bean") // audio
or
AudioManager.mute("Sound/FX") // group
```

### Spatial Audio
Remember, the Spatial Audio of the Howler Library requires one more js file to be loaded, the "howler.spatial.js", add it to the AudioManager._audioMotorPath. After its inclusion, the Plugin will add two objects nodes into Godot, "AudioSpatial2D" and "AudioListener2D", both are used to set and config the spatial audio inside GoDot.
##### AudioSpatial2D
This node is the space position, all atributes are taken from the [Howler Spatial](https://github.com/goldfire/howler.js#plugin-spatial)
- **audio_name** : name of the audio source you wish to play
- **orientation** : directional audio source, that is a point on a 3D Cartesian grid.
- **loop** : sets if the audio should loop or not.
- **volume** : volume of the audio, it uses GoDots volume value system (From -60 to 0), and converts its values to Howlers.
- **pitch** : It's the speed of the audio that is playing. (Giving the impression of a higher or lower Pitched Audio)
Any other atributes are from: [pannerAttr](https://github.com/goldfire/howler.js#pannerattro-id).

### Playback Change Config
You can change the audio's configuration as you wish, in the same way as done on playbacks. For this, you have two methods that can help you.
- **update_config(_new_config,_group_name)**: change the configuration values of a group, the new settings will take effect in all audios inside the group. 
- **update_config_audio(_new_config,_audio_name)**: change the configuration values for a single audio source.

## Config
You can set any value to the Config Object, it will verify if any method or property exists, and if its found, it will update it for you.
```sh
#Example
AudioManager.update_config({mute:true},"Sound/FX")
```

## Implementation with another JS library
You may need to see the audioEngine.js file and manually update the methods for your new JS library. 