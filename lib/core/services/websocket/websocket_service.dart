import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class LiveSocketService {
  final WebSocketChannel _channel;

  LiveSocketService({required String host, required int port})
      : _channel = WebSocketChannel.connect(
          Uri.parse("ws://$host:$port/live"),
        );

  Stream<dynamic> get stream => _channel.stream.map((event) {
        try {
          return json.decode(event);
        } catch (_) {
          return {'error': 'Invalid JSON', 'raw': event};
        }
      });

  void dispose() {
    _channel.sink.close();
  }
}
