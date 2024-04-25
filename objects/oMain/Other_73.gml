/// @desc 

var buff = async_load[? "buffer_id"]
var recording_id = async_load[? "channel_index"]
var len = async_load[? "data_len"]


if (recording_id != r) exit;


// record the whole thing
if (record_playback) {
	buffer_copy(buff, 0, len, recording_buff, recording_len)
	recording_len += len
}

var bit = buffer_create(len, buffer_fixed, 1)
buffer_copy(buff, 0, len, bit, 0)


show_debug_message(buffer_get_size(bit))
UDPSend(CMD_VOICE, bit)



// instant playback of the recording
if (instant_playback) {
	var snd = audio_create_buffer_sound(bit, format, rate, 0, len, channels)
	array_push(sounds, snd)

	audio_queue_sound(q, bit, 0, len)
	if (!audio_is_playing(q)) {
		//audio_play_sound(q, 1, false)
		audio_emitter_position(em, 0, 0, 0)
		audio_play_sound_on(em, q, 1, false)
	}
}
else {
	buffer_delete(bit)
}