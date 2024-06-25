import 'package:flutter/material.dart';
import 'package:youtube/common/apis.dart';
import 'package:youtube/models/videoModel.dart';
import 'package:youtube/widgets/DetailCard.dart';

class Detailscreen extends StatefulWidget {
  final int id;
  const Detailscreen({Key? key, required this.id}) : super(key: key);

  @override
  State<Detailscreen> createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: API.getVideoById(widget.id.toString()),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching video'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
                child: Text('No Data Found', style: TextStyle(fontSize: 35)));
          } else {
            final video = Video.fromJson(snapshot.data!);
            return Detailcard(video: video);
          }
        },
      ),
    );
  }
}
