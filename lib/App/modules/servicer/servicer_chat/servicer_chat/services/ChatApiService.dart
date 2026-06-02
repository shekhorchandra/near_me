import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../user/chat/user_chat_conversation/model/MessageModel.dart';
import '../../servicer_chat_conversation/model/MessageModel.dart';

// class ServiceChatApiService {
//   final Dio dio;
//
//   ServiceChatApiService(this.dio);
//
//   Future<List<dynamic>> getConversations(String token) async {
//     final res = await dio.get(
//       'https://uncried-unpreventible-declan.ngrok-free.dev/api/v1/message/conversations',
//       options: Options(
//         headers: {
//           "Authorization": "Bearer $token",
//         },
//       ),
//     );
//
//     if (res.data['success'] == true) {
//       return res.data['data'];
//     } else {
//       return [];
//     }
//   }
//   Future<List<MessageModel>> getMessages({
//     required String token,
//     required String userId,
//   }) async {
//     final response = await dio.get(
//       'https://uncried-unpreventible-declan.ngrok-free.dev/api/v1/message/$userId',
//       queryParameters: {
//         "page": 1,
//         "limit": 10,
//       },
//       options: Options(
//         headers: {
//           "Authorization": "Bearer $token",
//         },
//       ),
//     );
//
//     final messages =
//     response.data['data']['messages'] as List;
//
//     return messages
//         .map((e) => MessageModel.fromJson(e))
//         .toList();
//   }
// }