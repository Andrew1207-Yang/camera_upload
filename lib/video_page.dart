import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _uploadVideo() async {
    try {
      File file = File(widget.filePath);
      final storage = FirebaseStorage.instance;
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        var ref = storage.ref().child('videos/${user.uid}/${DateTime.now()}.mp4');
        await ref.putFile(file);
        print('Video uploaded to Firebase Storage.');
      } else {
        // User not authenticated
        print('User not authenticated.');
      }
    } catch (e) {
      print('Failed to upload video: $e');
      // Handle upload failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Preview'),
        backgroundColor: CupertinoColors.black.withOpacity(0.6),
        trailing: CupertinoButton(
          child: Icon(CupertinoIcons.cloud_upload),
          onPressed: () {
            _uploadVideo();
          },
        ),
        border: null,
      ),
      backgroundColor: CupertinoColors.black,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            _videoPlayerController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  )
                : CupertinoActivityIndicator(),
            GestureDetector(
              onTap: () {
                if (_videoPlayerController.value.isPlaying) {
                  _videoPlayerController.pause();
                } else {
                  _videoPlayerController.play();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
