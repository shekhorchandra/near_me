import 'package:get/get.dart';
import '../../../../../data/services/socket_service.dart';
import '../../../../../data/services/storage_service.dart';
import '../model/chat_model.dart';
import '../services/ChatApiService.dart';

class ChatController extends GetxController {
  final ChatApiService apiService;

  ChatController({required this.apiService});

  final isLoading = false.obs;
  final chats = <ChatModel>[].obs;

  final RxBool isLoggedIn = false.obs;
  final isLoginRequired = false.obs;

  SocketService? socketService;

  final storage = StorageService();


  @override
  void onInit() {
    super.onInit();

    checkLoginStatus();

    if (isLoggedIn.value) {
      fetchChats();
    } else {

    }


    if (Get.isRegistered<SocketService>()) {
      socketService = Get.find<SocketService>();
    }
  }


  void checkLoginStatus() {
    final token = storage.accessToken;

    print("LOGIN TOKEN => $token");

    isLoggedIn.value = token != null && token.isNotEmpty;
  }


  bool isUserOnline(String userId) {
    if (socketService == null) return false;

    return socketService!.onlineUsers.contains(userId);
  }


  Future<void> fetchChats() async {
    try {
      isLoading.value = true;

      final token = storage.accessToken;

      print("CHAT TOKEN => $token");

      if (token == null || token.isEmpty) {

        return;
      }


      final data = await apiService.getConversations(token);

      chats.value = data
          .map((e) => ChatModel.fromJson(e))
          .toList();


    } catch (e) {
      print("❌ Chat API error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
