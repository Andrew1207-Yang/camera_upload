import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
// image_page.dart
class ImagePage extends StatelessWidget {
  final List<String> imagePaths;

  const ImagePage({Key? key, required this.imagePaths}) : super(key: key);

  Future<void> _uploadAllImages(BuildContext context) async {
    try {
      final storage = FirebaseStorage.instance;
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        for (String filePath in imagePaths) {
          var ref = storage.ref().child('images/${user.uid}/${DateTime.now()}.png');
          await ref.putFile(File(filePath));
        }
        print('All images uploaded to Firebase Storage.');
      } else {
        // User not authenticated
        print('User not authenticated.');
      }
    } catch (e) {
      print('Failed to upload images: $e');
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
            _uploadAllImages(context);
          },
        ),
        border: null,
      ),
      backgroundColor: CupertinoColors.black,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                for (String imagePath in imagePaths)
                  Image.file(File(imagePath)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                  onPressed: () {
                    // Retake photos
                    Navigator.pop(context);
                  },
                  child: Text('Retake'),
                ),
                CupertinoButton(
                  onPressed: () {
                    // Continue taking photos
                    Navigator.pop(context);
                  },
                  child: Text('Continue'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
