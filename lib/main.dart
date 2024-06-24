import 'package:flutter/material.dart';
import 'package:youtube/common/credentials.dart';
import 'package:youtube/screens/HomeScreen.dart';
import 'package:youtube/screens/SplashScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Credentials.APIURL,
    anonKey: Credentials.APIKEY,
  );

  runApp(MyApp());
}

final supabase = Supabase.instance.client;
late Size mq;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Splashscreen(),
    );
  }
}
