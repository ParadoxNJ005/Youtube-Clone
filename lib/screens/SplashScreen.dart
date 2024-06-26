import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube/auths/auth.dart';
import 'package:youtube/common/apis.dart';
import 'package:youtube/main.dart';
import 'package:youtube/screens/HomeScreen.dart';
import 'package:youtube/widgets/bottomnav.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white));

      checkSessionAndNavigate(context);
    });
  }

  void checkSessionAndNavigate(BuildContext context) async {
    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;

    if (currentUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AuthScreen(),
        ),
      );
    } else {
      final userId = currentUser.id;
      await API.getUser(
          userId); // Make sure this is an async operation if it performs network requests
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const Bottomnav(), // Ensure Bottomnav() is defined in your project
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      //body
      body: Stack(children: [
        //app logo
        Positioned(
            top: mq.height * .27,
            left: mq.width * .38,
            width: mq.width * .35,
            height: mq.height * .35,
            child: SvgPicture.asset("assets/youtube.svg")),
      ]),
    );
  }
}
