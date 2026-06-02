import 'package:get/get.dart';
import '../../../../../data/services/socket_service.dart';
import '../../../../../data/services/storage_service.dart';
import '../model/chat_model.dart';
import '../services/ChatApiService.dart';

class ChatController extends GetxController {
  final ChatApiService apiService;

  ChatController({required this.apiService});

  var isLoading = false.obs;
  final chats = <ChatModel>[].obs;
  final socketService = Get.find<SocketService>();

  bool isUserOnline(String userId) {
    return socketService.onlineUsers.contains(userId);
  }

  final storage = StorageService();

  @override
  void onInit() {
    super.onInit();
    fetchChats();
  }

  Future<void> fetchChats() async {
    try {
      isLoading.value = true;

      final token = storage.accessToken;

      print("🔐 TOKEN: $token"); // DEBUG

      if (token == null || token.isEmpty) {
        print("❌ Token missing");
        return;
      }

      final data = await apiService.getConversations(token);

      chats.value =
          data.map((e) => ChatModel.fromJson(e)).toList();
    } catch (e) {
      print("❌ Chat API error: $e");
    } finally {
      isLoading.value = false;
    }
  }

}

