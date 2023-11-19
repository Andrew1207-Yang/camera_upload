// ignore_for_file: prefer_final_fields
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'image_page.dart';
import 'package:flutter/cupertino.dart';

// class CameraPage extends StatefulWidget {
//   const CameraPage({Key? key}) : super(key: key);

//   @override
//   _CameraPageState createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> {
//   bool _isLoading = true;
//   bool _isRecording = false;
//   late CameraController _cameraController;

//   _recordVideo() async {
//     if (_isRecording) {
//       final file = await _cameraController.stopVideoRecording();
//       setState(() => _isRecording = false);
//       final route = CupertinoPageRoute(
//         fullscreenDialog: true,
//         builder: (_) => VideoPage(filePath: file.path),
//       );
//       Navigator.push(context, route);
//     } else {
//       await _cameraController.prepareForVideoRecording();
//       await _cameraController.startVideoRecording();
//       setState(() => _isRecording = true);
//     }
//   }

//   _initCamera() async {
//     final cameras = await availableCameras();
//     final front = cameras.first;
//     _cameraController = CameraController(front, ResolutionPreset.max);
//     await _cameraController.initialize();
//     setState(() => _isLoading = false);
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const CupertinoPageScaffold(
//         child: Center(
//           child: CupertinoActivityIndicator(),
//         ),
//       );
//     } else {
//       return CupertinoPageScaffold(
//         child: Center(
//           child: Stack(
//             alignment: Alignment.bottomCenter,
//             children: [
//               CameraPreview(_cameraController),
//               Padding(
//                 padding: const EdgeInsets.all(25),
//                 child: CupertinoButton(
//                   color: Colors.red,
//                   child: Icon(_isRecording ? CupertinoIcons.stop : CupertinoIcons.circle),
//                   onPressed: () => _recordVideo(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }
// }
// camera_page.dart
// camera_page.dart
class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<String> imagePaths = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.max,
    );
    await _controller.initialize();
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      setState(() {
        imagePaths.add(image.path);
      });

      // Show the ImagePage with the preview
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ImagePage(imagePaths: imagePaths),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Camera Page'),
      ),
      child: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CameraPreview(_controller),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        // Retake photo
                        _controller.dispose();
                        _initializeCamera();
                      },
                      child: Text('Retake'),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        // Take next photo
                        _takePicture();
                      },
                      child: Text('Next'),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return CupertinoActivityIndicator();
          }
        },
      ),
    );
  }
}
