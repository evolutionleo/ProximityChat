const udp = require('node:dgram');

const clients = [];
let clientID = 1;

const server = udp.createSocket('udp4');
const port = 1069;

function broadcast (msg, except) {
    clients.forEach(c => {
        if (c.id != except.id) {
            server.send(msg, 0, msg.length, c.port, c.ip);
        }
    });
}

// commands
const CMD_JOIN = 1;
const CMD_LEAVE = 2;
const CMD_VOICE = 3;
const CMD_COORDS = 4;

server.on('message', (buff, info) => {
    let ip = info.address;
    let port = info.port;

    let c = clients.find(c => c.ip === ip && c.port === port);

    if (c === undefined) {
        c = {
            id: clientID++,
            ip: ip,
            port: port,
            x: 0,
            y: 0,
            rate: 16000
        };

        clients.push(c);
    }
    
    let cmd = buff.readUint16LE(0);
    
    switch(cmd) {
        case CMD_JOIN:
            console.log(`client #${c.id} joined`);
            break;
        
        case CMD_LEAVE:
            console.log(`client #${c.id} left`);
            clients.splice(clients.indexOf(c), 1);

            var b = Buffer.alloc(buff.length + 2);
            b.writeUInt16LE(cmd);
            b.writeUInt16LE(c.id, 2);

            broadcast(b, c);
            break;
        
        // voice data
        case CMD_VOICE:

            var b = Buffer.alloc(buff.length + 6);
            b.writeUInt16LE(cmd);
            b.writeUInt16LE(c.id, 2);
            b.writeUInt16LE(c.rate, 4);

            buff.copy(b, 6);

            broadcast(b, c);
            break;
        
        // position data
        case CMD_COORDS:
            let x = buff.readInt16LE(2);
            let y = buff.readInt16LE(4);

            c.x = x;
            c.y = y;

            var b = Buffer.alloc(8);
            b.writeUInt16LE(cmd);
            b.writeUInt16LE(c.id, 2);
            b.writeInt16LE(c.x, 4);
            b.writeInt16LE(c.y, 6);

            broadcast(b, c);
            break;
    }
});

server.on('listening', () => {
    var address = server.address();
    console.log('UDP Server listening on ' + address.address + ":" + address.port);
});

server.bind(port);