import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:near_me/App/core/values/app_assets.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../routes/app_routes.dart';
import '../controller/servicer_dashboard_controller.dart';

class ServiceDashboardView extends GetView<ServiceDashboardController> {
  const ServiceDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Service Dashboard',
        showBack: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Profile Header
              Row(
                children: [
                  // Profile info
                  Expanded(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/150?img=3",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${controller.greeting.value} ${controller.userName.value}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "Welcome back!\nHere is your profile overview",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),

                  // Notification Icon with Badge
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          StorageService _storageService = StorageService();
                          final userId = _storageService.userId;

                          if (userId != null)
                            Get.toNamed(AppRoutes.NOTIFICATIONS, parameters: {"userId": userId});
                        },
                        icon: Icon(Icons.notifications),
                      ),
                      // Badge
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            "3", // Replace with dynamic count if needed
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Plan Info Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green.shade50,
                ),
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Row with Icon + Text
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          AppAssets.crown,
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(width: 8),

                        /// Wrap text with Expanded to avoid overflow
                        Expanded(
                          child: Text(
                            "You are currently using the ${controller.planName.value} (${controller.planPrice.value}). "
                                "Your plan renews on ${controller.renewDate.value}.",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// Upgrade Button
                    AppButton(
                      height: 30,
                      backgroundColor: Colors.green,
                      onPressed: () {},
                      text: 'Upgrade Plan',
                    )
                  ],
                )),
              ),

              const SizedBox(height: 12),

              /// Stats Cards Row
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      title: "Total Impressions",
                      value: controller.totalImpressions,
                      iconPath: AppAssets.impression,
                      color: Colors.grey[100]!,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      title: "Total Views",
                      value: controller.totalViews,
                      iconPath: AppAssets.views,
                      color: Colors.grey[100]!,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ///  Impression Overview
              _graphSection(
                title: "Impression Overview",
                selected: controller.selectedImpressionFilter,
                onChange: controller.changeImpressionFilter,
                data: controller.impressionData,
                onPrevious: () => controller.goToPrevious(controller.selectedImpressionFilter.value),
                onNext: () => controller.goToNext(controller.selectedImpressionFilter.value),
              ),

              const SizedBox(height: 20),

              _graphSection(
                title: "Views Overview",
                selected: controller.selectedViewsFilter,
                onChange: controller.changeViewsFilter,
                data: controller.viewsData,
                onPrevious: () => controller.goToPrevious(controller.selectedViewsFilter.value),
                onNext: () => controller.goToNext(controller.selectedViewsFilter.value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getInterval(String filter) {
    switch (filter) {
      case "Week":
        return 1;
      case "Month":
        return 3;
      case "Year":
        return 1;
      default:
        return 1;
    }
  }

  String _getBottomTitle(int index, String filter) {
    if (filter == "Week") {
      const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
      return index < days.length ? days[index] : "";
    } else if (filter == "Month") {
      return "${index + 1}";
    } else {
      const months = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
      ];
      return index < months.length ? months[index] : "";
    }
  }

  ///  Stat Card Widget
  Widget _statCard({
    required String iconPath,
    required String title,
    required RxInt value,
    Color color = const Color(0xFFF0F0F0), // default light grey
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row (title + image icon)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.grey,fontSize: 14,),
                  ),
                  Text(
                    value.value.toString(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Image.asset(
                iconPath,
                height: 22,
                width: 22,
              ),
            ],
          ),
        ],
      )),
    );
  }

  ///  Graph Section
  Widget _graphSection({
    required String title,
    required RxString selected,
    required Function(String) onChange,
    required RxList<double> data,
    required VoidCallback onPrevious,
    required VoidCallback onNext,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 10),

        ///  Filters
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ["Week", "Month", "Year"].map((e) {
            final isSelected = selected.value == e;
            return GestureDetector(
              onTap: () => onChange(e),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  e,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        )),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onPrevious,
                icon: const Icon(Icons.arrow_back_ios, size: 18),
              ),

              Obx(() => Text(
                controller.getDisplayRange(selected.value),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              )),

              IconButton(
                onPressed: onNext,                icon: const Icon(Icons.arrow_forward_ios, size: 18),
              ),

            ],
          ),
        ),



        const SizedBox(height: 12),



        /// Chart
        SizedBox(
          height: 220,
          child: Obx(() => LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                drawHorizontalLine: true,
                verticalInterval: _getInterval(selected.value),
                horizontalInterval: 50,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.shade300,
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.grey.shade300,
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Colors.black, width: 1),
                  bottom: BorderSide(color: Colors.black, width: 1),
                ),
              ),

              /// Axis Labels
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: _getInterval(selected.value),
                    getTitlesWidget: (value, meta) {
                      return Text(
                        _getBottomTitle(value.toInt(), selected.value),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 50, // adjust based on your data
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),

              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    data.length,
                        (i) => FlSpot(i.toDouble(), data[i]),
                  ),
                  isCurved: true,
                  barWidth: 3,
                  color: Colors.black, // Line color
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                          radius: 3,
                          color: Colors.grey, // Dot color
                          strokeWidth: 1,
                          strokeColor: Colors.black,
                        ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.shade100.withOpacity(0.3), // Gradient fill
                  ),
                ),
              ],
            ),
          )),
        ),
      ],
    );
  }
}