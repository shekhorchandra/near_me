import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/servicer_highlight_controller.dart';


class ServiceHighlightView extends GetView<ServiceHighlightController> {
  const ServiceHighlightView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Highlights"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.services.isEmpty) {
          return const Center(
            child: Text("No services available"),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.services.length,
          itemBuilder: (context, index) {
            final service = controller.services[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    service.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(service.title),
                subtitle: Text(service.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 18),
                    Text(service.rating.toString()),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}