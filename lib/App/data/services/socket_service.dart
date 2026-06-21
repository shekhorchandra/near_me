import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../modules/services/contants/api_constants.dart';

class SocketService extends GetxService {
  late IO.Socket socket;

  final RxSet<String> onlineUsers = <String>{}.obs;

  /// 🔥 EVENT STREAM REGISTRY
  final Map<String, List<Function(dynamic)>> _listeners = {};

  Future<SocketService> connect(String userId) async {
    socket = IO.io(
      // "https://uncried-unpreventible-declan.ngrok-free.dev",
      ApiConstants.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      print("✅ CONNECTED");
      socket.emit("join-user", userId);
    });

    /// ONLINE USERS (centralized)
    socket.on("get_online_users", (data) {
      print("ONLINE USERS => $data");

      onlineUsers.clear();

      if (data is List) {
        onlineUsers.addAll(data.map((e) => e.toString()));
      }
    });

    /// 🔥 CENTRAL EVENT DISPATCHER
    socket.onAny((event, data) {
      if (_listeners.containsKey(event)) {
        for (final cb in _listeners[event]!) {
          cb(data);
        }
      }
    });

    socket.connect();
    return this;
  }

  // ======================================================
  // 🔥 PUBLIC API (NO DUPLICATION POSSIBLE)
  // ======================================================

  void onEvent(String event, Function(dynamic) callback) {
    _listeners.putIfAbsent(event, () => []);

    /// ❌ prevent duplicate registration
    if (_listeners[event]!.contains(callback)) return;

    _listeners[event]!.add(callback);
  }

  void offEvent(String event, [Function(dynamic)? callback]) {
    if (!_listeners.containsKey(event)) return;

    if (callback == null) {
      _listeners.remove(event);
    } else {
      _listeners[event]!.remove(callback);
    }
  }

  void clearAllEvents() {
    _listeners.clear();
  }
}