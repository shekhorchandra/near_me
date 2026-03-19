import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';

import '../controller/reviews_controller.dart';

class ReviewsView extends GetView<ReviewsController> {
  const ReviewsView({super.key});

  Widget ratingBar(int star, int count) {
    return Row(
      children: [
        Text(
          "$star Star",
          style: const TextStyle(color: Colors.black),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: LinearProgressIndicator(
            value: count / controller.totalReviews.value,
            minHeight: 8,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ),

        const SizedBox(width: 10),

        Text(
          "($count)",
          style: const TextStyle(color: Colors.black),
        )
      ],
    );
  }

  Widget reviewCard(Map review) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// USER INFO
          Row(
            children: [

              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(review["image"]),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      review["name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    Text(
                      review["time"],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),

              Row(
                children: List.generate(
                  review["rating"],
                      (index) => const Icon(
                    Icons.star,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          /// REVIEW TEXT
          Text(
            review["review"],
            style: const TextStyle(color: Colors.black87),
          ),

          const SizedBox(height: 10),

          /// ACTION BUTTONS

          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, color: Colors.black),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share, color: Colors.black),
              ),

              const Spacer(), // pushes the next widget to the right

              TextButton(
                onPressed: () {
                },
                style: TextButton.styleFrom(
                  // backgroundColor: const Color(0xFF555555),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'View Replies ➤',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget filterTabs() {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            controller.tabs.length,
                (index) {

              final selected = controller.selectedTab.value == index;

              return GestureDetector(
                onTap: () => controller.changeTab(index),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? Colors.black : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    controller.tabs[index],
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: const CommonAppBar(
        title: 'Service Reviews',
      ),
    
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
            
              /// TOTAL REVIEWS
              Align(
                alignment: Alignment.centerLeft,
                child: Obx(() => Text(
                  "Total Reviews (${controller.totalReviews})",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )),
              ),
            
              const SizedBox(height: 12),
            
              /// RATING BARS
              ratingBar(5, controller.ratingCount[5]!),
              const SizedBox(height: 6),
            
              ratingBar(4, controller.ratingCount[4]!),
              const SizedBox(height: 6),
            
              ratingBar(3, controller.ratingCount[3]!),
              const SizedBox(height: 6),
            
              ratingBar(2, controller.ratingCount[2]!),
              const SizedBox(height: 6),
            
              ratingBar(1, controller.ratingCount[1]!),
            
              const SizedBox(height: 16),
            
              /// FILTER TABS
              filterTabs(),
            
              const SizedBox(height: 10),
            
              /// REVIEW LIST
              Expanded(
                child: Obx(() {
            
                  final reviews = controller.filteredReviews;
            
                  return ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return reviewCard(reviews[index]);
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}