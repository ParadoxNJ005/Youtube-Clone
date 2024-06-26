import 'package:flutter/material.dart';
import 'package:youtube/common/apis.dart';
import 'package:youtube/models/videoModel.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube/widgets/VideoCard.dart';

class Detailcard extends StatefulWidget {
  final Video? video;
  const Detailcard({Key? key, required this.video}) : super(key: key);

  @override
  State<Detailcard> createState() => _DetailcardState();
}

class _DetailcardState extends State<Detailcard>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;
  late Future<String> _adminNameFuture;
  late Future<String> _adminImageFuture;
  late Future<List<Video>> _videosFuture;

  bool isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    _adminNameFuture = API.getAdminName(widget.video!.author);
    _adminImageFuture = API.getAdminImage(widget.video!.author);
    _videosFuture = _fetchVideos();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<List<Video>> _fetchVideos() async {
    final data = await API.getAllVideos().first;
    return data.map((e) => Video.fromJson(e)).toList();
  }

  @override
  void didUpdateWidget(Detailcard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.video != oldWidget.video) {
      _disposeVideoPlayer();
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    _videoController = VideoPlayerController.network(widget.video!.url);
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: true,
      allowMuting: true,
      allowPlaybackSpeedChanging: true,
      showControlsOnInitialize: false,
    );
    _videoController.addListener(_updateVideoState);
  }

  void _disposeVideoPlayer() {
    _videoController.removeListener(_updateVideoState);
    _videoController.pause();
    _videoController.dispose();
    _chewieController.dispose();
  }

  void _updateVideoState() {
    if (mounted) {
      setState(() {
        isVideoPlaying = _videoController.value.isPlaying;
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _disposeVideoPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var mq = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: 40),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    height: mq.height * 0.25,
                    color: Colors.red,
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
                ),
                if (!isVideoPlaying)
                  Positioned.fill(
                    child: Image.network(
                      widget.video!.thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                Positioned.fill(
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        _videoController.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 50,
                        color: Colors.white,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Text(
                    widget.video!.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${widget.video!.viewCount} views · 28 days ago",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 154, 152, 152),
                    ),
                  ),
                  Divider(
                      height: 20, color: const Color.fromARGB(255, 63, 60, 60)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAction(context, Icons.thumb_up_outlined,
                          widget.video!.likes.toString()),
                      _buildAction(context, Icons.thumb_down_outlined,
                          widget.video!.dislikes.toString()),
                      _buildAction(context, Icons.reply_outlined, 'Share'),
                      _buildAction(
                          context, Icons.download_outlined, 'Download'),
                      _buildAction(context, Icons.library_add_outlined, 'Save'),
                    ],
                  ),
                  SizedBox(height: 10),
                  FutureBuilder<String>(
                    future: _adminNameFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return Text(
                          "Owner",
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
                                return Icon(Icons.error,
                                    size: mq.height * .085);
                              } else {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    height: mq.height * .085,
                                    width: mq.width * .14,
                                    imageUrl: snapshot.data!,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: imageProvider,
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
                            snapshot.data!,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "45.9K subscribers",
                            maxLines: 1,
                          ),
                          trailing: TextButton(
                            onPressed: () {},
                            child: Text('SUBSCRIBE',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 18)),
                          ),
                        );
                      }
                    },
                  ),
                  Divider(
                      height: 20, color: const Color.fromARGB(255, 63, 60, 60)),
                  SizedBox(height: 10),
                  FutureBuilder<List<Video>>(
                    future: _videosFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return Center(
                            child: Text("No Data Found",
                                style: TextStyle(fontSize: 35)));
                      } else {
                        final _list = snapshot.data!;
                        return ListView.builder(
                          itemCount: _list.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Videocard(
                              video: _list[index],
                              nav: false,
                              profile: false,
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () async {
        if (label == "Save") {
          await API.saveVideo(widget.video!);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 6.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
