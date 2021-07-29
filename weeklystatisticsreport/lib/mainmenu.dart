import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'statisticview.dart';
import 'localnotifyMgr.dart';

const PrimaryColor = const Color(0xff3C5186);

void main() {
  runApp(mainmenu());
}

class mainmenu extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'INFOCAR',
      theme: new ThemeData(
          fontFamily: 'bitro',
          primaryColor: const Color(0xff3C5186),
          accentColor: const Color(0xff3C5186),
          canvasColor: const Color(0xff3C5186)),
      home: new mainmenuPage(),
    );
  }
}

class mainmenuPage extends StatefulWidget {
  mainmenuPage({Key key}) : super(key: key);

  @override
  _mainmenuPage createState() => new _mainmenuPage();
}

class _mainmenuPage extends State<mainmenuPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localnotifyMgr.init().setOnNotificationReceive(onNotificationReceive);
    localnotifyMgr.init().setOnNotificationClick(onNotificationClick);
  }

  onNotificationReceive(ReceiveNotification notification) {
    print('Notification Received : ${notification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload : $payload');

    if (payload.compareTo("new payload") == 0) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => mainmenu()));
    }
  }

  AlignmentGeometry _alignment = Alignment.centerLeft;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _alignment = _alignment == Alignment.centerLeft
          ? Alignment.centerRight
          : Alignment.centerLeft;
    });

    return new Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            'INFOCAR',
            style: TextStyle(fontSize: 23.0, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: PrimaryColor,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [PrimaryColor, Color(0xFFC6B4CE)],
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
                  SizedBox(height: 25,),
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
                        style: TextStyle(fontSize: 27,color: Colors.white),
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
                  image:
                  DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: new ColorFilter.mode(
                          Colors.transparent.withOpacity(0.5), BlendMode.dstATop),
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
        ));
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => statisticview()));
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                icons,
                Text(
                  first,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: "bitro", fontSize: 15.0, color: PrimaryColor, fontWeight: FontWeight.bold),
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
          margin: EdgeInsets.only(left: 0, right: 0),
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
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                icons2,
                Text(
                  second,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: "bitro",fontSize: 15.0, color: PrimaryColor, fontWeight: FontWeight.bold),
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
          margin: EdgeInsets.only(left: 0, right: 0),
        ),
        Container(
          child: CupertinoButton(
            onPressed: () {},
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                icons3,
                Text(
                  third,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: "bitro",fontSize: 15.0, color: PrimaryColor, fontWeight: FontWeight.bold),
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
          margin: EdgeInsets.only(left: 0, right: 0),
        ),
      ],
    );
  }
}
