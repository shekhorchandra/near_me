import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import '../../../../../core/values/app_assets.dart';
import '../../../../../core/values/app_color.dart';
import '../controller/my_services_controller.dart';
import '../model/my_service_model.dart';


class MyServicesView
    extends GetView<MyServicesController> {
  const MyServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7F9),
      appBar: CommonAppBar(
        title: 'My Services',
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.services.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black,),
          );
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.services.isEmpty) {
          return _buildErrorState();
        }

        if (controller.services.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.refreshServices,
          child: Column(
            children: [
              _buildServiceCount(),

              Expanded(
                child: ListView.separated(
                  physics:
                  const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    4,
                    16,
                    24,
                  ),
                  itemCount:
                  controller.services.length,
                  separatorBuilder: (
                      context,
                      index,
                      ) {
                    return const SizedBox(
                      height: 12,
                    );
                  },
                  itemBuilder: (
                      context,
                      index,
                      ) {
                    final service =
                    controller.services[index];

                    return _buildServiceCard(
                      service,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: Obx(() {
        if (!controller.canAddService) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton.extended(
          onPressed: controller.createNewService,
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.white,
          icon: const Icon(
            Icons.add,
            size: 24,
          ),
          label: const Text(
            "Add Service",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildServiceCount() {
    return Obx(
          () => Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          12,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.business_center_outlined,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Created Services",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "${controller.services.length} "
                        "${controller.services.length == 1 ? "service" : "services"} found",
                    style: TextStyle(
                      color:
                      Colors.white.withOpacity(0.85),
                      fontSize: 13,
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

  Widget _buildServiceCard(MyServiceModel service) {
    final bool isActive =
        service.subscriptionStatus.trim().toLowerCase() == "active";

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          controller.editService(service);
        },
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildServiceLogo(service),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            service.serviceName.isNotEmpty
                                ? service.serviceName
                                : "Unnamed Service",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        _buildStatusBadge(isActive),
                      ],
                    ),

                    if (service.categoryName.isNotEmpty) ...[
                      const SizedBox(height: 7),
                      _buildInformationRow(
                        icon: Icons.category_outlined,
                        text: service.categoryName,
                      ),
                    ],

                    if (service.serviceAddress.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      _buildInformationRow(
                        icon: Icons.location_on_outlined,
                        text: service.serviceAddress,
                        maxLines: 2,
                      ),
                    ],

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber.shade700,
                          size: 19,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          service.averageRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const Spacer(),

                        const Icon(
                          Icons.edit_outlined,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(width: 4),

                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 13,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceLogo(
      MyServiceModel service,
      ) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: AppColor.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: service.companyLogo.isNotEmpty
            ? Image.network(
          service.companyLogo,
          fit: BoxFit.cover,
          loadingBuilder: (
              context,
              child,
              loadingProgress,
              ) {
            if (loadingProgress == null) {
              return child;
            }

            return const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              ),
            );
          },
          errorBuilder: (
              context,
              error,
              stackTrace,
              ) {
            return _buildFallbackLogo();
          },
        )
            : _buildFallbackLogo(),
      ),
    );
  }

  Widget _buildFallbackLogo() {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Image.asset(
        AppAssets.usercat,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildInformationRow({
    required IconData icon,
    required String text,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(
      bool isActive,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? "Active" : "Inactive",
        style: TextStyle(
          color: isActive
              ? Colors.green.shade700
              : Colors.orange.shade700,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: controller.refreshServices,
      child: ListView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height:
            Get.height * 0.65,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.business_center_outlined,
                      size: 70,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No Services Found",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You have not created any services yet.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: controller.refreshServices,
      child: ListView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: Get.height * 0.65,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 65,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Unable to Load Services",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                          () => Text(
                        controller
                            .errorMessage.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                          Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed:
                      controller.fetchMyServices,
                      icon:
                      const Icon(Icons.refresh),
                      label:
                      const Text("Try Again"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String value) {
    final text = value.trim();

    if (text.isEmpty) {
      return "";
    }

    return text[0].toUpperCase() +
        text.substring(1).toLowerCase();
  }
}