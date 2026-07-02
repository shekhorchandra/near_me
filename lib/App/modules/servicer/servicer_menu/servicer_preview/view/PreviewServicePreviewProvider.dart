import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/modules/servicer/servicer_menu/servicer_preview/model/PreviewServiceDetailsModel.dart';
import 'package:near_me/App/modules/user/category/user_category_service_details/models/ReviewModel.dart';
import '../../../../../routes/app_routes.dart';
import '../controller/ServicePreviewController.dart';
import '../model/PreviewReviewModel.dart';

class ServicePreviewView extends GetView<ServicePreviewController> {
  const ServicePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.black,));
        }

        final service = controller.service.value!;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Banner Image
                  SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: CarouselSlider.builder(
                      itemCount: service.media.length,
                      itemBuilder: (_, index, __) {
                        return Image.network(
                          service.media[index],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                      options: CarouselOptions(
                        viewportFraction: 1,
                        autoPlay: true,
                      ),
                    ),
                  ),

                  // Floating Card
                  Container(
                    margin: const EdgeInsets.only(top: 180),
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(28),
                          topRight: Radius.circular(28),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 22, 16, 30),
                        child: Column(
                          children: [
                            _providerCard(service),

                            _about(service),

                            _offeredServices(service),

                            _highlights(service),

                            _locationCard(service),

                            _reviewsSection(service),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _providerCard(service) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(.15), blurRadius: 12),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          CircleAvatar(radius: 30, backgroundImage: NetworkImage(service.logo)),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  service.serviceName,

                  style: const TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  service.providerName,

                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),

                    const SizedBox(width: 4),

                    Text(
                      service.rating.toString(),

                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(width: 15),

                    Icon(
                      service.isOpen ? Icons.circle : Icons.circle,

                      size: 10,

                      color: service.isOpen ? Colors.green : Colors.red,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      service.isOpen ? "Open" : "Closed",

                      style: TextStyle(
                        color: service.isOpen ? Colors.green : Colors.red,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      "${service.openingTime} - ${service.closingTime}",

                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _about(service) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(8),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "About",

            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          const SizedBox(height: 12),

          Text(
            service.about,

            style: TextStyle(height: 1.6, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _offeredServices(service) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Services Offered",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: service.offeredServices.map<Widget>((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300, width: .8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home_repair_service_outlined,
                      size: 13,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 5),

                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _highlights(service) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
            child: const Text(
              "Service Highlights",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            itemCount: service.highlights.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.90,
            ),
            itemBuilder: (_, index) {
              return _highlightCard(service.highlights[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _highlightCard(item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: .6),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: Image.network(
              item.image,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    item.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationCard(PreviewServiceDetailsModel service) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Location",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          const SizedBox(height: 15),

          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 220,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(service.latitude, service.longitude),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId("service_location"),
                    position: LatLng(service.latitude, service.longitude),
                    infoWindow: InfoWindow(
                      title: service.serviceName,
                      snippet: service.address,
                    ),
                  ),
                },
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                compassEnabled: false,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(child: Text(service.address)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reviewsSection(PreviewServiceDetailsModel service) {
    final reviews = service.reviews;
    final showReviews = reviews.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Reviews",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                service.rating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(" (${service.totalReviews})"),
            ],
          ),

          const SizedBox(height: 20),

          if (reviews.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text("No Reviews Yet"),
              ),
            )
          else
            ...showReviews.map(
              (review) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _reviewCard(review),
              ),
            ),

          if (reviews.length > 2)
            Center(
              child: AppButton(
                onPressed: () {
                  Get.toNamed(
                    AppRoutes.REVIEWS,
                    arguments: {"serviceId": service.id, "preview": true},
                  );
                },
                text: 'View All Reviews',
              ),
            ),
        ],
      ),
    );
  }

  Widget _reviewCard(ReviewModel review) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          child: Text(
            review.userName.isNotEmpty ? review.userName[0].toUpperCase() : "?",
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 4),

              _ratingStars(review.rating),

              const SizedBox(height: 8),

              Text(
                review.comment,
                style: TextStyle(color: Colors.grey.shade700, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ratingStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,

          color: Colors.amber,

          size: 18,
        );
      }),
    );
  }
}
