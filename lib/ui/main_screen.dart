import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:status_grab/ui/image_screen.dart';
import 'package:status_grab/ui/video_screen.dart';
import 'package:status_grab/utils/constants.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  // late int _storagePermissionCheck;
  late Future<int> _storagePermissionChecker;
  late TabController _tabController;

  // Future<int> checkStoragePermission() async {
  //   PermissionStatus result = await PermissionHandler()
  //       .checkPermissionStatus(PermissionGroup.storage);
  //   setState(() {
  //     _storagePermissionCheck = 1;
  //   });
  //   if (result.toString() == 'PermissionStatus.denied') {
  //     return 0;
  //   } else if (result.toString() == 'PermissionStatus.granted') {
  //     return 1;
  //   } else {
  //     return 0;
  //   }
  // }

  Future<int> requestStoragePermission() async {
    Map<Permission, PermissionStatus> result = await [
      Permission.storage,
      //Permission.camera,
      //add more permission to request here.
    ].request();
    // await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (result.toString() == 'PermissionStatus.denied') {
      return 1;
    } else if (result.toString() == 'PermissionStatus.granted') {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 2);
    _tabController.addListener(_handleTabIndex);

    // _storagePermissionChecker = (() async {

    // int storagePermissionCheckInt;
    // int finalPermission;

    //   if (_storagePermissionCheck == null || _storagePermissionCheck == 0) {
    //     _storagePermissionCheck = await checkStoragePermission();
    //   } else {
    //     _storagePermissionCheck = 1;
    //   }

    //   if (_storagePermissionCheck == 1) {
    //     storagePermissionCheckInt = 1;
    //   } else {
    //     storagePermissionCheckInt = 0;
    //   }

    //   if (storagePermissionCheckInt == 1) {
    //     finalPermission = 1;
    //   } else {
    //     finalPermission = 0;
    //   }

    //   return finalPermission;
    // })();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _storagePermissionChecker,
        builder: (context, status) {
          if (status.connectionState == ConnectionState.done) {
            if (status.hasData) {
              if (status.data == 1) {
                return hasPermission();
              } else {
                return askForPermission();
              }
            } else {
              return Container();
            }
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Widget body() {
    //TabController tabController = new TabController(length: 2, vsync: this);
    return TabBarView(
      controller: _tabController,
      children: [
        ImageScreen(),
        VideoScreen(),
      ],
    );
  }

  Widget hasPermission() {
    DateTime _lastExitTime = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        if (DateTime.now().difference(_lastExitTime) >= Duration(seconds: 2)) {
          //showing message to user
          final snack = SnackBar(
            content: Text(Constants.willPopAlert),
            duration: Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          _lastExitTime = DateTime.now();
          return false; // disable back press
        } else {
          return true; //  exit the app
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Constants.primaryColor,
          title: Text(
            Constants.appName,
            style: TextStyle(
                fontFamily: 'Raleway', fontSize: 16, color: Colors.white),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Container(
                height: 30.0,
                child: Text(
                  'IMAGES',
                ),
              ),
              Container(
                height: 30.0,
                child: Text(
                  'VIDEOS',
                ),
              ),
            ],
          ),
        ),
        body: body(),
        //body: Container(),
      ),
    );
  }

  Widget askForPermission() {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Storage Permission Required",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            TextButton(
              child: Text(
                "Allow Storage Permission",
                style: TextStyle(fontSize: 20.0),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.indigo,
                padding: EdgeInsets.all(15.0),
              ),
              onPressed: () {
                setState(() {
                  _storagePermissionChecker = requestStoragePermission();
                });
              },
            )
          ],
        ),
      ),
    );
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }
}
