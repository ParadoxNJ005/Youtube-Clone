import 'package:flutter/material.dart';
import 'package:youtube/common/apis.dart';
import 'package:youtube/common/colors.dart';
import 'package:youtube/models/videoModel.dart';
import 'package:youtube/widgets/VideoCard.dart';
import 'dart:developer';
import 'package:rxdart/rxdart.dart'; // Add this import

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Video> _list = [];

  @override
  void initState() {
    super.initState();
    API.getAllVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF).withOpacity(0),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              icon: Icon(Icons.video_camera_back_outlined),
              onPressed: () {},
              iconSize: 28,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
              iconSize: 28,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              icon: Icon(Icons.notification_important_outlined),
              onPressed: () {},
              iconSize: 28,
            ),
          ),
        ],
      ),

      //---------------------------body------------------------------------------------
      body: StreamBuilder(
        stream: API.getAllVideos(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                final data = snapshot.data;
                _list = data?.map((e) => Video.fromJson(e)).toList() ?? [];

                if (_list.isEmpty) {
                  return Center(
                    child: Container(
                      child:
                          Text("No Data Found", style: TextStyle(fontSize: 35)),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: _list.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Videocard(video: _list[index]);
                    },
                  );
                }
              } else {
                return Center(
                  child: Text("No Data Found", style: TextStyle(fontSize: 35)),
                );
              }
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }

  Widget _appBar() {
    return SafeArea(
      child: InkWell(
        onTap: () {},
        child: Container(
          color: Color(0xFFFFFFFF).withOpacity(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Image.asset(
                  "assets/logo.png",
                  width: 100,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  // image: DecorationImage(
                  //   image: NetworkImage(
                  //     "",
                  //   ),
                  //   fit: BoxFit.cover,
                  // ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
