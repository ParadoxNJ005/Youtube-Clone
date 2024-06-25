import 'package:flutter/material.dart';
import 'package:youtube/common/apis.dart';
import 'package:youtube/main.dart';
import 'package:youtube/models/videoModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube/screens/DetailScreen.dart';

class Videocard extends StatefulWidget {
  final Video video;
  const Videocard({super.key, required this.video});

  @override
  State<Videocard> createState() => _VideocardState();
}

class _VideocardState extends State<Videocard> {
  late Future<String> _adminNameFuture;
  late Future<String> _adminImageFuture;

  @override
  void initState() {
    super.initState();
    _adminNameFuture = API.getAdminName(widget.video.author);
    _adminImageFuture = API.getAdminImage(widget.video.author);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Detailscreen(
                          id: widget.video.id,
                        )));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //---------------------------------------------------------community image----------------------------------------------------------//

              ClipRRect(
                child: CachedNetworkImage(
                  height: mq.height * .2,
                  width: double.infinity,
                  imageUrl: widget.video.thumbnailUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageProvider,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),

              //-----------------------------------------------------------Admin Image and details---------------------------------------------------//

              FutureBuilder<String>(
                future: _adminNameFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return Text(
                      widget.video.title,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    );
                  } else {
                    return ListTile(
                      leading: FutureBuilder<String>(
                        future: _adminImageFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError ||
                              !snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Icon(Icons.error, size: mq.height * .085);
                          } else {
                            return ClipRRect(
                              child: CachedNetworkImage(
                                height: mq.height * .085,
                                width: mq.width * .14,
                                imageUrl: snapshot.data!,
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
                            );
                          }
                        },
                      ),
                      title: Text(
                        widget.video.title,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        "${snapshot.data} - ${widget.video.viewCount} views - 6 days ago",
                        maxLines: 1,
                      ),
                      trailing: Icon(Icons.more_vert),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
