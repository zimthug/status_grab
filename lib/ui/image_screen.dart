import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:status_grab/ui/widgets/viewPhoto.dart';
import 'package:status_grab/utils/constants.dart';

class ImageScreen extends StatefulWidget {
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final Directory _photoDir = new Directory(Constants.waDirectoryPath);

  @override
  Widget build(BuildContext context) {
    if (!Directory("${_photoDir.path}").existsSync()) {
      return Center(
        child: Text(
          Constants.installWAMsg,
          style: TextStyle(fontSize: 18.0),
        ),
      );
    } else {
      var imageList = _photoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".jpg"))
          .toList(growable: false);

      if (imageList.length > 0) {
        return Container(
          margin: EdgeInsets.all(8.0),
          child: Container()
        );
      } else {
        return Scaffold(
          body: Center(
            child: Text(
              Constants.noImagesFound,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }
}
