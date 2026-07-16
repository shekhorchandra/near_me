import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/subscription_controller.dart';

class SubscriptionView extends GetView<SubscriptionController> {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Premium Plans")),

      body: Obx(
        () => ListView.builder(
          itemCount: controller.products.length,

          itemBuilder: (context, index) {
            final product = controller.products[index];

            return Card(
              child: ListTile(
                title: Text(product.title),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [Text(product.description), Text(product.price)],
                ),

                trailing: ElevatedButton(
                  child: Text("Subscribe"),

                  onPressed: () {
                    controller.buy(product);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
