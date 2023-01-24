import 'dart:io';

import 'package:flutter/material.dart';
import 'package:status_grab/utils/constants.dart';
import 'package:status_grab/utils/play_status.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final Directory _videoDir = new Directory(Constants.waDirectoryPath);

  @override
  Widget build(BuildContext context) {
    if (!Directory("${_videoDir.path}").existsSync()) {
      return Center(
        child: Text(
          "Install WhatsApp\nYour Friend's Status will be available here.",
          style: TextStyle(fontSize: 18.0),
        ),
      );
    } else {
      return Container();
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Container();
    
}
