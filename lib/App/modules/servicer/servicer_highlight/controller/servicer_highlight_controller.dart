import 'package:get/get.dart';
import '../model/servicer_highlight_model.dart';

class ServiceHighlightController extends GetxController {
  var isLoading = false.obs;

  final services = <ServiceHighlightModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStaticServices();
  }

  void loadStaticServices() {
    isLoading.value = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      services.assignAll([
        ServiceHighlightModel(
          title: "Home Cleaning",
          description: "Professional home cleaning service",
          image: "https://via.placeholder.com/150",
          rating: 4.5,
        ),
        ServiceHighlightModel(
          title: "AC Repair",
          description: "Fast and reliable AC repair",
          image: "https://via.placeholder.com/150",
          rating: 4.2,
        ),
        ServiceHighlightModel(
          title: "Plumbing",
          description: "Expert plumbing solutions",
          image: "https://via.placeholder.com/150",
          rating: 4.7,
        ),
      ]);

      isLoading.value = false;
    });
  }
}