import 'package:socket_io_client/socket_io_client.dart' as sio;

class ChatWsService {
  sio.Socket? _socket;

  void connect({
    required String sessionId,
    required String token,
    required void Function() onConnected,
    required void Function(Map<String, dynamic>) onMessage,
    required void Function(dynamic) onError,
  }) {
    _socket = sio.io(
      "https://ticketing.medtrans.id",
      sio.OptionBuilder()
          .setTransports(['polling', 'websocket'])
          .setAuth({'sessionId': sessionId, 'token': token})
          .disableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) => onConnected());
    _socket!.on('new_message', (data) {
      if (data is Map) {
        onMessage(Map<String, dynamic>.from(data));
      }
    });
    _socket!.onError((err) => onError(err));
    _socket!.onConnectError((err) => onError(err));

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
