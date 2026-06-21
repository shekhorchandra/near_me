import 'package:dio/dio.dart';
import '../../user_chat_conversation/model/MessageModel.dart';

class ChatApiService {
  final Dio dio;

  ChatApiService(this.dio);

  static const baseUrl = "https://nearme-q02y.onrender.com/api/v1";

  /// GET CONVERSATIONS
  Future<List<dynamic>> getConversations(String token) async {
    final res = await dio.get(
      "$baseUrl/message/conversations",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (res.data['success'] == true) {
      return res.data['data'];
    }
    return [];
  }

  /// GET MESSAGES
  Future<List<MessageModel>> getMessages({
    required String token,
    required String userId,
  }) async {
    final response = await dio.get(
      "$baseUrl/message/$userId",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final List data = response.data['data'];

    return data.map((e) => MessageModel.fromJson(e)).toList();
  }

  /// SEND MESSAGE
  Future<MessageModel> sendMessage({
    required String token,
    required String receiverId,
    required String text,
  }) async {
    final response = await dio.post(
      "$baseUrl/message/send/$receiverId",
      data: FormData.fromMap({
        "text": text,
      }),
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return MessageModel.fromJson(
        response.data["data"],
      );
    }

    throw Exception("Failed to send message");
  }
}
