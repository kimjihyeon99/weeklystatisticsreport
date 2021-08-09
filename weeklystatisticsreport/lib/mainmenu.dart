import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'statisticview.dart';
import 'localnotifyMgr.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class mainmenuPage extends StatefulWidget {
  final ZoomController;

  mainmenuPage(this.ZoomController);

  @override
  _mainmenuPage createState() => new _mainmenuPage(ZoomController);
}

class _mainmenuPage extends State<mainmenuPage> {
  final ZoomController;

  _mainmenuPage(this.ZoomController);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localnotifyMgr.init().setOnNotificationReceive(onNotificationReceive);
    localnotifyMgr.init().setOnNotificationClick(onNotificationClick);

    print(ZoomController);
  }

  onNotificationReceive(ReceiveNotification notification) {
    print('Notification Received : ${notification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload : $payload');

    if (payload.compareTo("new payload") == 0) {
      if (isBuildStatisticviewPage == true) {
        // API를 이미 호출했던 전적이 있는 경우
        Navigator.pop(context);
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => statisticviewPage()));
      }
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text("앱을 종료하시겠습니까?"),
              actions: <Widget>[
                CupertinoButton(
                  child: Text("예"),
                  onPressed: () => SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop'),
                ),
                CupertinoButton(
                  child: Text("아니오"),
                  onPressed: () => Navigator.pop(context, false),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          //그림자 제거
          title: Text(
            'INFOCAR',
            style: TextStyle(fontSize: 23.0, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: PrimaryColor,
          leading: InkWell(
              onTap: () => ZoomController.toggle(), child: Icon(Icons.menu)),
        ),
        body: WillPopScope(
            onWillPop: _onBackPressed,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [PrimaryColor, SecondColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: Column(children: [
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage("assets/bmw_logo.png"),
                            height: 30,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "BMW i4",
                            style: TextStyle(fontSize: 27, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image(
                        image: AssetImage("assets/mycar.png"),
                        height: 110,
                      ),
                    ]),
                    height: 200,
                    width: 360,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: new ColorFilter.mode(
                            Colors.transparent.withOpacity(0.5),
                            BlendMode.dstATop),
                        image: AssetImage("assets/background_car.jpg"),
                      ),
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(3, 3),
                          // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                  //car img
                  SizedBox(
                    height: 60,
                  ),
                  makeRow(context,
                      first: '주간통계',
                      second: '차량진단',
                      third: '대시보드',
                      icons: Icon(
                        Icons.leaderboard_outlined,
                        size: 40,
                        color: PrimaryColor,
                      ),
                      icons2: Icon(
                        Icons.search,
                        size: 40,
                        color: PrimaryColor,
                      ),
                      icons3: Icon(
                        Icons.pie_chart_outline_outlined,
                        size: 40,
                        color: PrimaryColor,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  makeRow(context,
                      first: '주행기록',
                      second: '운전스타일',
                      third: '차량관리',
                      icons: Icon(
                        Icons.location_on_outlined,
                        size: 40,
                        color: PrimaryColor,
                      ),
                      icons2: Icon(
                        Icons.directions_car,
                        size: 40,
                        color: PrimaryColor,
                      ),
                      icons3: Icon(
                        Icons.handyman_outlined,
                        size: 40,
                        color: PrimaryColor,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  makeRow(context,
                      first: '모니터링',
                      second: '엔진상태',
                      third: '설정',
                      icons: Icon(
                        Icons.monitor,
                        size: 40,
                        color: PrimaryColor,
                      ),
                      icons2: Icon(
                        Icons.local_gas_station,
                        size: 40,
                        color: PrimaryColor,
                      ),
                      icons3: Icon(
                        Icons.settings,
                        size: 40,
                        color: PrimaryColor,
                      )),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            )));
  }

  Widget makeRow(BuildContext context,
      {String first,
      String second,
      String third,
      Icon icons,
      Icon icons2,
      Icon icons3}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          child: CupertinoButton(
            onPressed: () {
              if (first.compareTo('주간통계') == 0) {
                if (isBuildStatisticviewPage == true) {
                  // API를 이미 호출했던 전적이 있는 경우
                  Navigator.pop(context);
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => statisticviewPage()));
                }
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icons,
                Text(
                  first,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          width: 100,
          height: 100,
          //150.8
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(3, 3),
                // changes position of shadow
              ),
            ],
          ),
        ),
        Container(
          child: CupertinoButton(
            onPressed: () async {
              if (second.compareTo('차량진단') == 0) {
                // await localnotifyMgr.init().showNotification(); //test용
                await localnotifyMgr.init().showWeeklyAtDayTimeNotification();
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icons2,
                Text(
                  second,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(3, 3),
                // changes position of shadow
              ),
            ],
          ),
        ),
        Container(
          child: CupertinoButton(
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icons3,
                Text(
                  third,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(3, 3),
                // changes position of shadow
              ),
            ],
          ),
        ),
      ],
    );
  }
}
