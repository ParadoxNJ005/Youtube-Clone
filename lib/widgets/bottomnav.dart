import 'package:flutter/material.dart';
import 'package:youtube/auths/auth.dart';
import 'package:youtube/common/colors.dart';
import 'package:youtube/screens/HomeScreen.dart';
import 'package:youtube/screens/ProfileScreen.dart';
import 'package:youtube/screens/UploadScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int selectedindex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onTapped(int index) {
    setState(() {
      selectedindex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: const [Homescreen(), Uploadscreen(), Profilescreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/add.svg',
              color: white,
              width: 30,
              height: 30,
            ),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_2_outlined,
            ),
            label: 'You',
          ),
        ],
        currentIndex: selectedindex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        iconSize: 30,
        onTap: onTapped,
        elevation: 10,
      ),
    );
  }
}
