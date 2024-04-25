/// @desc 

draw_set_halign(fa_center)
draw_set_valign(fa_top)

draw_text(room_width/2, 30, $"recorder#{recorder_id}: {name}, {rate}Hz {recording ? "(LIVE)" : ""}")