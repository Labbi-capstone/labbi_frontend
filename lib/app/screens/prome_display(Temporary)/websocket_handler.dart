// websocket_handler.dart
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketHandler {
  final WebSocketChannel channel;

  WebSocketHandler(this.channel);

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  void dispose() {
    channel.sink.close();
  }
}
