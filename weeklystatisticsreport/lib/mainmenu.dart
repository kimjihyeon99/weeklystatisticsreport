import 'package:flutter/material.dart';
import 'statisticview.dart';
import 'localnotifyMgr.dart';

const PrimaryColor = const Color(0xff2980b9);

void main() {
  runApp(mainmenu());
}

class mainmenu extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'INFOCAR',
      theme: new ThemeData(
          fontFamily: 'bitro',
          primaryColor: const Color(0xff2980b9),
          accentColor: const Color(0x002980b9),
          canvasColor: const Color(0x002980b9)),
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => statisticview()));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                colors: [PrimaryColor, Color(0xFFD8BFD8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Column(
            children: <Widget>[
              makeRow(context,
                  left: '주간통계',
                  right: '차량진단',
                  icons: Icon(
                    Icons.leaderboard_outlined,
                    size: 70,
                  ),
                  icons2: Icon(
                    Icons.search,
                    size: 70,
                  )),
              makeRow(context,
                  left: '대시보드',
                  right: '주행기록',
                  icons: Icon(
                    Icons.pie_chart_outline_outlined,
                    size: 70,
                  ),
                  icons2: Icon(
                    Icons.location_on_outlined,
                    size: 70,
                  )),
              makeRow(context,
                  left: '운전스타일',
                  right: '차량관리',
                  icons: Icon(
                    Icons.directions_car,
                    size: 70,
                  ),
                  icons2: Icon(
                    Icons.handyman_outlined,
                    size: 70,
                  )),
              makeRow(context,
                  left: '엔진상태',
                  right: '설정',
                  icons: Icon(
                    Icons.local_gas_station,
                    size: 70,
                  ),
                  icons2: Icon(
                    Icons.settings,
                    size: 70,
                  )),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ));
  }

  Widget makeRow(BuildContext context,
      {String left, String right, Icon icons, Icon icons2}) {
    return Row(
      children: <Widget>[
        Container(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) return null;
                  return PrimaryColor.withOpacity(
                      0); // Use the component's default.
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              )),
            ),
            onPressed: () {
              if (left.compareTo('주간통계') == 0) {
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
                  left,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 23.0, color: Colors.white),
                ),
              ],
            ),
          ),
          width: 180,
          height: 140.8,
          //150.8
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18.0),
          ),
          margin: EdgeInsets.only(left: 0, right: 0),
        ),
        Container(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) return null;
                  return PrimaryColor.withOpacity(
                      0); // Use the component's default.
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              )),
            ),
            onPressed: () async {
              if (right.compareTo('차량진단') == 0) {
                // await localnotifyMgr.init().showNotification(); //test용
                await localnotifyMgr.init().showNotification();
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                icons2,
                Text(
                  right,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 23.0, color: Colors.white),
                ),
              ],
            ),
          ),
          width: 180,
          height: 140.8,
          //150.8
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18.0),
          ),
          margin: EdgeInsets.only(left: 0, right: 0),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}
