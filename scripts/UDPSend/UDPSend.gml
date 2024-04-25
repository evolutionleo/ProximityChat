// <3
function UDPSend(cmd = 0, buff = undefined, ip = "127.0.0.1", port = 1069) {
	static sock = network_create_socket(network_socket_udp)
	
	var len = (buff != undefined) ? buffer_get_size(buff) : 0
	
	var pack = buffer_create(len + 2, buffer_fixed, 1)
	buffer_write(pack, buffer_u16, cmd)
	
	if (buff != undefined)
		buffer_copy(buff, 0, len, pack, 2)
	
	network_send_udp_raw(sock, ip, port, pack, len + 2)
}