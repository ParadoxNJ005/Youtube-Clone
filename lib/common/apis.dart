import 'dart:developer';
import 'package:youtube/common/credentials.dart';
import 'package:youtube/main.dart';

class API {
  static Future<void> signUp(
      {required String email,
      required String password,
      required String username}) async {
    try {
      final response = await supabase.auth.signUp(
          email: email, password: password, data: {'username': username});
      if (response == null) {
        log("Sign up error: ${response}");
      } else {
        log("Sign up successful: ${response.user!.email}");
      }
    } catch (e) {
      log("error : $e");
    }
  }

  static Future<void> login(
      {required String email, required String password}) async {
    try {
      final response = await supabase.auth
          .signInWithPassword(email: email, password: password);
      if (response == null) {
        log("Sign In error: ${response}");
      } else {
        log("Sign In successful: ${response.user!.email}");
      }
    } catch (e) {
      log("error : $e");
    }
  }
}
