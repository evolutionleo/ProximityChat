/// @desc 

if async_load[? "type"] != network_type_data
	exit


var buff = async_load[? "buffer"]
var size = async_load[? "size"]


var cmd = buffer_read(buff, buffer_u16)

switch (cmd) {
case (CMD_COORDS): {
	var _id = buffer_read(buff, buffer_u16)
	var _x = buffer_read(buff, buffer_s16)
	var _y = buffer_read(buff, buffer_s16)
	
	if (global.players[$ _id] == undefined) {
		global.players[$ _id] = {
			rate: 16000,
			destroyed: false,
			_id: _id,
			x: _x,
			y: _y,
			e: audio_emitter_create(),
			q: undefined,
			inst: instance_create_layer(_x, _y, "Instances", oPlayerProjection)
		}
	}
	
	var p = global.players[$ _id]
	p.x = _x
	p.y = _y
	
	if (p.destroyed) exit;
	
	
	p.inst.x = _x
	p.inst.y = _y
	
	var dx = _x - oPlayer.x
	var dy = _y - oPlayer.y
	var dist = sqrt(sqr(dx) + sqr(dy))
	
	audio_emitter_position(p.e, dx, dy, 0)
	var gain = sqr(max_dist) / sqr(dist)
	audio_emitter_gain(p.e, clamp(gain, 0, 1))
	
	show_debug_message($"{_id}) ({_x}; {_y})")
	
	break
}
case (CMD_VOICE): {
	var _id = buffer_read(buff, buffer_u16)
	var rate = buffer_read(buff, buffer_u16)
	
	var p = global.players[$ _id]
	
	if (p == undefined) exit
	if (p.destroyed) exit;
	
	
	if (p.q == undefined)
		p.q = audio_create_play_queue(buffer_s16, rate, channels)
	
	
	if (cmd == CMD_VOICE) {
		var vc_size = size - buffer_tell(buff)
		var vc_buff = buffer_create(vc_size, buffer_fixed, 1)
		
		buffer_copy(buff, buffer_tell(buff), vc_size, vc_buff, 0)
		
		show_debug_message(vc_size)
		
		audio_queue_sound(p.q, vc_buff, 0, vc_size)
		if (!audio_is_playing(p.q)) {
			audio_play_sound_on(p.e, p.q, false, 1)
		}
	}
	break
}
case CMD_LEAVE:
	var _id = buffer_read(buff, buffer_u16)
	var p = global.players[$ _id]
	if (p != undefined) {
		instance_destroy(p.inst)
		audio_free_play_queue(p.q)
		p.destroyed = true
	}
	break
}