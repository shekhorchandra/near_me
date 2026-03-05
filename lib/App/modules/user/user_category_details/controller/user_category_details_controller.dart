import 'package:get/get.dart';
import '../user_category_model/service_model.dart';

class UserCategoryDetailsController extends GetxController {
  var searchText = ''.obs;

  var selectedRating = 'Rating'.obs;
  var selectedRadius = 'Radius'.obs;
  var selectedAvailability = 'Availability'.obs;

  var generalPlumbing = false.obs;
  var leakDetection = false.obs;


  // Plumbing options
  var plumbingOptions = <String, bool>{
    'General Plumbing': false,
    'Leak Detection & Repair': false,
    'Drain Cleaning': false,
  }.obs;

  // Electrical options
  var electricalOptions = <String, bool>{
    'General Electrician': false,
    'Leak Detection & Repair': false,
    'Maker': false,
  }.obs;

  // Services list
  var services = <ServiceModel>[
    ServiceModel(
      title: 'John Plumbing Services',
      image: 'assets/images/trade&service.png',
      rating: 4.5,
      distance: 2.3,
      schedule: 'Mon-Fri 9am-6pm',
      location: 'Kaliganj, Bangladesh',
      category: 'Beauty & Wellness',
      about: 'Blissful Spa is your sanctuary for relaxation and renewal, offering professional massage and wellness treatments designed to restore balance to your body and mind.',
      servicesOffered: 'Accounting & Finance Services',
      highlights: <HighlightModel>[],
      reviews: [
        'Excellent service!',
        'Very professional staff.',
      ],
    ),
    ServiceModel(
      title: 'Leak Fixers',
      image: 'assets/images/trade&service.png',
      rating: 4.2,
      distance: 3.0,
      schedule: 'Mon-Sat 10am-5pm',
      location: 'Kaliganj, Bangladesh',
      category: '',
      about: '',
      servicesOffered: '',
      highlights: [
        HighlightModel(image: 'assets/images/trade&service.png', title: 'AC Repair'),
        HighlightModel(image: 'assets/images/trade&service.png', title: 'Home Cleaning'),
        HighlightModel(image: 'assets/images/trade&service.png', title: 'Pipe Fixing'),
        HighlightModel(image: 'assets/images/trade&service.png', title: 'Drain Service'),
      ],
      reviews: [
        'Excellent service!',
        'Very professional staff.',
      ],
    ),
  ].obs;

  List<ServiceModel> get filteredServices {
    return services.where((service) {
      final matchSearch = service.title.toLowerCase().contains(searchText.value.toLowerCase());
      final matchGeneral = !generalPlumbing.value || service.title.toLowerCase().contains('plumbing');
      final matchLeak = !leakDetection.value || service.title.toLowerCase().contains('leak');
      return matchSearch && matchGeneral && matchLeak;
    }).toList();
  }
}