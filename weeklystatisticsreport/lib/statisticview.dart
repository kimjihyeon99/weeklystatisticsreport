import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'WeeklyStatisticsEdit.dart';
import 'containerItem.dart';
import 'infocarapi_mgr.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main/main_screen.dart';

//activate 와 deactivate 구분하기 위한 list
List activate = [
  "안전 점수",
  "경제 점수",
  "운전스타일 경고 횟수",
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
  "운전스타일 경고 횟수",
  "일일 연비",
  "주행 거리",
  "지출 내역",
  "점검 필요 항목"
];

//이름에 따른 활성화 여부 맵
Map Activateinfo = {
  "안전 점수": true,
  "경제 점수": true,
  "운전스타일 경고 횟수": true,
  "일일 연비": true,
  "주행 거리": true,
  "지출 내역": true,
  "점검 필요 항목": true
};
//item lsit

//보낼 정보 초기화하기
List<ListItem> mylist;

//처음 activate 개수를 세기 위한것
int firstcountactivate() {
  int count = 0;
  for (int i = 0; i < Activateinfo.length; i++) {
    if (Activateinfo[activateName[i]] == true) {
      count = count + 1;
    }
  }
  return count;
}

//color initialize
const PrimaryColor = const Color(0xff3C5186);
const SecondColor = const Color(0xFFC6B4CE);

bool isBuildStatisticviewPage = false; // Api를 한번만 호출하기 위해 사용

class statisticviewPage extends StatefulWidget {
  statisticviewPage({Key key}) : super(key: key);

  @override
  statistic_viewPage createState() => new statistic_viewPage();
}

class statistic_viewPage extends State<statisticviewPage> {
  Future<String> myapi;

  void initState() {
    super.initState();
    isBuildStatisticviewPage = true;

    myapi = getallapi();
    _loadInfo();
  }

  _loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      activate = prefs.getStringList('activate') ??
          [
            "안전 점수",
            "경제 점수",
            "운전스타일 경고 횟수",
            "일일 연비",
            "주행 거리",
            "지출 내역",
            "점검 필요 항목"
          ];
      deactivate = prefs.getStringList('deactivate') ?? [];

      Activateinfo['안전 점수'] = prefs.getBool('isactivate1') ?? true;
      Activateinfo['경제 점수'] = prefs.getBool('isactivate2') ?? true;
      Activateinfo['운전스타일 경고 횟수'] = prefs.getBool('isactivate3') ?? true;
      Activateinfo['일일 연비'] = prefs.getBool('isactivate4') ?? true;
      Activateinfo['주행 거리'] = prefs.getBool('isactivate5') ?? true;
      Activateinfo['지출 내역'] = prefs.getBool('isactivate6') ?? true;
      Activateinfo['점검 필요 항목'] = prefs.getBool('isactivate7') ?? true;
    });

    int initcount = firstcountactivate();

    mylist = List<ListItem>.generate(
        9,
        (i) => ((i % (initcount + 1)) == 0 &&
                ((i ~/ (initcount + 1)) == 0 || (i ~/ (initcount + 1)) == 1))
            ? (i == 0 ? HeadingItem("활성화") : HeadingItem("비활성화"))
            : ((i ~/ (initcount + 1)) == 0
                ? isActivateItem(activate[i - 1], true)
                : isActivateItem(deactivate[i - initcount - 2], false)));
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          title: new Center(
            child: new Text(
              '주간 통계',
              textAlign: TextAlign.center,
              style: new TextStyle(fontSize: 25.0, color: Colors.white),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
          ),
          actions: <Widget>[
            new IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
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
                                  "✔ 앱 내의 흩어져있는 차량 정보들을 수집하여 일주일마다 통계를 냅니다.\n\n ✔ 매주 월요일에 오전에 업데이트 되고 알림이 제공됩니다. \n\n ✔ 설정버튼을 눌러 통계 정보들의 위치와 \n활성화 여부를 선택할 수 있습니다. "),
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
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () async {
                  final returnData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WeeklyStatisticsEditPage(items: mylist)));

                  setState(() {
                    mylist = returnData;
                  });
                })
          ],
        ),
        body: WillPopScope(
            //물리적 뒤로가기 처리
            onWillPop: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
              return Future.value(true);
            },
            child: FutureBuilder(
              future: myapi,
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [PrimaryColor, SecondColor],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      alignment: Alignment.center,
                      child: SpinKitFadingCube(
                        color: SecondColor,
                        size: 40,
                      ));
                } else {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [PrimaryColor, SecondColor],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                        ),
                        child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(20.0),
                            itemCount: activate.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return new uploadtimeContainer().mycon;
                              } else {
                                final itemname = activate[index - 1];
                                String name = itemname;

                                //name이랑 activatename과 비교해서 같으면 해당 container를 반환하기
                                if (name.compareTo(activateName[0]) == 0) {
                                  return new saftyscoreContainer().mycon;
                                } else if (name.compareTo(activateName[1]) ==
                                    0) {
                                  return new economicscoreContainer().mycon;
                                } else if (name.compareTo(activateName[2]) ==
                                    0) {
                                  return new drivingwarningscoreContainer()
                                      .mycon;
                                } else if (name.compareTo(activateName[3]) ==
                                    0) {
                                  return new daliyfuelContainer().mycon;
                                } else if (name.compareTo(activateName[4]) ==
                                    0) {
                                  return new drivingdistanceContainer().mycon;
                                } else if (name.compareTo(activateName[5]) ==
                                    0) {
                                  return new spendingContainer().mycon;
                                } else if (name.compareTo(activateName[6]) ==
                                    0) {
                                  return new inspectionContainer().mycon;
                                }
                              }
                            }),
                      ),
                      Positioned(
                        bottom: 0.0,
                        right: (MediaQuery.of(context).size.width - 70) / 2,
                        left: (MediaQuery.of(context).size.width - 70) / 2,
                        child: Container(
                          child: CupertinoButton(
                            child: Container(
                                child: RotatedBox(
                              quarterTurns: 3,
                              child: Icon(
                                Icons.double_arrow_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            )),
                            onPressed: () {
                              _scrollController.animateTo(
                                  _scrollController.position.minScrollExtent,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn);
                            },
                          ),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: SecondColor,
                          ),
                        ),
                      )
                    ],
                  );
                }
              },
            )));
  }
}
