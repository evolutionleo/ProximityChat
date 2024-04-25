/// @desc 

if (!recording and keyboard_check_pressed(ord("R"))) {
	r = audio_start_recording(recorder_id)
	recording = true
}
else if (recording and keyboard_check_pressed(ord("R"))) {
	audio_stop_recording(r)
	recording = false
	
	// play it back
	if (record_playback) {
		var snd = buffer_create(recording_len, buffer_fixed, 1)
		buffer_copy(recording_buff, 0, recording_len, snd, 0)
	
	
		var rec = audio_create_buffer_sound(snd, format, rate, 0, recording_len, audio_mono)
		array_push(sounds, snd)
	
		audio_play_sound(rec, 1, false)
	
	
		recording_len = 0
	}
}


for(var i = 0; i < 9; i++) {
	if (keyboard_check_pressed(ord(string(i)))) {
		changeRecorder(i)
	}
}