import 'package:flutter/material.dart';

const PrimaryColor = const Color(0xff2980b9);

void main() {
  runApp(mainmenu());
}

class mainmenu extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'INFOCAR',
      theme: new ThemeData(
          primaryColor: const Color(0xff2980b9),
          accentColor: const Color(0xff2980b9),
          canvasColor: const Color(0xff2980b9)),
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
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          'INFOCAR',
          style: TextStyle(fontSize: 23.0, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: PrimaryColor,
      ),
      body: Column(
        children: <Widget>[
          makeRow(context,
              left: '차량통계',
              right: '차량진단',
              icons: Icon(
                Icons.leaderboard_outlined,
                size: 100,
              ),
              icons2: Icon(
                Icons.add_chart,
                size: 100,
              )),
          makeRow(context,
              left: '대시보드',
              right: '주행기록',
              icons: Icon(
                Icons.pie_chart_outline_outlined,
                size: 100,
              ),
              icons2: Icon(
                Icons.location_on_outlined,
                size: 100,
              )),
          makeRow(context,
              left: '운전스타일',
              right: '차량관리',
              icons: Icon(
                Icons.directions_car,
                size: 100,
              ),
              icons2: Icon(
                Icons.handyman_outlined,
                size: 100,
              )),
          makeRow(context,
              left: '엔진상태',
              right: '설정',
              icons: Icon(
                Icons.local_gas_station,
                size: 100,
              ),
              icons2: Icon(
                Icons.settings,
                size: 100,
              )),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  Widget makeRow(BuildContext context,
      {String left, String right, Icon icons, Icon icons2}) {
    return Row(
      children: <Widget>[
        Container(
          child: Center(
              child: Column(
            children: [
              icons,
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) return null;
                      return new Color(
                          0xff2980b9); // Use the component's default.
                    },
                  ),
                ),
                child: Text(
                  left,
                  style: TextStyle(fontSize: 23.0, color: Colors.white),
                ),
                onPressed: () {
                  if (left.compareTo('차량통계') == 0) {}
                },
              )
            ],
          )),
          width: 205,
          height: 150.8,
          //150.8
          decoration: BoxDecoration(
            color: PrimaryColor,
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          margin: EdgeInsets.only(left: 0, right: 0),
        ),
        Container(
          child: Center(
              child: Column(
            children: [
              icons2,
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) return null;
                      return new Color(
                          0xff2980b9); // Use the component's default.
                    },
                  ),
                ),
                child: Text(
                  right,
                  style: TextStyle(fontSize: 23.0, color: Colors.white),
                ),
                onPressed: () {
                  if (left.compareTo('차량통계') == 0) {}
                },
              )
            ],
          )),
          width: 205,
          height: 150.8,
          decoration: BoxDecoration(
              color: PrimaryColor,
              border: Border.all(color: Colors.white, width: 1.5)),
          margin: EdgeInsets.only(left: 0, right: 0),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
