import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube/auths/auth.dart';
import 'package:youtube/main.dart';
import 'package:youtube/screens/HomeScreen.dart';
import 'package:youtube/widgets/bottomnav.dart';

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

      if (supabase.auth.currentUser == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const AuthScreen(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const Bottomnav(),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      //body
      body: Stack(children: [
        //app logo
        Positioned(
            top: mq.height * .35,
            left: mq.width * .38,
            width: mq.width * .25,
            child: Image.asset('assets/logo.png')),

        //google login button
        Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Text('Welcome to Youtube',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Colors.black87, letterSpacing: .5))),
      ]),
    );
  }
}
