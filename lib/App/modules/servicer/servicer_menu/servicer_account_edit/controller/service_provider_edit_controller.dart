// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../../../../data/services/storage_service.dart';
// import '../../../../auth/service/servicer_account/models/category_model.dart';
// import '../../../../services/contants/api_service.dart';
//
// class ServiceProviderEditController extends GetxController {
//   final ApiService apiService = ApiService();
//   final ImagePicker _picker = ImagePicker();
//
//   // ================= TEXT CONTROLLERS =================
//   final serviceNameController = TextEditingController();
//   final contactController = TextEditingController();
//   final aboutController = TextEditingController();
//   final addressController = TextEditingController();
//   final websiteController = TextEditingController();
//   final customServiceController = TextEditingController();
//
//   // ================= FOCUS =================
//   final serviceNameFocus = FocusNode();
//   final contactFocus = FocusNode();
//   final aboutFocus = FocusNode();
//   final addressFocus = FocusNode();
//   final websiteFocus = FocusNode();
//
//   // ================= EDIT FLAGS =================
//   final isServiceNameEditable = false.obs;
//   final isContactEditable = false.obs;
//   final isAboutEditable = false.obs;
//   final isAddressEditable = false.obs;
//   final isWebsiteEditable = false.obs;
//
//   // ================= CATEGORY =================
//   final categories = <Category>[].obs;
//   final services = <Category>[].obs;
//
//   final selectedCategory = Rxn<Category>();
//   final selectedCategoryId = ''.obs;
//
//   // ================= SERVICES =================
//   final selectedServices = <Category>[].obs;
//   final selectedServiceIds = <String>[].obs;
//
//   // ================= MEDIA =================
//   final images = <String>[].obs;
//   final logo = ''.obs;
//
//   // ================= TIME =================
//   final openingTime = const TimeOfDay(hour: 8, minute: 0).obs;
//   final closingTime = const TimeOfDay(hour: 17, minute: 0).obs;
//   final isOpen24_7 = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchServiceDetails();
//     // fetchAllServices(); // 🔥 IMPORTANT ADD
//   }
//
//   // ================= GET ALL SERVICES (FIX) =================
//   // Future<void> fetchAllServices() async {
//   //   try {
//   //     // 🔥 CHANGE THIS URL TO YOUR REAL API
//   //     const url =
//   //         "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/services";
//   //
//   //     final res = await apiService.getRequest(url);
//   //     final data = jsonDecode(res.body);
//   //
//   //     if (res.statusCode == 200 && data['success'] == true) {
//   //       final list = data['data'] as List;
//   //
//   //       services.assignAll(
//   //         list.map((e) => Category.fromJson(e)).toList(),
//   //       );
//   //     }
//   //   } catch (e) {
//   //     Get.snackbar("Error", e.toString());
//   //   }
//   // }
//
//   // ================= FETCH API =================
//   Future<void> fetchServiceDetails() async {
//     try {
//       final serviceId = StorageService().serviceId;
//
//       final url =
//           "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/service/$serviceId";
//
//       final res = await apiService.getRequest(url);
//       final data = jsonDecode(res.body);
//
//       if (res.statusCode == 200 && data['success'] == true) {
//         setServiceData(data['data']);
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }
//
//   void addCustomService() {
//     final value = customServiceController.text.trim();
//
//     if (value.isEmpty) return;
//
//     Get.snackbar("Custom Service", value);
//     customServiceController.clear();
//   }
//
//   // ================= BIND API DATA =================
//   void setServiceData(Map<String, dynamic> data) {
//     // ================= SERVICE NAME
//     serviceNameController.text = data['service_name'] ?? '';
//
//     // ================= CONTACT
//     contactController.text = (data['phone'] ?? '').toString();
//
//     // ================= ABOUT
//     aboutController.text = data['about'] ?? '';
//
//     // ================= ADDRESS
//     addressController.text = data['service_address'] ?? '';
//
//     // ================= WEBSITE
//     websiteController.text = data['website_link'] ?? '';
//
//     // ================= CATEGORY (SAFE)
//     final cat = data['service_category'];
//     if (cat != null) {
//       selectedCategory.value = Category.fromJson(cat);
//       selectedCategoryId.value = selectedCategory.value?.id ?? '';
//     }
//
//     // ================= SERVICES (SAFE)
//     selectedServices.clear();
//     selectedServiceIds.clear();
//
//     final offer = data['offer_services'];
//
//     if (offer is List) {
//       for (var s in offer) {
//         final service = Category.fromJson(s);
//
//         selectedServices.add(service);
//         selectedServiceIds.add(service.id);
//       }
//     }
//
//     // ================= MEDIA PICKER =================
//     Future<void> pickImage(ImageSource source) async {
//       final file = await _picker.pickImage(source: source);
//
//       if (file != null && images.length < 3) {
//         images.add(file.path);
//       }
//     }
//
// // remove image (FIX)
//     void removeImage(int index) {
//       if (index >= 0 && index < images.length) {
//         images.removeAt(index);
//       }
//     }
//
// // set logo (FIX)
//     Future<void> setLogo() async {
//       final file = await _picker.pickImage(source: ImageSource.gallery);
//
//       if (file != null) {
//         logo.value = file.path;
//       }
//     }
//
//     // ================= MEDIA
//     images.assignAll(List<String>.from(data['media'] ?? []));
//
//     // ================= LOGO
//     logo.value = data['company_logo'] ?? '';
//
//
//     // ================= TIME =================
//     void parseTime(String? time, Rx<TimeOfDay> target) {
//       if (time == null) return;
//       final p = time.split(":");
//       if (p.length == 2) {
//         target.value = TimeOfDay(
//           hour: int.parse(p[0]),
//           minute: int.parse(p[1]),
//         );
//       }
//     }
//
//     parseTime(data['openingTime'], openingTime);
//     parseTime(data['closingTime'], closingTime);
//
//     isOpen24_7.value = data['allTimeAvailability'] ?? false;
//   }
//
//   // ================= CATEGORY =================
//   // void selectCategory(String id) {
//   //   selectedCategoryId.value = id;
//   // }
//
//   // ================= TOGGLE =================
//   void toggleService(String id) {
//     if (selectedServiceIds.contains(id)) {
//       selectedServiceIds.remove(id);
//       selectedServices.removeWhere((e) => e.id == id);
//     } else {
//       if (selectedServiceIds.length >= 5) {
//         Get.snackbar("Limit", "Max 5 services allowed");
//         return;
//       }
//
//       selectedServiceIds.add(id);
//
//       final match = services.firstWhereOrNull((e) => e.id == id);
//       if (match != null) {
//         selectedServices.add(match);
//       }
//     }
//   }
//   }
//
//   // ================= MEDIA =================
//   Future<void> pickImage(ImageSource source) async {
//     final file = await _picker.pickImage(source: source);
//     if (file != null && images.length < 3) {
//       images.add(file.path);
//     }
//   }
//
//   void removeImage(int index) => images.removeAt(index);
//
//   Future<void> setLogo() async {
//     final file = await _picker.pickImage(source: ImageSource.gallery);
//     if (file != null) logo.value = file.path;
//   }
//
//   // ================= TIME =================
//   void setOpeningTime(TimeOfDay t) => openingTime.value = t;
//   void setClosingTime(TimeOfDay t) => closingTime.value = t;
// }

//
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart' hide FormData, MultipartFile;
// import 'package:image_picker/image_picker.dart';
//
// import '../models/service_provider_edit_model.dart';
// class ServiceEditController extends GetxController {
//   final Dio dio = Dio();
//
//   final isLoading = false.obs;
//   final isUpdating = false.obs;
//
//   final serviceId = "69de1a95a5ec7a39149bf172";
//
//   // SERVICE DATA
//   final service = Rxn();
//
//   // SELECTED VALUES
//   final selectedCategoryId = "".obs;
//   final selectedOfferServices = <String>[].obs;
//
//   // TREE DATA
//   final categoryTree = <CategoryNode>[].obs;
//
//   // FORM
//   final nameCtrl = TextEditingController();
//   final addressCtrl = TextEditingController();
//   final aboutCtrl = TextEditingController();
//   final websiteCtrl = TextEditingController();
//   final openingCtrl = TextEditingController();
//   final closingCtrl = TextEditingController();
//
//   // IMAGES
//   File? logoFile;
//   List<File> mediaFiles = [];
//   final picker = ImagePicker();
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     fetchCategoryTree();
//     fetchService(serviceId, "YOUR_TOKEN");
//   }
//
//   // ================= CATEGORY TREE API =================
//   Future<void> fetchCategoryTree() async {
//     try {
//       final res = await dio.get(
//         "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/category/tree",
//         options: Options(headers: {
//           "accesstoken": "YOUR_TOKEN",
//         }),
//       );
//
//       final data = res.data['data'] as List;
//
//       categoryTree.value =
//           data.map((e) => CategoryNode.fromJson(e)).toList();
//
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }
//
//   // ================= SERVICE GET API =================
//   Future<void> fetchService(String id, String token) async {
//     try {
//       isLoading.value = true;
//
//       final res = await dio.get(
//         "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/service/$id",
//         options: Options(headers: {"accesstoken": token}),
//       );
//
//       final data = res.data['data'];
//
//       service.value = data;
//
//       selectedCategoryId.value =
//           data['service_category']?['_id'] ?? "";
//
//       selectedOfferServices.value =
//           (data['offer_services'] as List)
//               .map((e) => e['_id'].toString())
//               .toList();
//
//       nameCtrl.text = data['service_name'] ?? "";
//       addressCtrl.text = data['service_address'] ?? "";
//       aboutCtrl.text = data['about'] ?? "";
//       websiteCtrl.text = data['website_link'] ?? "";
//       openingCtrl.text = data['openingTime'] ?? "";
//       closingCtrl.text = data['closingTime'] ?? "";
//
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ================= CATEGORY SELECT =================
//   void selectCategory(String id) {
//     selectedCategoryId.value = id;
//   }
//
//   // ================= OFFER SERVICES TOGGLE =================
//   void toggleOfferService(String id) {
//     if (selectedOfferServices.contains(id)) {
//       selectedOfferServices.remove(id);
//     } else {
//       selectedOfferServices.add(id);
//     }
//   }
//
//   // ================= LOGO =================
//   Future<void> pickLogo() async {
//     final x = await picker.pickImage(source: ImageSource.gallery);
//     if (x != null) {
//       logoFile = File(x.path);
//       update();
//     }
//   }
//
//   // ================= MEDIA =================
//   Future<void> pickMedia() async {
//     if (mediaFiles.length >= 3) {
//       Get.snackbar("Limit", "Only 3 images allowed");
//       return;
//     }
//
//     final x = await picker.pickImage(source: ImageSource.gallery);
//     if (x != null) {
//       mediaFiles.add(File(x.path));
//       update();
//     }
//   }
//
//   void removeMedia(int index) {
//     mediaFiles.removeAt(index);
//     update();
//   }
//
//   // ================= PATCH UPDATE =================
//   Future<void> updateServiceApi(String token) async {
//     try {
//       isUpdating.value = true;
//
//       final formData = FormData();
//
//       formData.fields.addAll([
//         MapEntry("service_name", nameCtrl.text),
//         MapEntry("service_category", selectedCategoryId.value),
//         MapEntry("service_address", addressCtrl.text),
//         MapEntry("about", aboutCtrl.text),
//         MapEntry("website_link", websiteCtrl.text),
//         MapEntry("openingTime", openingCtrl.text),
//         MapEntry("closingTime", closingCtrl.text),
//         MapEntry("allTimeAvailability", "false"),
//       ]);
//
//       // location
//       formData.fields.add(
//         MapEntry(
//           "location",
//           '{"type":"Point","coordinates":[90.4125,23.8103]}',
//         ),
//       );
//
//       // offer services
//       for (var id in selectedOfferServices) {
//         formData.fields.add(
//           MapEntry("offer_services[]", id),
//         );
//       }
//
//       // logo
//       if (logoFile != null) {
//         formData.files.add(
//           MapEntry(
//             "company_logo",
//             await MultipartFile.fromFile(logoFile!.path),
//           ),
//         );
//       }
//
//       // media
//       for (var file in mediaFiles) {
//         formData.files.add(
//           MapEntry(
//             "media",
//             await MultipartFile.fromFile(file.path),
//           ),
//         );
//       }
//
//       final res = await dio.patch(
//         "YOUR_BASE_URL/api/v1/service/$serviceId",
//         data: formData,
//         options: Options(headers: {
//           "accesstoken": token,
//           "Content-Type": "multipart/form-data",
//         }),
//       );
//
//       if (res.data['success'] == true) {
//         Get.snackbar("Success", "Updated successfully");
//         fetchService(serviceId, token);
//       }
//
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isUpdating.value = false;
//     }
//   }
//
//   // ================= TREE CHECK HELP =================
//   bool isSelected(String id) {
//     return selectedCategoryId.value == id ||
//         selectedOfferServices.contains(id);
//   }
// }
//-------------------------------------------------------------------------------------------------------
// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart' hide FormData, MultipartFile;
// import 'package:image_picker/image_picker.dart';
//
// import '../../../../../data/services/storage_service.dart';
// import '../models/category_model.dart';
//
// class ServiceProviderEditController extends GetxController {
//   final Dio dio = Dio();
//   final picker = ImagePicker();
//   final storage = StorageService();
//
//   final isLoading = false.obs;
//   final isUpdating = false.obs;
//
//   final nameCtrl = TextEditingController();
//   final contactCtrl = TextEditingController();
//   final addressCtrl = TextEditingController();
//   final aboutCtrl = TextEditingController();
//   final websiteCtrl = TextEditingController();
//   final openingCtrl = TextEditingController();
//   final closingCtrl = TextEditingController();
//
//   final categoryTree = <Category>[].obs;
//
//   final selectedCategoryId = ''.obs;
//   final selectedOfferServices = <String>[].obs;
//
//   final logoUrl = ''.obs;
//   final mediaUrls = <String>[].obs;
//
//   File? logoFile;
//   List<File> mediaFiles = [];
//
//   final serviceId = StorageService().serviceId;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadAll();
//   }
//
//   Future<void> loadAll() async {
//     await fetchCategoryTree();
//     await fetchService();
//   }
//
//   // ================= CATEGORY TREE =================
//   Future<void> fetchCategoryTree() async {
//     try {
//       final res = await dio.get(
//         "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/category/tree",
//         options: Options(headers: {"accesstoken": storage.accessToken}),
//       );
//
//       final data = res.data['data'] as List;
//
//       categoryTree.value = data.map((e) => Category.fromJson(e)).toList();
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }
//
//   // ================= SERVICE =================
//   // Future<void> fetchService() async {
//   //   try {
//   //     isLoading.value = true;
//   //
//   //     final res = await dio.get(
//   //       "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/service/$serviceId",
//   //       options: Options(headers: {"accesstoken": storage.accessToken}),
//   //     );
//   //
//   //     final data = res.data['data'];
//   //
//   //     nameCtrl.text = data['service_name'] ?? '';
//   //     contactCtrl.text = data['phone']?.toString() ?? '';
//   //     addressCtrl.text = data['service_address'] ?? '';
//   //     aboutCtrl.text = data['about'] ?? '';
//   //     websiteCtrl.text = data['website_link'] ?? '';
//   //     openingCtrl.text = data['openingTime'] ?? '';
//   //     closingCtrl.text = data['closingTime'] ?? '';
//   //
//   //     selectedCategoryId.value = data['service_category']?['_id'] ?? '';
//   //
//   //     selectedOfferServices.value =
//   //         (data['offer_services'] as List?)?.map((e) => e['_id'].toString()).toList() ?? [];
//   //
//   //     mediaUrls.value = (data['media'] as List?)?.cast<String>() ?? [];
//   //
//   //     logoUrl.value = data['company_logo'] ?? '';
//   //   } catch (e) {
//   //     Get.snackbar("Error", e.toString());
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
//
//   // ================= SELECT =================
//   void selectCategory(String id) {
//     selectedCategoryId.value = id;
//   }
//
//   void toggleService(String id) {
//     if (selectedOfferServices.contains(id)) {
//       selectedOfferServices.remove(id);
//     } else {
//       selectedOfferServices.add(id);
//     }
//   }
//
//   // ================= IMAGE =================
//   Future<void> pickLogo() async {
//     final x = await picker.pickImage(source: ImageSource.gallery);
//     if (x != null) {
//       logoFile = File(x.path);
//       update();
//     }
//   }
//
//   Future<void> pickMedia() async {
//     if (mediaFiles.length >= 3) {
//       Get.snackbar("Limit", "Max 3 images");
//       return;
//     }
//
//     final x = await picker.pickImage(source: ImageSource.gallery);
//     if (x != null) {
//       mediaFiles.add(File(x.path));
//       update();
//     }
//   }
//
//   void removeMedia(int index) {
//     mediaFiles.removeAt(index);
//     update();
//   }
//
//   // ================= FETCH SERVICE =================
//   Future<void> fetchService() async {
//     try {
//       isLoading.value = true;
//
//       final res = await dio.get(
//         "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/service/$serviceId",
//         options: Options(
//           headers: {
//             "Authorization": "Bearer ${storage.accessToken}",
//             "accesstoken": storage.accessToken,
//           },
//         ),
//       );
//
//       final data = res.data["data"];
//
//       // ================= TEXT FIELD DATA =================
//       nameCtrl.text = data["service_name"] ?? "";
//       addressCtrl.text = data["service_address"] ?? "";
//       aboutCtrl.text = data["about"] ?? "";
//       websiteCtrl.text = data["website_link"] ?? "";
//
//       // ================= PHONE =================
//       contactCtrl.text = normalizeBdPhone(
//         data["phone"].toString().startsWith("8801")
//             ? "+${data["phone"]}"
//             : data["phone"].toString(),
//       );
//
//       // ================= TIME =================
//       openingCtrl.text = data["openingTime"] ?? "";
//       closingCtrl.text = data["closingTime"] ?? "";
//
//       // ================= CATEGORY =================
//       selectedCategoryId.value =
//           data["service_category"]?["_id"]?.toString() ?? "";
//
//       // ================= OFFER SERVICES =================
//       selectedOfferServices.assignAll(
//         (data["offer_services"] as List?)
//             ?.map((e) => e["_id"].toString())
//             .toList() ??
//             [],
//       );
//
//       // ================= LOGO =================
//       logoUrl.value = data["company_logo"] ?? "";
//
//       // ================= MEDIA (SHOW ALL) =================
//       mediaUrls.assignAll(
//         (data["media"] as List?)
//             ?.map((e) => e.toString())
//             .toList() ??
//             [],
//       );
//
//       update();
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ================= PHONE FORMATTER =================
//   String formatBdPhoneFromApi(dynamic phone) {
//     if (phone == null) return "";
//
//     String value = phone.toString().trim();
//
//     // API returns: 8801712345678
//     if (value.startsWith("8801") && value.length == 13) {
//       return "0${value.substring(3)}";
//     }
//
//     // API returns: +8801712345678
//     if (value.startsWith("+8801") && value.length == 14) {
//       return "0${value.substring(4)}";
//     }
//
//     return value;
//   }
//   // ================= PHONE FIX =================
//
//   // Put this helper inside controller
//   String normalizeBdPhone(String input) {
//     String phone = input.trim();
//
//     // remove spaces / dash
//     phone = phone.replaceAll(RegExp(r'[\s-]'), '');
//
//     // keep only digits and +
//     phone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
//
//     // if starts 88017... => make +88017...
//     if (phone.startsWith("8801") && phone.length == 13) {
//       phone = "+$phone";
//     }
//
//     // if starts 017... keep same
//     if (phone.startsWith("01") && phone.length == 11) {
//       return phone;
//     }
//
//     // if starts +88017...
//     if (phone.startsWith("+8801") && phone.length == 14) {
//       return phone;
//     }
//
//     return phone;
//   }
//
//   // ================= UPDATE SERVICE =================
//   // Replace updateService() phone section only
//
//   Future<void> updateService() async {
//     try {
//       isUpdating.value = true;
//
//       final phone = normalizeBdPhone(contactCtrl.text);
//
//       print("FINAL PHONE SENT = $phone");
//
//       final formData = FormData();
//
//       final body = {
//         "service_name": nameCtrl.text.trim(),
//         "service_category": selectedCategoryId.value,
//         "offer_services": selectedOfferServices.toList(),
//
//         // ✅ FIXED PHONE
//         "phone": phone,
//
//         "service_address": addressCtrl.text.trim(),
//         "about": aboutCtrl.text.trim(),
//         "website_link": websiteCtrl.text.trim(),
//         "location": {
//           "type": "Point",
//           "coordinates": [90.4125, 23.8103],
//         },
//         "openingTime": openingCtrl.text.trim(),
//         "closingTime": closingCtrl.text.trim(),
//         "allTimeAvailability": false,
//       };
//
//       formData.fields.add(MapEntry("data", jsonEncode(body)));
//
//       if (logoFile != null) {
//         formData.files.add(MapEntry("company_logo", await MultipartFile.fromFile(logoFile!.path)));
//       }
//
//       for (final file in mediaFiles) {
//         formData.files.add(MapEntry("media", await MultipartFile.fromFile(file.path)));
//       }
//
//       final res = await dio.patch(
//         "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/service/$serviceId",
//         data: formData,
//         options: Options(
//           headers: {
//             "Authorization": "Bearer ${storage.accessToken}",
//             "accesstoken": storage.accessToken,
//             "Content-Type": "multipart/form-data",
//           },
//         ),
//       );
//
//       if (res.data["success"] == true) {
//         Get.snackbar("Success", "Updated Successfully");
//         fetchService();
//       }
//     } on DioException catch (e) {
//       print("STATUS CODE: ${e.response?.statusCode}");
//       print("ERROR DATA: ${e.response?.data}");
//     } finally {
//       isUpdating.value = false;
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';

import '../../../../../data/services/storage_service.dart';
import '../models/category_model.dart';

class ServiceProviderEditController extends GetxController {
  final Dio dio = Dio();
  final picker = ImagePicker();
  final storage = StorageService();

  final isLoading = false.obs;
  final isUpdating = false.obs;

  final openingTime = TimeOfDay(hour: 9, minute: 0).obs;
  final closingTime = TimeOfDay(hour: 21, minute: 0).obs;
  final isOpen24_7 = false.obs;

  final nameCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final openingCtrl = TextEditingController();
  final closingCtrl = TextEditingController();

  final categoryTree = <Category>[].obs;

  final selectedCategoryId = ''.obs;
  final selectedOfferServices = <String>[].obs;

  final logoUrl = ''.obs;
  final mediaUrls = <String>[].obs;

  final logoFile = Rxn<File>();
  final mediaFiles = <File>[].obs;

  final serviceId = StorageService().serviceId;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll() async {
    await fetchCategoryTree();
    await fetchService();
  }

  // ================= CATEGORY TREE =================
  Future<void> fetchCategoryTree() async {
    try {
      final res = await dio.get(
        "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/category/tree",
        options: Options(headers: {"accesstoken": storage.accessToken}),
      );

      final data = res.data['data'] as List;
      categoryTree.value = data.map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // ================= SELECT =================
  void selectCategory(String id) {
    selectedCategoryId.value = id;
  }

  void setOpeningTime(TimeOfDay time) {
    openingTime.value = time;
  }

  void setClosingTime(TimeOfDay time) {
    closingTime.value = time;
  }

  void toggleService(String id) {
    if (selectedOfferServices.contains(id)) {
      selectedOfferServices.remove(id);
    } else {
      selectedOfferServices.add(id);
    }
  }

  // ================= IMAGE =================
  Future<void> pickLogo() async {
    final x = await picker.pickImage(source: ImageSource.gallery);
    if (x != null) {
      logoFile.value = File(x.path); // ✅ FIX
    }
  }

  Future<void> pickMedia() async {
    if (mediaFiles.length >= 3) {
      Get.snackbar("Limit", "Max 3 images");
      return;
    }

    final x = await picker.pickImage(source: ImageSource.gallery);
    if (x != null) {
      mediaFiles.add(File(x.path));
    }
  }

  void removeMedia(int index) {
    mediaFiles.removeAt(index);
  }

  // ================= FETCH SERVICE =================
  Future<void> fetchService() async {
    try {
      isLoading.value = true;

      final res = await dio.get(
        "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/service/$serviceId",
        options: Options(
          headers: {
            "Authorization": "Bearer ${storage.accessToken}",
            "accesstoken": storage.accessToken,
          },
        ),
      );

      final data = res.data["data"];

      nameCtrl.text = data["service_name"] ?? "";
      addressCtrl.text = data["service_address"] ?? "";
      aboutCtrl.text = data["about"] ?? "";
      websiteCtrl.text = data["website_link"] ?? "";

      contactCtrl.text = normalizeBdPhone(
        data["phone"].toString().startsWith("8801")
            ? "+${data["phone"]}"
            : data["phone"].toString(),
      );

      openingCtrl.text = data["openingTime"] ?? "";
      closingCtrl.text = data["closingTime"] ?? "";

      selectedCategoryId.value =
          data["service_category"]?["_id"]?.toString() ?? "";

      selectedOfferServices.assignAll(
        (data["offer_services"] as List?)
            ?.map((e) => e["_id"].toString())
            .toList() ??
            [],
      );

      logoUrl.value = data["company_logo"] ?? "";

      if (data["openingTime"] != null) {
        final parts = data["openingTime"].split(":");
        openingTime.value = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }

      if (data["closingTime"] != null) {
        final parts = data["closingTime"].split(":");
        closingTime.value = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }

      mediaUrls.assignAll(
        (data["media"] as List?)
            ?.map((e) => e.toString())
            .toList() ??
            [],
      );

      update();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ================= PHONE =================
  String normalizeBdPhone(String input) {
    String phone = input.trim();
    phone = phone.replaceAll(RegExp(r'[\s-]'), '');
    phone = phone.replaceAll(RegExp(r'[^0-9+]'), '');

    if (phone.startsWith("8801") && phone.length == 13) {
      phone = "+$phone";
    }

    if (phone.startsWith("01") && phone.length == 11) {
      return phone;
    }

    if (phone.startsWith("+8801") && phone.length == 14) {
      return phone;
    }

    return phone;
  }

  String getServiceNameById(String id) {
    for (final cat in categoryTree) {
      for (final child in cat.children) {
        for (final sub in child.children) {
          if (sub.id == id) {
            return sub.name;
          }
        }
      }
    }
    return "Unknown";
  }

  String getCategoryNameById(String id) {
    if (id.isEmpty) return "";

    for (final parent in categoryTree) {
      if (parent.id == id) return parent.name;

      for (final child1 in parent.children) {
        if (child1.id == id) return child1.name;

        for (final child2 in child1.children) {
          if (child2.id == id) return child2.name;
        }
      }
    }

    return id; // fallback if not found
  }

  // ================= UPDATE SERVICE =================
  Future<void> updateService() async {
    try {
      isUpdating.value = true;

      final phone = normalizeBdPhone(contactCtrl.text);

      final formData = FormData();

      final body = {
        "service_name": nameCtrl.text.trim(),
        "service_category": selectedCategoryId.value,
        "offer_services": selectedOfferServices.toList(),
        "phone": phone,
        "service_address": addressCtrl.text.trim(),
        "about": aboutCtrl.text.trim(),
        "website_link": websiteCtrl.text.trim(),
        "location": {
          "type": "Point",
          "coordinates": [90.4125, 23.8103],
        },
        "openingTime":
        "${openingTime.value.hour.toString().padLeft(2, '0')}:${openingTime.value.minute.toString().padLeft(2, '0')}",

        "closingTime":
        "${closingTime.value.hour.toString().padLeft(2, '0')}:${closingTime.value.minute.toString().padLeft(2, '0')}",
        "allTimeAvailability": false,
      };

      formData.fields.add(MapEntry("data", jsonEncode(body)));

      if (logoFile.value != null) {
        formData.files.add(MapEntry(
          "company_logo",
          await MultipartFile.fromFile(logoFile.value!.path),
        ));
      }

      for (final file in mediaFiles) {
        formData.files.add(MapEntry(
          "media",
          await MultipartFile.fromFile(file.path),
        ));
      }

      final res = await dio.patch(
        "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/service/$serviceId",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer ${storage.accessToken}",
            "accesstoken": storage.accessToken,
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (res.data["success"] == true) {
        Get.snackbar("Success", "Updated Successfully");
        fetchService();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  // ================= ADDED (FOR YOUR VIEW ONLY) =================
  // Focus Nodes
  final serviceNameFocus = FocusNode();
  final contactFocus = FocusNode();
  final addressFocus = FocusNode();
  final aboutFocus = FocusNode();
  final websiteFocus = FocusNode();

  // Edit toggles
  final isServiceNameEditable = false.obs;
  final isContactEditable = false.obs;
  final isAddressEditable = false.obs;
  final isAboutEditable = false.obs;
  final isWebsiteEditable = false.obs;

  @override
  void onClose() {
    serviceNameFocus.dispose();
    contactFocus.dispose();
    addressFocus.dispose();
    aboutFocus.dispose();
    websiteFocus.dispose();

    nameCtrl.dispose();
    contactCtrl.dispose();
    addressCtrl.dispose();
    aboutCtrl.dispose();
    websiteCtrl.dispose();
    openingCtrl.dispose();
    closingCtrl.dispose();

    super.onClose();
  }
}
