// import 'package:get/get.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// import '../../modules/services/contants/api_constants.dart';
//
// class SocketService extends GetxService {
//   late IO.Socket socket;
//
//   final RxSet<String> onlineUsers = <String>{}.obs;
//
//   /// 🔥 EVENT STREAM REGISTRY
//   final Map<String, List<Function(dynamic)>> _listeners = {};
//
//   Future<SocketService> connect(String userId) async {
//     socket = IO.io(
//       // "https://uncried-unpreventible-declan.ngrok-free.dev",
//       ApiConstants.baseUrl,
//       IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .disableAutoConnect()
//           .build(),
//     );
//
//     socket.onConnect((_) {
//       print("✅ CONNECTED");
//       socket.emit("join-user", userId);
//     });
//
//     /// ONLINE USERS (centralized)
//     socket.on("get_online_users", (data) {
//       print("ONLINE USERS => $data");
//
//       onlineUsers.clear();
//
//       if (data is List) {
//         onlineUsers.addAll(data.map((e) => e.toString()));
//       }
//     });
//
//     /// 🔥 CENTRAL EVENT DISPATCHER
//     socket.onAny((event, data) {
//       if (_listeners.containsKey(event)) {
//         for (final cb in _listeners[event]!) {
//           cb(data);
//         }
//       }
//     });
//
//     socket.connect();
//     return this;
//   }
//
//   // ======================================================
//   // 🔥 PUBLIC API (NO DUPLICATION POSSIBLE)
//   // ======================================================
//
//   void onEvent(String event, Function(dynamic) callback) {
//     _listeners.putIfAbsent(event, () => []);
//
//     /// ❌ prevent duplicate registration
//     if (_listeners[event]!.contains(callback)) return;
//
//     _listeners[event]!.add(callback);
//   }
//
//   void offEvent(String event, [Function(dynamic)? callback]) {
//     if (!_listeners.containsKey(event)) return;
//
//     if (callback == null) {
//       _listeners.remove(event);
//     } else {
//       _listeners[event]!.remove(callback);
//     }
//   }
//
//   void clearAllEvents() {
//     _listeners.clear();
//   }
// }

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../modules/services/contants/api_constants.dart';

class SocketService extends GetxService {
  IO.Socket? socket;

  final RxSet<String> onlineUsers = <String>{}.obs;

  /// event -> callbacks
  final Map<String, List<Function(dynamic)>> _listeners = {};
  final Map<String, dynamic> pendingEvents = {};

  Future<SocketService> connect(String userId) async {
    // Prevent multiple socket instances
    if (socket != null) {
      socket!.dispose();
      socket = null;
    }

    socket = IO.io(
      ApiConstants.baseUrl,
      IO.OptionBuilder()
          .setTransports(["websocket"])
          .enableReconnection()
          .setReconnectionAttempts(999999)
          .setReconnectionDelay(2000)
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );

    socket!.onConnect((_) {
      print("✅ SOCKET CONNECTED");
      print("Socket ID => ${socket!.id}");

      socket!.emit("join-user", userId);

      // Register all saved listeners
      _listeners.forEach((event, callbacks) {
        socket!.off(event);

        for (final cb in callbacks) {
          socket!.on(event, cb);
        }
      });
    });

    socket!.onDisconnect((reason) {
      print("❌ SOCKET DISCONNECTED");
      print(reason);
    });

    socket!.onConnectError((error) {
      print("❌ SOCKET CONNECT ERROR");
      print(error);
    });

    socket!.onError((error) {
      print("❌ SOCKET ERROR");
      print(error);
    });

    socket!.onReconnect((_) {
      print("🔄 SOCKET RECONNECTED");
    });

    socket!.onReconnectAttempt((attempt) {
      print("Reconnect Attempt => $attempt");
    });

    socket!.on("get_online_users", (data) {
      print("ONLINE USERS => $data");

      onlineUsers.clear();

      if (data is List) {
        onlineUsers.addAll(data.map((e) => e.toString()));
      }
    });

    socket!.onAny((event, data) {
      print("SOCKET EVENT => $event");
      print(data);

      final callbacks = _listeners[event];

      if (callbacks != null && callbacks.isNotEmpty) {
        for (final cb in List<Function(dynamic)>.from(callbacks)) {
          cb(data);
        }
      } else {
        print("NO LISTENER FOR => $event");

        pendingEvents[event] = data;
      }
    });

    socket!.connect();

    return this;
  }

  void onEvent(
      String event,
      Function(dynamic) callback,
      ) {

    _listeners.putIfAbsent(event, () => []);

    _listeners[event]!.add(callback);


    if(socket != null && socket!.connected){

      socket!.on(event, callback);

      print(
          "LISTENER ATTACHED => $event"
      );

    }


    if(pendingEvents.containsKey(event)){

      callback(
          pendingEvents[event]
      );

      pendingEvents.remove(event);

    }
  }

  void offEvent(String event, [Function(dynamic)? callback]) {
    if (!_listeners.containsKey(event)) return;

    if (callback == null) {
      _listeners.remove(event);
      socket?.off(event);
      return;
    }

    _listeners[event]!.remove(callback);

    socket?.off(event, callback);

    if (_listeners[event]!.isEmpty) {
      _listeners.remove(event);
    }
  }

  void emit(String event, dynamic data) {
    if (socket != null && socket!.connected) {
      socket!.emit(event, data);
    } else {
      print("❌ Socket not connected. Emit skipped => $event");
    }
  }

  bool get connected => socket?.connected ?? false;

  @override
  void onClose() {
    socket?.dispose();
    socket = null;
    _listeners.clear();
    super.onClose();
  }
}
