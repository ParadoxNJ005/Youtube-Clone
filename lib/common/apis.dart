import 'dart:developer';
import 'dart:io';
import 'package:youtube/common/credentials.dart';
import 'package:youtube/main.dart';
import 'package:youtube/models/userModel.dart';
import 'package:rxdart/rxdart.dart';

class API {
  static String? uid;
  static ChatUser? me;

  static Future<void> signUp(
      {required String email,
      required String password,
      required String username}) async {
    try {
      final response = await supabase.auth.signUp(
          email: email, password: password, data: {'username': username});
      if (response == null) {
        log("Sign up error: $response");
      } else {
        log("Sign up successful: ${response.user!.email}");

        uid = response.user!.id;
        await createUser(email: email, id: uid!, name: username, image: "");

        await login(email: email, password: password);
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
        log("Sign In error: $response");
      } else {
        log("Sign In successful: ${response.user!.email}");
        uid = response.user!.id;
      }
    } catch (e) {
      log("error : $e");
    }
  }

  static Future<void> createUser(
      {required String email,
      required String id,
      required String name,
      required String image}) async {
    try {
      final response = await supabase
          .from('user')
          .insert({'name': name, 'uid': id, 'email': email, 'image': image});

      if (response == null) {
        log("user response null: $response");
      } else {
        log("user created: $response");
      }
    } catch (e) {
      log("error in creating user : $e");
    }
  }

  static Future<void> getUser() async {
    try {
      final response =
          await supabase.from('user').select().eq('uid', uid!).maybeSingle();

      if (response == null) {
        log("Error fetching user data: ${response}");
        return;
      }

      final userData = response;
      me = ChatUser.fromJson(userData);
    } catch (e) {
      log("Error in getting user data: $e");
    }
  }

  static Future<String> getAdminName(String adminid) async {
    try {
      final response =
          await supabase.from('user').select().eq('uid', adminid).maybeSingle();

      if (response == null) {
        log("Error fetching user data: ${response}");
        return "";
      }

      final userData = response;
      return ChatUser.fromJson(userData).name;
    } catch (e) {
      log("Error in getting user data: $e");
      return "";
    }
  }

  static Future<String> getAdminImage(String adminid) async {
    try {
      final response =
          await supabase.from('user').select().eq('uid', adminid).maybeSingle();

      if (response == null) {
        log("Error fetching user data: ${response}");
        return "";
      }

      final userData = response;
      return ChatUser.fromJson(userData).image;
    } catch (e) {
      log("Error in getting user data: $e");
      return "";
    }
  }

  static Future<void> uploadImage(File file) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      final String uid = user.id;
      final String fileName = file.path.split('/').last;
      final String filePath = '$uid/$fileName';

      final response =
          await supabase.storage.from('images').upload(filePath, file);
      log("image response : $response");

      final String imageUrl =
          supabase.storage.from('images').getPublicUrl(filePath);

      log("Image URL: $imageUrl");

      await supabase.from('user').update({'image': imageUrl}).eq('uid', uid);
    } catch (e) {
      log("image err: $e");
    }
  }

  static Future<void> updateDetails(String name) async {
    try {
      await supabase.from('user').update({'name': name}).eq('uid', uid!);
    } catch (e) {
      log("error: ${e}");
    }
  }

  static Stream<List<Map<String, dynamic>>> getAllVideos() {
    final controller = BehaviorSubject<List<Map<String, dynamic>>>();

    supabase.from('videos').select().then((response) {
      if (response != null) {
        controller.add(response as List<Map<String, dynamic>>);
      } else {
        log("Error in fetching videos: ${response}");
        controller.addError("Error in fetching videos");
      }
    }).catchError((e) {
      log("Error in fetching videos: ${e}");
      controller.addError(e);
    });
    log("${controller.stream}");
    return controller.stream;
  }

  static Stream<Map<String, dynamic>> getVideoById(String id) {
    final controller = BehaviorSubject<Map<String, dynamic>>();

    supabase.from('videos').select().eq('id', id).single().then((response) {
      if (response != null) {
        controller.add(response as Map<String, dynamic>);
      } else {
        log("Error in fetching video with ID $id: ${response}");
        controller.addError("Error in fetching video");
      }
    }).catchError((e) {
      log("Error in fetching video with ID $id: ${e}");
      controller.addError(e);
    });

    log("Fetching video with ID $id");
    return controller.stream;
  }
}
