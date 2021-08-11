import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:weeklystatisticsreport/main/menu_screen.dart';
import 'mainmenu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
          fontFamily: 'bitro',
          textTheme: TextTheme(
              bodyText1: TextStyle(
                  fontSize: 15.0,
                  color: Color(0xff3C5186),
                  fontWeight: FontWeight.bold)),
          primaryColor: PrimaryColor,
          canvasColor:Colors.white54),
      home: MyHomePage(),
      navigatorKey: navigatorKey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZoomDrawer(
        controller: drawerController,
        style: DrawerStyle.Style1,
        menuScreen: MenuScreen(),
        mainScreen: mainmenuPage(drawerController),
        borderRadius: 24.0,
        showShadow: true,
        angle: 0.0,
        backgroundColor: SecondColor,
        slideWidth: MediaQuery.of(context).size.width * .5,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.easeInBack,
      ),
    );
  }
}
