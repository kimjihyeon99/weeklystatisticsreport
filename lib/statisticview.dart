import 'package:flutter/material.dart';
import 'mainmenu.dart';

class statisticview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Generated App',
      theme: new ThemeData(
          primaryColor: const Color(0xff2980b9),
          accentColor: const Color(0xff2980b9),
          canvasColor: const Color(0xff2980b9)),
      home: new statisticviewPage(),
    );
  }
}

class statisticviewPage extends StatefulWidget {
  statisticviewPage({Key key}) : super(key: key);

  @override
  statistic_viewPage createState() => new statistic_viewPage();
}

class statistic_viewPage extends State<statisticviewPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(
          child: new Text(
            '주간 통계',
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 25.0,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => mainmenu()));
          },
        ),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                  //팝업창 만들기
              }),
          new IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                  //아영이 화면 가져오기
              })
        ],
      ),
      body: new Container(),
    );
  }
}
