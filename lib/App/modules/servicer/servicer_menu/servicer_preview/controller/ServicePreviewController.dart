import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/PreviewServiceDetailsModel.dart';
import '../view/PreviewServicePreviewProvider.dart';
import '../view/ServicePreviewProvider.dart';

class ServicePreviewController extends GetxController {
  final ServicePreviewProvider provider;

  ServicePreviewController(this.provider);

  RxBool loading = true.obs;

  final Rxn<PreviewServiceDetailsModel> service =
      Rxn<PreviewServiceDetailsModel>();

  Future<void> loadService(String id) async {
    try {
      loading(true);

      final result = await provider.getService(id);

      service(result);
    } finally {
      loading(false);
    }
  }

  Future<void> openMap() async {
    if (service.value == null) return;

    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${service.value!.latitude},${service.value!.longitude}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void onInit() {
    super.onInit();

    final id = Get.arguments;

    loadService(id);
  }
}
