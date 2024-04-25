/// @desc 

#macro CMD_JOIN 1
#macro CMD_LEAVE 2
#macro CMD_VOICE 3
#macro CMD_COORDS 4


global.players = {}



sounds = []

record_playback = false
instant_playback = false

// the maximum distance for 100% voice gain
max_dist = 300

audio_listener_orientation(0, 0, 1, 0, -1, 0)
em = audio_emitter_create()

var rec_count = audio_get_recorder_count()
show_debug_message(rec_count)


recording = false
r = -1
rate = 16000
channels = audio_mono
format = buffer_s16


recorders = []
recorder_id = 0

for(var i = 0; i < rec_count; ++i) {
	var map = audio_get_recorder_info(i)
	show_debug_message($"{i}) {map[? "name"]}")
	
	recorders[i] = map
}

function changeRecorder(rid) {
	if (rid >= array_length(recorders))
		return;
	
	recorder_id = rid
	
	var rdata = recorders[recorder_id]

	rate = rdata[? "sample_rate"]
	channels = rdata[? "channels"]
	format = rdata[? "data_format"]
	name = rdata[? "name"]
	
	show_debug_message($"{name} --- {rate}Hz")
}

changeRecorder(0)


recording_buff = buffer_create(rate, buffer_grow, 1)
recording_len = 0


q = audio_create_play_queue(buffer_s16, rate, channels)


var rate_buff = buffer_create(2, buffer_fixed, 1)
buffer_write(rate_buff, buffer_u16, rate)

UDPSend(CMD_JOIN, rate_buff)

buffer_delete(rate_buff)