/// @desc 

x += (keyboard_check(ord("D")) - keyboard_check(ord("A"))) * base_spd
y += (keyboard_check(ord("S")) - keyboard_check(ord("W"))) * base_spd


var buff = buffer_create(4, buffer_fixed, 1)
buffer_write(buff, buffer_s16, x)
buffer_write(buff, buffer_s16, y)

UDPSend(CMD_COORDS, buff)

buffer_delete(buff)