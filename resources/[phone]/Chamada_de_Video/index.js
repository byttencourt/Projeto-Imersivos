const WebSocket = require('ws');

const port = 8080;

const RTC = new WebSocket.Server({ port });

RTC.on('listening', () => {
  console.log('Listening at port', port);
});

/** @type {Map<string, Set<WebSocket>>} */
const rooms = new Map();

function id() {
  return ++id.last;
}
id.last = 0;

RTC.on('connection', (socket, request) => {
  let room = request.url && request.url.substr(1);
  if (room) {
    if (rooms.has(room)) {
      rooms.get(room).add(socket);
    } else {
      rooms.set(room, new Set([socket]));
    }
  } else {
    return socket.close();
  }

  socket.id = id();

  console.log(`WebSocket ${socket.id} connected on room: ${room}`);

  socket.on('message', data => {
    if (rooms.has(room)) {
      rooms.get(room).forEach(peer => {
        peer != socket && peer.send(data);
      });
    }
  });
  socket.on('close', () => {
    const leaveFrom = rooms.get(room);
    if (leaveFrom) {
      leaveFrom.delete(socket);
      if (!leaveFrom.size)
        rooms.delete(room);
      
      console.log(`WebSocket ${socket.id} disconnected from room: ${room}`);
    } else {
      console.log(`WebSocket ${socket.id} disconnected`);
    }
  });
});