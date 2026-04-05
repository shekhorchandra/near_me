import 'dart:async';

import 'package:app_links/app_links.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription? _sub;

  void init() async {
    // Get link when app starts
    final Uri? initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      handleUri(initialUri);
    }

    // Listen for links while app is running
    _sub = _appLinks.uriLinkStream.listen((Uri uri) {
      handleUri(uri);
    });
  }

  void handleUri(Uri uri) {
    print("Deep link: $uri");

    if (uri.pathSegments.contains('product')) {
      final id = uri.pathSegments.last;
      // navigate to product page
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}
