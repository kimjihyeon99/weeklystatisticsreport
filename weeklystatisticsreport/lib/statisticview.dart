import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'mainmenu.dart';
import 'WeeklyStatisticsEdit.dart';
import 'containerItem.dart';
import 'infocarapi_mgr.dart';

//activate 와 deactivate 구분하기 위한 list
List activate = [
  "안전 점수",
  "경제 점수",
  "운전스타일 경고 점수",
  "일일 연비",
  "주행 거리",
  "지출 내역",
  "점검 필요 항목"
];
List deactivate = [];

//이름 저장소
List<String> activateName = [
  "안전 점수",
  "경제 점수",
  "운전스타일 경고 점수",
  "일일 연비",
  "주행 거리",
  "지출 내역",
  "점검 필요 항목"
];

//이름에 따른 활성화 여부 맵
Map Activateinfo = {
  "안전 점수": true,
  "경제 점수": true,
  "운전스타일 경고 점수": true,
  "일일 연비": true,
  "주행 거리": true,
  "지출 내역": true,
  "점검 필요 항목": true
};
//item lsit
int initcount = firstcountactivate();

//보낼 정보 초기화하기
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

  void initState() {
    // TODO: implement initState
    super.initState();
    //api 호출
    getsafyscore();
    getdaliyfuel();//주간 평균 연비 확인 기능 - 연료소비 api
    getdrivingdistance();// 주간 주행거리 확인 기능 api
    getdecelerationscore();
    getaccelerationscore();
    getrotationscore();
    getidlescore();
    getSpending();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff2980b9), Color(0xFFD8BFD8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: activate.length,
              itemBuilder: (context, index) {
                final itemname = activate[index];
                String name = itemname;

                //name이랑 activatename과 비교해서 같으면 해당 container를 반환하기
                if (name.compareTo(activateName[0]) == 0) {
                  return new saftyscoreContainer().mycon;
                } else if (name.compareTo(activateName[1]) == 0) {
                  return new economicscoreContainer().mycon;
                } else if (name.compareTo(activateName[2]) == 0) {
                  return new drivingwarningscoreContainer().mycon;
                } else if (name.compareTo(activateName[3]) == 0) {
                  return new daliyfuelContainer().mycon;
                } else if (name.compareTo(activateName[4]) == 0) {
                  return new drivingdistanceContainer().mycon;
                } else if (name.compareTo(activateName[5]) == 0) {
                  return new spendingContainer().mycon;
                } else if (name.compareTo(activateName[6]) == 0) {
                  return new inspectionContainer().mycon;
                }
              }),
        )


    );
  }
}
