import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'mainmenu.dart';
import 'WeeklyStatisticsEdit.dart';

List<String> activateName = [
  "안전 점수",
  "경제 점수",
  "운전스타일 경고 점수",
  "일일 연비",
  "주행 거리",
  "지출 내역",
  "점검 필요항목"
];
List activate;
List deactivate;
Map Activateinfo = {
  "안전 점수": true,
  "경제 점수": true,
  "운전스타일 경고 점수": true,
  "일일 연비": true,
  "주행 거리": false,
  "지출 내역": true,
  "점검 필요항목": true
};
//item lsit
int initcount = firstcountactivate();

List<ListItem> mylist = List<ListItem>.generate(
    9,
    (i) => ((i % (initcount + 1)) == 0 &&
            ((i ~/ (initcount + 1)) == 0 || (i ~/ (initcount + 1)) == 1))
        ? (i == 0 ? HeadingItem("활성화") : HeadingItem("비활성화"))
        : ((i ~/ (initcount + 1)) == 0
            ? isActivateItem(activate[i - 1], true)
            : isActivateItem(deactivate[i - initcount - 2], false)));

//처음 activate 개수를 세기 위한것
int firstcountactivate() {
  int count = 0;
  activate = [];
  deactivate = [];

  for (int i = 0; i < Activateinfo.length; i++) {
    if (Activateinfo[activateName[i]] == true) {
      activate.add(activateName[i]);
      count = count + 1;
    } else {
      deactivate.add(activateName[i]);
    }
  }
  return count;
}

//처음 이후 activate 개수를 세기 위한것
int countactivate() {
  int count = 0;
  activate = [];
  deactivate = [];

  for (int i = 0; i < mylist.length; i++) {
    final item = mylist[i];
    if (item is isActivateItem) {
      if (item.isactivate) {
        activate.add(item.Activatename);
        count = count + 1;
      } else {
        deactivate.add(item.Activatename);
      }
    }
  }
  return count;
}

/////////////////////////container class, 각자의 container 생성을 위한것
abstract class containerItem {}

class container1 implements containerItem {
  final String activatename = activateName[0];
  final Container mycon = new Container(
    margin: EdgeInsets.symmetric(vertical: 10.0),
    padding: EdgeInsets.all(15),
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(5, 5), // changes position of shadow
        ),
      ],
    ),
    child: Text(activateName[0],
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.black)),
  );

  container1();
}

class container2 implements containerItem {
  final String activatename = activateName[1];
  final Container mycon = new Container(
    margin: EdgeInsets.symmetric(vertical: 10.0),
    padding: EdgeInsets.all(15),
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(5, 5), // changes position of shadow
        ),
      ],
    ),
    child: Text(activateName[1],
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.black)),
  );

  container2();
}

class container3 implements containerItem {
  final String activatename = activateName[2];
  final Container mycon = new Container(
    margin: EdgeInsets.symmetric(vertical: 10.0),
    padding: EdgeInsets.all(15),
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(5, 5), // changes position of shadow
        ),
      ],
    ),
    child: Text(activateName[2],
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.black)),
  );

  container3();
}

class container4 implements containerItem {
  final String activatename = activateName[3];
  final Container mycon = new Container(
    margin: EdgeInsets.symmetric(vertical: 10.0),
    padding: EdgeInsets.all(15),
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(5, 5), // changes position of shadow
        ),
      ],
    ),
    child: Text(activateName[3],
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.black)),
  );

  container4();
}

class container5 implements containerItem {
  final String activatename = activateName[4];
  final Container mycon = new Container(
    margin: EdgeInsets.symmetric(vertical: 10.0),
    padding: EdgeInsets.all(15),
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(5, 5), // changes position of shadow
        ),
      ],
    ),
    child: Text(activateName[4],
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.black)),
  );

  container5();
}

class container6 implements containerItem {
  final String activatename = activateName[5];
  final Container mycon = new Container(
    margin: EdgeInsets.symmetric(vertical: 10.0),
    padding: EdgeInsets.all(15),
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(5, 5), // changes position of shadow
        ),
      ],
    ),
    child: Text(activateName[5],
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.black)),
  );

  container6();
}

class container7 implements containerItem {
  final String activatename = activateName[6];
  final Container mycon = new Container(
    margin: EdgeInsets.symmetric(vertical: 10.0),
    padding: EdgeInsets.all(15),
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(5, 5), // changes position of shadow
        ),
      ],
    ),
    child: Text(activateName[6],
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.black)),
  );

  container7();
}

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
  final List<containerItem> ci = [
    container1(),
    container2(),
    container3(),
    container4(),
    container5(),
    container6(),
    container7()
  ];

  @override
  Widget build(BuildContext context) {
    List<ListItem> myactivelist = new List();
    //container 출력을 위해 activate만 myactivelist에 추가하기
    for (int i = 0; i < mylist.length; i++) {
      final item = mylist[i];
      if (item is isActivateItem) {
        if (item.isactivate) {
          myactivelist.add(item);
        }
      }
    }

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
                  //팝업창
                  showCupertinoDialog(
                      context: context,
                      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return new Container(
                            height: 800.0,
                            child: CupertinoAlertDialog(
                              //Dialog Main Title
                              title: Column(
                                children: <Widget>[
                                  new Text("주간 통계"),
                                  new Container(
                                      height: 1.0,
                                      width: 400.0,
                                      color: Colors.grey)
                                ],
                              ),
                              content: new Text(
                                  "앱 내의 흩어져있는 차량 정보들을 수집하여 일주일마다 통계를 냅니다.\n\n ✔ 매주 월요일에 오전에 업데이트 됩니다. \n\n ✔ 설정버튼을 눌러 통계 정보들의 위치와 \n활성화 여부를 선택할 수 있습니다. "),
                              actions: <Widget>[
                                new TextButton(
                                  child: Text("확인"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ));
                      });
                }),
            new IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          //현재 list 정보 같이 보내기
                              WeeklyStatisticsEdit(items: mylist)));
                })
          ],
        ),
        body: ListView.builder(
            padding: const EdgeInsets.all(20.0),
            itemCount: myactivelist.length,
            itemBuilder: (context, index) {
              final item = myactivelist[index];
              String name;
              //activate name 알아내기
              if (item is isActivateItem) {
                name = item.Activatename;
              }
              //ci(container list)를 전체 돌면서, activatename과 비교 후 해당하면 반환하기
              for (int i = 0; i < ci.length; i++) {
                var item = ci[i];
                if (item is container1) {
                  if (name.compareTo(item.activatename) == 0) {
                    return item.mycon;
                  }
                } else if (item is container2) {
                  if (name.compareTo(item.activatename) == 0) {
                    return item.mycon;
                  }
                } else if (item is container3) {
                  if (name.compareTo(item.activatename) == 0) {
                    return item.mycon;
                  }
                } else if (item is container4) {
                  if (name.compareTo(item.activatename) == 0) {
                    return item.mycon;
                  }
                } else if (item is container5) {
                  if (name.compareTo(item.activatename) == 0) {
                    return item.mycon;
                  }
                } else if (item is container6) {
                  if (name.compareTo(item.activatename) == 0) {
                    return item.mycon;
                  }
                } else if (item is container7) {
                  if (name.compareTo(item.activatename) == 0) {
                    return item.mycon;
                  }
                }
              }
            }));
  }
}
