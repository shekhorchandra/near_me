import 'package:get/get.dart';
import '../../../../services/contants/api_constants.dart';
import '../model/PreviewServiceDetailsModel.dart';


class ServicePreviewProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();

    httpClient.baseUrl = ApiConstants.baseUrl;
  }

  Future<PreviewServiceDetailsModel> getService(String id) async {
    final response = await get("/api/v1/service/details/$id");

    if (response.statusCode == 200) {
      return PreviewServiceDetailsModel.fromJson(response.body);
    }

    throw Exception(response.statusText ?? "Failed to load service");
  }
}