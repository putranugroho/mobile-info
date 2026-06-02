import 'package:socket_io_client/socket_io_client.dart' as sio;

class ChatWsService {
  sio.Socket? _socket;

  void connect({
    required String sessionId,
    required String token,
    required void Function() onConnected,
    required void Function(Map<String, dynamic>) onMessage,
    required void Function(dynamic) onError,
    void Function()? onSessionClosed,
    void Function()? onReconnected,
  }) {
    _socket = sio.io(
      "https://ticketing.medtrans.id",
      sio.OptionBuilder()
          .setTransports(['polling', 'websocket'])
          .setAuth({'sessionId': sessionId, 'token': token})
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      _socket!.emit('user_join_session', {'sessionId': sessionId, 'token': token});
      onConnected();
    });
    _socket!.on('reconnect', (_) {
      onReconnected?.call();
    });
    _socket!.on('new_message', (data) {
      if (data is Map) {
        onMessage(Map<String, dynamic>.from(data));
      }
    });
    _socket!.on('session_closed', (_) {
      onSessionClosed?.call();
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
