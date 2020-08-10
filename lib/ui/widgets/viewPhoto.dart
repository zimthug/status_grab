import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:status_grab/utils/constants.dart';

class ViewPhoto extends StatefulWidget {
  final String imgPath;
  ViewPhoto(this.imgPath);

  @override
  _ViewPhotoState createState() => _ViewPhotoState();
}

class _ViewPhotoState extends State<ViewPhoto> {
  var filePath;
  final String imgShare = "Image.file(File(widget.imgPath),)";

  final LinearGradient backgroundGradient = new LinearGradient(
    colors: [Colors.blue.shade400, Colors.blue.shade900],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

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

  Future<void> _shareImages(filename) async {
    /*
    try {
      final ByteData bytes1 = await rootBundle.load('assets/image1.png');
      final ByteData bytes2 = await rootBundle.load('assets/image2.png');

      await Share.file('Status Grab', filename, bytes, mimeType)

      await Share.files(
          'esys images',
          {
            'esys.png': bytes1.buffer.asUint8List(),
            'bluedan.png': bytes2.buffer.asUint8List(),
          },
          'image/png');
    } catch (e) {
      print('error: $e');
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    var _fabMiniMenuItemList = [
      new FabMiniMenuItem.withText(new Icon(Icons.sd_storage),
          Constants.primaryColor, 4.0, "Button menu", () async {
        _onSaving(true, "");

        Uri myUri = Uri.parse(widget.imgPath);
        File originalImageFile = new File.fromUri(myUri);
        Uint8List bytes;
        await originalImageFile.readAsBytes().then((value) {
          bytes = Uint8List.fromList(value);
        }).catchError((onError) {
          print(
            'Exception Error while reading audio from path:' +
                onError.toString(),
          );
        });
        final result =
            await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));

        _onSaving(false,
            "If Image is not available in gallery\n\nPlease find them in");
      }, "Save", Colors.black, Colors.white, true),
      new FabMiniMenuItem.withText(
          new Icon(Icons.share), Constants.primaryColor, 4.0, "Button menu",
          () {
        //var filename
        _shareImages("");
      }, "Share", Colors.black, Colors.white, true),
      new FabMiniMenuItem.withText(
          new Icon(Icons.reply),
          Constants.primaryColor,
          4.0,
          "Button menu",
          () {},
          "Repost",
          Colors.black,
          Colors.white,
          true),
      new FabMiniMenuItem.withText(
          new Icon(Icons.wallpaper),
          Constants.primaryColor,
          4.0,
          "Button menu",
          () {},
          "Set As",
          Colors.black,
          Colors.white,
          true),
      new FabMiniMenuItem.withText(
          new Icon(Icons.delete_outline),
          Constants.primaryColor,
          4.0,
          "Button menu",
          () {},
          "Delete",
          Colors.black,
          Colors.white,
          true),
    ];

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.indigo,
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: widget.imgPath,
                child: Image.file(
                  File(widget.imgPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            new FabDialer(
              _fabMiniMenuItemList,
              Constants.primaryColor,
              new Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
