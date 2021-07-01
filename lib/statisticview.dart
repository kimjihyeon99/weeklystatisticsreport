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

int countactivate() {
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
  int ct;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ct = countactivate();
  }

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
                          builder: (context) => WeeklyStatisticsEdit(
                              items: List<ListItem>.generate(
                                  9,
                                  (i) => ((i % (ct + 1)) == 0 &&
                                          ((i ~/ (ct + 1)) == 0 ||
                                              (i ~/ (ct + 1)) == 1))
                                      ? (i == 0
                                          ? HeadingItem("활성화")
                                          : HeadingItem("비활성화"))
                                      : ((i ~/ (ct + 1)) == 0
                                          ? isActivateItem(
                                              activate[i - 1], true)
                                          : isActivateItem(
                                              deactivate[i - ct - 2],
                                              false))))));
                })
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20.0),
          itemCount: ct,
          itemBuilder: (context, index) {
              return Container(
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
                child: Text(activateName[index],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23.0,
                        color: Colors.black)),
              );
            }
        ));
  }
}
