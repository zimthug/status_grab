import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:status_grab/utils/constants.dart';
import 'package:status_grab/utils/video_controller.dart';
import 'package:video_player/video_player.dart';

class PlayStatus extends StatefulWidget {
  final String videoFile;
  PlayStatus(this.videoFile);

  @override
  _PlayStatusState createState() => _PlayStatusState();
}

class _PlayStatusState extends State<PlayStatus> {
  void _onSaving(bool t, String str) {
    if (t) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                Center(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          });
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SimpleDialog(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Image Saved in Gallery",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text(str,
                              style: TextStyle(
                                fontSize: 16.0,
                              )),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text(
                            "FileManager > status_grab",
                            style: TextStyle(
                                fontSize: 16.0, color: Constants.primaryColor),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          MaterialButton(
                            child: Text("Close"),
                            color: Constants.primaryColor,
                            textColor: Colors.white,
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.white,
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: VideoStatus(
          videoPlayerController:
              VideoPlayerController.file(File(widget.videoFile)),
          looping: true,
          videoSrc: widget.videoFile,
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: Constants.primaryColor,
          child: Icon(Icons.save),
          onPressed: () async {
            _onSaving(true, "");

            File originalVideoFile = File(widget.videoFile);
            Directory directory = await getExternalStorageDirectory();
            if (!Directory("${directory.path}/status_grab/Videos")
                .existsSync()) {
              Directory("${directory.path}/status_grab/Videos")
                  .createSync(recursive: true);
            }
            String path = directory.path;
            String curDate = DateTime.now().toString();
            String newFileName = "$path/status_grab/Videos/VIDEO-$curDate.mp4";
            print(newFileName);
            await originalVideoFile.copy(newFileName);

            _onSaving(false,
                "If Video is not available in gallery\n\nPlease find them in");
          }),
    );
  }

  void dispose() {
    super.dispose();
  }
}
