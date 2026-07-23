import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/values/app_assets.dart';
import '../../../../core/widgets/App_button.dart';
import '../../../../core/widgets/common_app_bar.dart';
import '../../../../data/network/dio_client.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../routes/app_routes.dart';
import '../../../services/contants/api_constants.dart';
import '../../notification/controllers/notification_controller.dart';
import '../controller/servicer_dashboard_controller.dart';
import 'dashboard_chart_item.dart';

class ServiceDashboardView extends GetView<ServiceDashboardController> {
  const ServiceDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Service Dashboard', showBack: false),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.fetchUserProfile,
          color: Colors.black,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                          Obx(() {
                            final planName = controller.planName.value;

                            return SizedBox(
                              width: 70,
                              height: 72,
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  const Positioned(
                                    top: 0,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        "https://cdn.vectorstock.com/i/500p/38/92/"
                                        "user-profile-icon-person-circle-figure-vector-62363892.jpg",
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 0,
                                    child: _profilePlanBadge(planName),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(
                              () => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "${controller.greeting.value} ${controller.userName.value}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      _planBadge(controller.planName.value),
                                    ],
                                  ),

                                  const SizedBox(height: 4),

                                  const Text(
                                    "Welcome back!\nHere is your profile overview",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Notification Icon with Badge
                    Obx(() {
                      final unread =
                          controller.notificationController.unreadCount.value;

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () {
                              final token = StorageService().accessToken;

                              if (token == null || token.isEmpty) {
                                Get.snackbar(
                                  "Login Required",
                                  "Please login first.",
                                );
                                return;
                              }

                              final userId = StorageService().userId;

                              Get.toNamed(
                                AppRoutes.NOTIFICATIONS,
                                parameters: {"userId": userId ?? ""},
                              );
                            },
                            icon: const Icon(Icons.notifications),
                          ),

                          if (unread > 0)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    unread > 99 ? "99+" : unread.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
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
                  child: Obx(
                    () => Column(
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
                                controller.subscriptionMessage,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// Upgrade Button
                        AppButton(
                          height: 30,
                          backgroundColor: Colors.green,
                          onPressed: () {
                            Get.toNamed(AppRoutes.SERVICE_CHOOSE_PLAN);
                          },
                          text: 'Upgrade Plan',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// Stats Cards Row
                Obx(() {
                  if (controller.isProfileLoading.value) {
                    return const SizedBox(
                      height: 90,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      ),
                    );
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: _lockedAnalyticsPart(
                          isLocked: controller.shouldLockImpressions,
                          message: "Upgrade your plan to see impressions",
                          child: _statCard(
                            title: "Total Impressions",
                            value: controller.totalImpressions,
                            iconPath: AppAssets.impression,
                            color: Colors.grey[100]!,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _lockedAnalyticsPart(
                          isLocked: controller.shouldLockViews,
                          message: "Upgrade your plan to see views",
                          child: _statCard(
                            title: "Total Views",
                            value: controller.totalViews,
                            iconPath: AppAssets.views,
                            color: Colors.grey[100]!,
                          ),
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 20),

                /// Impression Overview
                Obx(
                  () => _lockedAnalyticsPart(
                    isLocked: controller.shouldLockImpressions,
                    message: "Upgrade your plan to unlock impression analytics",
                    child: _graphSection(
                      title: "Impression Overview",
                      selected: controller.selectedImpressionFilter,
                      onChange: controller.changeImpressionFilter,
                      data: controller.impressionChart,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Obx(
                  () => _lockedAnalyticsPart(
                    isLocked: controller.shouldLockViews,
                    message: "Upgrade your plan to unlock views analytics",
                    child: _graphSection(
                      title: "Views Overview",
                      selected: controller.selectedViewsFilter,
                      onChange: controller.changeViewsFilter,
                      data: controller.viewChart,
                    ),
                  ),
                ),
              ],
            ),
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

  double _calculateMaxY(double highestValue) {
    if (highestValue <= 10) {
      return 10;
    }

    return (highestValue * 1.25).ceilToDouble();
  }

  double _calculateHorizontalInterval(double maxY) {
    if (maxY <= 10) {
      return 2;
    }

    if (maxY <= 50) {
      return 10;
    }

    if (maxY <= 100) {
      return 20;
    }

    return (maxY / 5).ceilToDouble();
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
      child: Obx(
        () => Column(
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
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
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
                Image.asset(iconPath, height: 22, width: 22),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///  Graph Section
  Widget _lockedAnalyticsPart({
    required bool isLocked,
    required String message,
    required Widget child,
  }) {
    if (!isLocked) {
      return child;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            ignoring: true,
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Opacity(opacity: 0.55, child: child),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.45)),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 26),
                const SizedBox(height: 6),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _planBadge(String planName) {
    final plan = planName.trim().toLowerCase();

    late final String label;
    late final Color backgroundColor;
    late final Color textColor;
    late final IconData icon;

    switch (plan) {
      case 'elite':
        label = 'ELITE';
        backgroundColor = const Color(0xFFFFE8A3);
        textColor = const Color(0xFF8A6200);
        icon = Icons.workspace_premium_rounded;
        break;

      case 'pro':
        label = 'PRO';
        backgroundColor = const Color(0xFFE3D9FF);
        textColor = const Color(0xFF5F36B5);
        icon = Icons.diamond_rounded;
        break;

      case 'basic':
        label = 'BASIC';
        backgroundColor = const Color(0xFFE5E7EB);
        textColor = const Color(0xFF4B5563);
        icon = Icons.verified_outlined;
        break;

      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _graphSection({
    required String title,
    required RxString selected,
    required Future<void> Function(String) onChange,
    required RxList<DashboardChartItem> data,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 10),

        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ["Week", "Month", "Year"].map((filter) {
              final isSelected = selected.value == filter;
              final isLoading = controller.isAnalyticsLoading.value;

              return GestureDetector(
                onTap: isLoading
                    ? null
                    : () {
                        onChange(filter);
                      },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        Obx(() {
          if (controller.isAnalyticsLoading.value) {
            return const SizedBox(
              height: 220,
              child: Center(
                child: CircularProgressIndicator(color: Colors.black),
              ),
            );
          }

          final List<DashboardChartItem> chartData =
              List<DashboardChartItem>.from(data);

          if (chartData.isEmpty) {
            return const SizedBox(
              height: 220,
              child: Center(child: Text("No analytics data available")),
            );
          }

          double highestValue = 0;

          for (final item in chartData) {
            if (item.count > highestValue) {
              highestValue = item.count;
            }
          }

          final maxY = _calculateMaxY(highestValue);
          final horizontalInterval = _calculateHorizontalInterval(maxY);

          return SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (chartData.length - 1).toDouble(),
                minY: 0,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  verticalInterval: _getInterval(selected.value),
                  horizontalInterval: horizontalInterval,
                  getDrawingHorizontalLine: (_) {
                    return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
                  },
                  getDrawingVerticalLine: (_) {
                    return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(color: Colors.black),
                    bottom: BorderSide(color: Colors.black),
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _getInterval(selected.value),
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();

                        if (value != index.toDouble() ||
                            index < 0 ||
                            index >= chartData.length) {
                          return const SizedBox.shrink();
                        }

                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            chartData[index].label,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: horizontalInterval,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 11),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      chartData.length,
                      (index) =>
                          FlSpot(index.toDouble(), chartData[index].count),
                    ),
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.black,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: Colors.grey,
                          strokeWidth: 1,
                          strokeColor: Colors.black,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.shade100.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _profilePlanBadge(String value) {
    final planName = value.trim().toLowerCase();

    String title;
    Color backgroundColor;
    Color textColor;
    IconData icon;

    if (planName.contains('free')) {
      title = 'FREE';
      backgroundColor = const Color(0xFFE8F5E9);
      textColor = const Color(0xFF2E7D32);
      icon = Icons.card_giftcard_rounded;
    } else if (planName.contains('elite')) {
      title = 'ELITE';
      backgroundColor = const Color(0xFFFFC107);
      textColor = Colors.black;
      icon = Icons.workspace_premium_rounded;
    } else if (planName.contains('pro')) {
      title = 'PRO';
      backgroundColor = const Color(0xFF7C3AED);
      textColor = Colors.white;
      icon = Icons.diamond_rounded;
    } else if (planName.contains('basic')) {
      title = 'BASIC';
      backgroundColor = const Color(0xFF6B7280);
      textColor = Colors.white;
      icon = Icons.verified_rounded;
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: textColor),
          const SizedBox(width: 3),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
