import 'package:flutter/material.dart';
import 'package:youtube/common/apis.dart';
import 'package:youtube/main.dart';
import 'package:youtube/models/videoModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube/screens/DetailScreen.dart';

class Historycard extends StatefulWidget {
  final Video video;
  const Historycard({super.key, required this.video});

  @override
  State<Historycard> createState() => _HistorycardState();
}

class _HistorycardState extends State<Historycard> {
  late Future<String> _adminNameFuture;

  @override
  void initState() {
    super.initState();
    _adminNameFuture = API.getAdminName(widget.video.author);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: mq.width * 0.4,
                  height: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.video.thumbnailUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: mq.height * .01),
                      Text(
                        widget.video.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: mq.height * .01),
                      FutureBuilder<String>(
                        future: _adminNameFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("Loading...");
                          } else if (snapshot.hasError) {
                            return Text("Error loading admin name");
                          } else {
                            return Text(
                              "${snapshot.data} - 6 days ago",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                // SizedBox(width: 10),
                // Icon(Icons.more_vert),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
