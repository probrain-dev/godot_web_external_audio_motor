# Plugin Web Audio External - GODOT

[![ProBrain](./poweredby-probrain.jpg)](https://probrain.com.br)

Plugin to use external web audio libraries, in this example we use : [![Howler](./howler.png)](https://howler.js)

# Features
 - You can implement any audio plugin JS in your Godot project.
 - Implemented like hooks, you can manage methods as you wish
 - Hook Sample Web Audio manager
 - Hook Spatial 2D Web Audio manager
 - Group Audio Config Manager

# Fucture Features
 - Hook Spatial 3D Web Audio manager

# Instalation
- Paste the addons folder into your game
- Active Plugin WebAudioExternal on Godot Settings

So they created a two Singleton on your project, JavascriptManager and AudioManager.
- JavascriptManager - hook methods and properties from Godot to JS
- AudioManager - Have all generic methods and properties you can use on your Godot Project.

# Configuration
To config you need insert the paths of the audio library.
```sh
//example absolut path
AudioManager._audioMotorPath = ["https://cdnjs.cloudflare.com/ajax/libs/howler/2.2.0/howler.min.js"]
```
or you can insert the resource path, inside Godot
```sh
//example path inside Godot
AudioManager._audioMotorPath = ["res://howler.min.js"]
```
the plugin need a AudioEngine class on js front, you can insert the file into the end of AudioManager._audioMotorPath, so the Plugin insert on the order of the array. The plugin already has this js configured for you.
```sh
//example path inside Godot
AudioManager._audioMotorPath = ["res://howler.min.js","res://audioEngine.js"]
```
# Implementation with Howler
## Load Audios / Group Audios
```sh
AudioManager.loadAudios(_audio_names, _path, _config)
```
- _audio_names : list of audio to load, it's gonna be related on the group.
- _path : the path folder have the audios, the _path its the group of the audio_list.
- _config : it's a object, can have any kind of properties, that is related on the group. The config it's passed and assygn on the audio object.
```sh
#Example
AudioManager.loadAudios(["bean","correct"], "Sound/FX", {"loop":false, "pan":-1})
# Sound/FX - is the path of the audios, and is the group named of then.
# {"loop":false, "pan":-1} - pass the params to the Howl objecto, and load the audio with that configuration.
```
## Fall Backs - Godot signal
Any fall backs on the plugin do a request to the js, to update the progress fall back.
- **updateProgressLoad** : return a float represent the progress loaded(0-1 - represent the all audio loaded)
- **loadedAllAudios** : fall back loaded all audios
- **audioEnd** : fall back when the audio playing it's end, return _audio_name of the audio finish.

## Audio Control
- **play(audio_name, _config={})**: Begins the playback of a sound.
        - **audio_name**: audio name of the audio yout want to play.
        - **_config**: you can send a config object with any property you want change. If you dont pass nothing they load the config from the group. You can see on the [Howler Documentation](https://github.com/goldfire/howler.js#plugin-spatial) each atributes you can set.

- **stop(_name)** : Stop the audio playback of a Sound/Group.
        - **_name** : Name of the audio stop or the group you want to stop all audios playbacks.

- **pause(_name)** : Pause the audio playback of a Sound/Group.
        - **_name** : Name of the audio pause or the group you want to pause all audios playbacks.

- **mute(_name)** : Mute the audio playback of a Sound/Group.
        - **_name** : Name of the audio mute or the group you want to mute all audios playbacks.

### Audio Spatial
Remember the audio Spatial on Howler, need a more one js to load, the howler.spatial.js, so add then on the AudioManager._audioMotorPath. So the Plugin add two object's node on the Godot, AudioSacial2D and AudioListener2D, both are used to make the audio on the spacial.
##### AudioSacial2D
That plugin is audio positioned on the space Godot. All the atributes is taken from the [Howler Spatial](https://github.com/goldfire/howler.js#plugin-spatial)
- **audio_name** : name of the audio source gonna be played
- **orientation** : directional audio source is pointing on 3D Cartesian.
- **loop** : set the loop to the audio source.
- **volume** : Volume of the audio, even you set volume to the plugin the values of the Godot is [-60 to 0] the plugin  convert the value to Howler.
- **pitch** : It's the rate of the audio is playing.
The another atributes is from [pannerAttr](https://github.com/goldfire/howler.js#pannerattro-id) from the Howler.

### Playback Change Config
You can change the config of the audio as wish, same as on playback. You have two method can help you in this.
- **update_config(_new_config,_group_name)**: change the config for the group, all the audio on the group change your's properties.
- **update_config_audio(_new_config,_audio_name)**: change the config for the audio source.

## Config
Any config you can change the you can pass atributes or methods to call. The plugin will find that method or atribute and set to then. 

## Implementation with another js librarie
You maid need to see audioEngine.js and update the methods for your libraries. 
