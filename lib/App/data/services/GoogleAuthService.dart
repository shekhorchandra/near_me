import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  GoogleAuthService._internal();

  static final GoogleAuthService instance = GoogleAuthService._internal();

  late final GoogleSignIn _googleSignIn;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    final String? webClientId = dotenv.env['GOOGLE_OAUTH_CLIENT_ID_WEB'];

    if (webClientId == null || webClientId.trim().isEmpty) {
      throw Exception("GOOGLE_OAUTH_CLIENT_ID_WEB is missing in .env file");
    }

    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'profile',
      ],
      serverClientId: webClientId.trim(),
    );

    _initialized = true;

    log("✅ Google Sign-In initialized");
  }

  Future<String?> signInWithGoogle() async {
    try {
      await init();

      // Force account chooser every time
      await _googleSignIn.signOut();

      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        log("Google login cancelled by user");
        return null;
      }

      final GoogleSignInAuthentication auth =
      await account.authentication;

      final String? idToken = auth.idToken;

      if (idToken == null || idToken.isEmpty) {
        log("❌ Google ID token is null or empty");
        return null;
      }

      log("✅ GOOGLE ID TOKEN FOUND");
      log("GOOGLE ID TOKEN => $idToken");

      return idToken;
    } catch (e, st) {
      log("❌ GOOGLE LOGIN ERROR => $e");
      log(st.toString());
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await init();
      await _googleSignIn.signOut();
    } catch (e) {
      log("❌ GOOGLE LOGOUT ERROR => $e");
    }
  }
}