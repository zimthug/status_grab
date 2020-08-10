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
  DateTime currentBackPressTime = DateTime.now();
  int _storagePermissionCheck;
  Future<int> _storagePermissionChecker;
  TabController _tabController;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 4)) {
      currentBackPressTime = now;
      final snackBar = SnackBar(content: Text(Constants.willPopAlert));
      _scaffoldkey.currentState.showSnackBar(snackBar);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future<int> checkStoragePermission() async {
    PermissionStatus result = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    setState(() {
      _storagePermissionCheck = 1;
    });
    if (result.toString() == 'PermissionStatus.denied') {
      return 0;
    } else if (result.toString() == 'PermissionStatus.granted') {
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> requestStoragePermission() async {
    Map<PermissionGroup, PermissionStatus> result =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
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

    _storagePermissionChecker = (() async {
      int storagePermissionCheckInt;
      int finalPermission;

      if (_storagePermissionCheck == null || _storagePermissionCheck == 0) {
        _storagePermissionCheck = await checkStoragePermission();
      } else {
        _storagePermissionCheck = 1;
      }

      if (_storagePermissionCheck == 1) {
        storagePermissionCheckInt = 1;
      } else {
        storagePermissionCheckInt = 0;
      }

      if (storagePermissionCheckInt == 1) {
        finalPermission = 1;
      } else {
        finalPermission = 0;
      }

      return finalPermission;
    })();
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

  Widget hasPermission() {
    //TabController tabController = new TabController(length: 2, vsync: this);

    return WillPopScope(
      onWillPop: onWillPop,
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
            FlatButton(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Allow Storage Permission",
                style: TextStyle(fontSize: 20.0),
              ),
              color: Colors.indigo,
              textColor: Colors.white,
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
