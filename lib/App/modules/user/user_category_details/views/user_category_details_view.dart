import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../routes/app_routes.dart';
import '../../user_category_service_details/models/ReviewModel.dart';
import '../controller/user_category_details_controller.dart';

class UserCategoryDetailsView extends GetView<UserCategoryDetailsController> {
  const UserCategoryDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final filterOptions = {
      'Rating': ['Rating', "All", '5', '4+', '3+'],
      'Radius': ['Radius', "All", '1km', '3km', '5km'],
      'Availability': ['Availability', "All", 'Available', 'Busy'],
    };
    final args = Get.arguments as Map<String, dynamic>?;

    final categoryName = args != null && args['name'] != null
        ? args['name'] as String
        : 'Category Details';

    return Scaffold(
      appBar: CommonAppBar(title: categoryName),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Search bar
            CustomTextField(
              onChanged: (value) => controller.searchText.value = value,
              hint: 'Search services...',
              icon: Icons.search,
            ),
            const SizedBox(height: 10),

            // Dropdown filters
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Rating
                  DropdownButton<String>(
                    value: controller.selectedRating.value,
                    items: filterOptions['Rating']!
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => controller.selectedRating.value = v!,
                  ),
                  // Radius
                  DropdownButton<String>(
                    value: controller.selectedRadius.value,
                    items: filterOptions['Radius']!
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => controller.selectedRadius.value = v!,
                  ),
                  // Availability
                  DropdownButton<String>(
                    value: controller.selectedAvailability.value,
                    items: filterOptions['Availability']!
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => controller.selectedAvailability.value = v!,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // align top
                children: [
                  /// Left column: filters
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      color: Colors.grey.shade100,
                      child: Obx(
                        () => SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Plumbing dropdown
                              ExpansionTile(
                                title: const Text(
                                  'Plumbing',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                initiallyExpanded: false,
                                children: controller.plumbingOptions.keys.map((option) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: controller.plumbingOptions[option],
                                        onChanged: (v) => controller.plumbingOptions[option] = v!,
                                      ),
                                      Expanded(child: Text(option, softWrap: true)),
                                    ],
                                  );
                                }).toList(),
                              ),

                              // Electrical dropdown
                              ExpansionTile(
                                title: const Text(
                                  'Electrical',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                initiallyExpanded: false,
                                children: controller.electricalOptions.keys.map((option) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: controller.electricalOptions[option],
                                        onChanged: (v) => controller.electricalOptions[option] = v!,
                                      ),
                                      Expanded(child: Text(option, softWrap: true)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// Right column: services
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        itemCount: controller.filteredServices.length,
                        itemBuilder: (context, index) {
                          final service = controller.filteredServices[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    service.image,
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          service.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.black, size: 18),
                                      Text(service.rating.toString()),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 16, color: Colors.black),
                                      const SizedBox(width: 4),
                                      Text('${service.distance} km'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule, size: 16, color: Colors.black),
                                      const SizedBox(width: 4),
                                      Text(service.schedule),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_city,
                                        size: 16,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(service.location),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: AppButton(
                                      width: double.infinity,
                                      height: 35,
                                      onPressed: () {
                                        Get.toNamed(
                                          AppRoutes.SERVICE_DETAILS,
                                          arguments: {
                                            'image': service.image,
                                            'title': service.title,
                                            'category': service.category,
                                            'rating': service.rating,
                                            'schedule': service.schedule,
                                            'location': service.location,
                                            'about': service.about,

                                            // MUST BE LIST
                                            'servicesOffered': [
                                              'Accounting & Finance Services',
                                              'Home Services',
                                              'Education & Tutoring',
                                              'Specialist Services',
                                            ],

                                            // MUST BE LIST
                                            'highlights': [
                                              'assets/images/trade&service.png',
                                              'assets/images/trade&service.png',
                                              'assets/images/trade&service.png',
                                              'assets/images/trade&service.png',
                                            ],

                                            // MUST BE LIST OF ReviewModel
                                            'reviews': [
                                              ReviewModel(
                                                userName: 'Haris',
                                                userImage: 'assets/images/trade&service.png',
                                                review:
                                                    'Excellent service! Blissful Spa was prompt, professional, and fixed everything perfectly.',
                                                daysAgo: 2,
                                              ),
                                            ],
                                          },
                                        );
                                      },
                                      text: 'View Details',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
