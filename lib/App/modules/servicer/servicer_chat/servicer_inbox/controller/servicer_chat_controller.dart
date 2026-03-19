import 'package:get/get.dart';
import '../model/servicer_chat_model.dart';

class ServicerChatController extends GetxController {

  var searchText = ''.obs;

  final chats = <ServicerChatModel>[
    ServicerChatModel(
      name: "John Doe",
      image: "https://i.pravatar.cc/150?img=1",
      lastMessage: "Hello! Are you available?",
      time: "5m ago",
      isOnline: true,
      unread: 2,
    ),
    ServicerChatModel(
      name: "Emma Watson",
      image: "https://i.pravatar.cc/150?img=2",
      lastMessage: "Let's meet tomorrow",
      time: "10m ago",
      isOnline: false,
      unread: 0,
    ),
    ServicerChatModel(
      name: "Alex Smith",
      image: "https://i.pravatar.cc/150?img=3",
      lastMessage: "Thanks!",
      time: "1h ago",
      isOnline: true,
      unread: 1,
    ),
  ].obs;

}