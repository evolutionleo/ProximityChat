/// @desc 

array_foreach(sounds, function(sound) {
	audio_free_buffer_sound(sound)
})