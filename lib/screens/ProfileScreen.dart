import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:youtube/auths/auth.dart';
import 'package:youtube/common/apis.dart';
import 'package:youtube/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube/models/videoModel.dart';
import 'package:youtube/widgets/DetailCard.dart';
import 'package:youtube/widgets/HistoryCard.dart';
import 'package:youtube/widgets/ProfileCard.dart';
import 'package:youtube/widgets/VideoCard.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  String name = '';
  String about = '';
  String? _image;

  List<Video> _list = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;
    API.getUser(currentUser!.id);
  }

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              icon: Icon(Icons.notification_important_outlined),
              onPressed: () {},
              iconSize: 28,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              icon: Icon(Icons.logout_outlined),
              onPressed: () async {
                await supabase.auth.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => AuthScreen()));
              },
              iconSize: 28,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //--------------------------------Profile----------------------------------------
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * 0.25),
                      child: _image != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * 0.25),
                              child: Image.file(
                                File(_image!),
                                width: mq.height * .01,
                                height: mq.height * .01,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * 0.25),
                              child: CachedNetworkImage(
                                height: mq.height * .11,
                                width: mq.width * .25,
                                imageUrl:
                                    API.me != null && API.me!.image != null
                                        ? API.me!.image
                                        : "",
                                imageBuilder: (context, imageProvider) =>
                                    ClipOval(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: imageProvider,
                                      ),
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          API.me != null ? API.me!.name : "Naitik Jain",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          API.me != null
                              ? "${API.me!.email}" + " >"
                              : "a@gmail.com" + " >",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: IconButton(
                        onPressed: () {
                          _showEditDialog(context);
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 25,
                        )),
                  )
                ],
              ),

              //--------------------------------------------divider----------------------------------//
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Divider(
                indent: 5,
                endIndent: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "History",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Container(
                height: 200,
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: API.getAllVideos(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          final data = snapshot.data!;
                          _list = data.map((e) => Video.fromJson(e)).toList();
                          if (_list.isEmpty) {
                            return Center(
                              child: Text(
                                "No Data Found",
                                style: TextStyle(fontSize: 18),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _list.length,
                              itemBuilder: (context, index) {
                                // Ensure index is within bounds
                                if (index < _list.length) {
                                  return InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (_) => Detailcard(
                                      //               video: _list[index],
                                      //             )));
                                    },
                                    child: Container(
                                      height: 200,
                                      width: 200,
                                      margin: EdgeInsets.all(10),
                                      color: Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              height: 100,
                                              width: 190,
                                              color: Colors.transparent,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    _list[index].thumbnailUrl,
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 3,
                                                right: 1,
                                                left: 2,
                                                bottom: 2),
                                            child: Text(
                                              _list[index].title,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(); // Return an empty container if index is out of bounds
                                }
                              },
                            );
                          }
                        } else {
                          return Center(
                            child: Text(
                              "No Data Found",
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        }
                      default:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Saved for later",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Container(
                height: 200,
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: API.getSavedVideo(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          _list.clear();
                          final data = snapshot.data!;
                          _list = data.map((e) => Video.fromJson(e)).toList();
                          if (_list.isEmpty) {
                            return Center(
                              child: Text(
                                "No Data Found",
                                style: TextStyle(fontSize: 18),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _list.length,
                              itemBuilder: (context, index) {
                                // Ensure index is within bounds
                                if (index < _list.length) {
                                  return InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (_) => Detailcard(
                                      //               video: _list[index],
                                      //             )));
                                    },
                                    child: Container(
                                      height: 200,
                                      width: 200,
                                      margin: EdgeInsets.all(10),
                                      color: Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              height: 100,
                                              width: 190,
                                              color: Colors.transparent,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    _list[index].thumbnailUrl,
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 3,
                                                right: 1,
                                                left: 2,
                                                bottom: 2),
                                            child: Text(
                                              _list[index].title,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(); // Return an empty container if index is out of bounds
                                }
                              },
                            );
                          }
                        } else {
                          return Center(
                            child: Text(
                              "No Data Found",
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        }
                      default:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
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
                padding: const EdgeInsets.only(left: 8.0, top: 10),
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

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Name',
                  hintText: 'Enter your name',
                ),
              ),
              SizedBox(height: 20),
              Text(_image == null ? "Image not picked!" : "Image Picked")
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _showBottomSheet();
              },
              child: Text("Pick Image"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text != null) {
                  API.updateDetails(_nameController.text.trim());
                }
                Navigator.of(context).pop();
              },
              child: Text("Update"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .03,
                bottom: MediaQuery.of(context).size.height * .05),
            children: [
              const Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.white,
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * .3,
                              MediaQuery.of(context).size.height * .15)),
                      onPressed: () async {
                        final PermissionStatus permissionStatus =
                            await Permission.photos.request();
                        if (permissionStatus.isGranted) {
                          XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery, imageQuality: 80);
                          if (image != null) {
                            setState(() {
                              _image = image.path;
                            });
                            API.uploadImage(File(_image!));
                            Navigator.pop(context);
                          }
                        } else {
                          // Handle the case when permission is not granted
                          print("Gallery permission denied");
                        }
                      },
                      child: Image.asset('assets/logo.png')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.white,
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * .3,
                              MediaQuery.of(context).size.height * .15)),
                      onPressed: () async {
                        final PermissionStatus permissionStatus =
                            await Permission.camera.request();
                        if (permissionStatus.isGranted) {
                          final XFile? file = await _picker.pickImage(
                              source: ImageSource.camera, imageQuality: 80);
                          if (file != null) {
                            setState(() {
                              _image = file.path;
                            });
                            API.uploadImage(File(_image!));
                            Navigator.pop(context);
                          }
                        } else {
                          // Handle the case when permission is not granted
                          print("Camera permission denied");
                        }
                      },
                      child: Image.asset('assets/logo.png'))
                ],
              )
            ],
          );
        });
  }
}
