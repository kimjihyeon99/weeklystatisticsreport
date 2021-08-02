import 'statisticview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'save_getapi.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'dart:math'; //random 수 가져오기 위한것

//가져온 api 정보 임시 저장소
List<Getdrivingscore> saftyscorelist = []; //2주동안 안전운전 점수
List<Getdrivingscore> economicscorelist = []; //2주동안 경제운전 점수
List<Getdaliyfuel> daliyfuellist = []; //2주동안 일일 연비
List<GetDrivingwarningscore> countAllEventForEachDay =
    []; //2주동안 일일 이벤트 경고 횟수 총합
List<CountEventForEvent> countEventForLastWeek = []; //지난주 이벤트별 총 횟수
List<CountEventForEvent> countEventForThisWeek = []; //이번주 이벤트별 총 횟수
double thisTotalEventCountAvgForAllUser = 0; // 이번주 전체 사용자 이벤트 평균횟수
List<GetSpending> spendinglist_last = []; //지난주 지출 내역
List<GetSpending> spendinglist_this = []; //이번주 지출 내역
List<String> replace_item = []; //점검 필요항목 리스트

int drivingdistancelist_this = 0; //이번주 주행 거리
int drivingdistancelist_last = 0; //지난주 주행 거리
int Totaldrivingdistancelist_this = 0; //앱 이용자들의 이번주 주행 거리 평균
int maxdistance = 0; // 이번주와 지난주 중 더 긴 주행 거리 저장
int countAllEventForLastWeek = 0; //지난주 모든 이벤트 경고 횟수
int countAllEventForThisWeek = 0; //이번주 모든 이벤트 경고 횟수
int sumAllspending_last = 0; //지난주 지출 총합
int sumAllspending_this = 0; //이번주 지출 총합

int lastweekcnt = 0; //지난주 주행하지 않은 횟수, 멘트를 위한 것
//평균 점수
//safe
double safethisavg = 0;
double safelastavg = 0;
// eco
double ecothisavg = 0;
double ecolastavg = 0;
//fuel
double fuelthisavg = 0;
double fuellastavg = 0;
double allfluelavg = 0;

//이벤트 경고 횟수가 0개인지 여부
bool isZeroEventCountForLastWeek = true;
bool isZeroEventCountForThisWeek = true;

//멘트 랜덤 정하기
final int mentrandom = Random().nextInt(3);
final int ecomentrandom = Random().nextInt(3);
final int drvmentrandom = Random().nextInt(3);
final int spdmentrandom = Random().nextInt(3);

//안전 점수 : 지난주와  비교하는 코멘트
List safement = [
  "\n지난주보다 안전하게 운전한 덕분에 안전점수가 더 높아졌어요o(*￣▽￣*)o \n 앞으로도 안전운전 부탁해요✨",
  "\n지난주보다 안전점수가 높아졌어요😀 \n 점차 안전점수를 높여보세요!",
  "\n지난주보다 더 안전하게 운전하셨어요! \n 100점을 목표로 고고고🔥",
  "\n이럴수가...저번주보다 점수가 낮아지다니... \n 😥담주에는 조금 더 조심해서 운전해요ಥ_ಥ",
  "\n지난주보다 안전점수가 떨어졌어요😥 \n 다음에는 좀 더 안전하게 운전해봐요",
  "\n안전점수가 지난번보다 떨어졌어요.. \n 조금 더 분발하세요💪 ",
];

//안전 점수 : 이번주만 데이터 있을 경우 코멘트
List safement2 = [
  "\n베스트 드라이버!!\n앞으로도 안전운전 약속🤙",
  "\n안전 점수가 상위 5% 이네요🏆",
  "\n안전 운행으로 수명 1년 증가!👏",
  "\n안전 운전을 위해 노력하셨네요🎉\n조금 더 노력하면 90점은 충분히 넘겠어요👏",
  "\n안전운전 고생했어요😊\n다음 주에는 90점을 목표로 해요!",
  "\n아쉽게도 90점을 못넘겼네요😥\n조금 더 노력해서 90점을 넘겨봐요✨",
  "\n지속적인 위험운전은\n내 생명을 위협해요.",
  "\n한발먼저 가기전에\n한발멈춰 여유를 가지세요.",
  "\n바쁠수록 양보운전!\n급할수록 안전운전!"
];

//경제 점수 : 지난주와  비교하는 코멘트
List ecoment = [
  "\n지난주보다 더 절약해서 운전 하셨네요!\n돈도 천원 벌었어요💰",
  "\n저번주보다 더 경제적으로 운전하셨네요🤩\n아주 멋져요👍👍",
  "\n지난주보다 경제점수가 높아졌어요😀\n점차 경제점수를 높여보세요!",
  "\n이런, 지난주보다 경제점수가 떨어졌어요..\n이번주는 조금 더 노력해봐요😅",
  "\n저번주보다 경제점수가 낮아지다니💦\n더 노력해서 점수를 올려주세요🤦",
  "\n지난주보다 경제점수가 떨어졌어요😥\n다음에는 좀 더 경제적으로 운전해봐요!",
];

//경제 점수 : 이번주만 데이터 있을 경우 코멘트
List ecoment2 = [
  "\n베스트 드라이버!!\n앞으로도 절약하기 약속🤙",
  "\n90점 달성 축하드려요~\n앞으로도 쭉 이대로만🏃‍♂️",
  "\n절약 운행으로 5천원 벌었어요!\n축하합니다👏",
  "\n경제적으로 운전하려 노력하셨네요👏\n아주 멋져요q(≧▽≦q)",
  "\n80점을 넘다니!\n경제 운전 습관이 점차 배어질거에요😁",
  "\n한주도 고생했어요!\n평균 90점을 목표로 노력해봐요!✨",
  "\n경제운전으로 이산화탄소를 줄여보는 것이 어떨까요?😊",
  "\n한 템포 느린 운전으로\n연비를 감소시켜봐요!",
  "\n경제운전으로 기름값 아끼고\n치킨 한마리 더!🍗"
];

//주행거리 :지난주와 이번주 비교 멘트
List drvment = [
  "이번주에는 저번주보다 덜 운전하셨네요👏\n환경에 큰 도움이 될 거에요🤩",
  "지난주보다 더 적게 달리셨어요~\n시간 날때 드라이브 한번 다녀오세요🚗",
  "주행거리가 지난주보다 감소했네요!\n덕분에 미세먼지 감축에 도움이 되었어요!",
  "저번주보다 이번주에 운전을 더 많이하셨어요!\n안전운전에 주의하세요😉",
  "저번주보다 더 많이 달리셨어요~\n세차한번 하고 오세요🌊  ",
  "주행거리가 저번주보다 증가했네요!\n여행이라도 다녀오신건가요?⛱",
];

//지출 내역 :지난주와 이번주 비교 멘트
List spdment = [
  "저번주보다 지출이 줄었어요👍👍\n이번주도 줄일 수 있도록 노력해봐요😁",
  "지난주 보다 지출 내역이 감소했어요 \n 좋은 운전 습관을 가지고 계시네요👍",
  "지출이 지난주보다 적어지셨네요!\n절약하는 습관 아주좋아요👍",
  "지난주 보다 더 지출 내역이 많네요! \n 경제운전으로 절약해보시면 어떨까요?😂",
  "저번주보다 지출이 많았어요!\n혹시 불필요한 지출은없었는지 생각해보세요😃",
  "지출이 지난주보다 많아지셨네요!\n다음세차는 손세차 어떠세요?🧼"
];

//지출 내역 :이번주 또는 지난주 지출이 없을 경우 멘트
List emptyspdment = [
  "지출 내역을 앞으로 꾸준히 작성하도록 노력해봐요✏\n 절약에 도움이 될거에요!",
  "2주간의 차계부 기록으로\n자신의 소비습관을 비교해보세요😉",
  "소비패턴을 확인하고\n합리적인 소비를 하도록해요!🙌😃",
];

//각자의 container 생성을 위한것
abstract class containerItem {}

class saftyscoreContainer implements containerItem {
  final Container mycon = new Container(
    margin: EdgeInsets.symmetric(vertical: 10.0),
    padding: EdgeInsets.all(15),
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
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(activateName[0],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 27.0,
                      color: Colors.black)),
            ),
            IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.black,
                ),
                onPressed: () {
                  //팝업창
                  showCupertinoDialog(
                      context: navigatorKey.currentContext,
                      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return new Container(
                            height: 800.0,
                            child: CupertinoAlertDialog(
                              //Dialog Main Title
                              title: Column(
                                children: <Widget>[
                                  new Text("안전 점수"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  new Container(
                                      height: 1.0,
                                      width: 400.0,
                                      color: Colors.grey),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                              content: new Text(
                                  "✔안전운점 점수는 주행 중 발생하는 급가속, 급감속, 과속, 급회전과 다양한 주행 정보를 기반으로 산정됩니다.\n ✔그래프를 클릭하여 각 날의 안전 점수를 확인할 수 있습니다.\n✔이번주와 지난주의 일일평균을 비교할 수 있습니다.\n✔지난주에 4일 이상 운전을 하지 않았다면 이번주의 데이터만을 이용하여 아래 멘트가 정해집니다."),
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
          ],
        ),
        SfCartesianChart(
          legend: Legend(isVisible: true, position: LegendPosition.top),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries>[
            ColumnSeries<Getdrivingscore, String>(
                name: "지난주",
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                color: Color(0xFFdedcee),
                dataSource: saftyscorelist.getRange(0, 7).toList(),
                xValueMapper: (Getdrivingscore gf, _) => DateFormat('EEE')
                    .format(new DateTime(
                        int.parse(gf.Date.split("-")[0]),
                        int.parse(gf.Date.split("-")[1]),
                        int.parse(gf.Date.split("-")[2]))),
                yValueMapper: (Getdrivingscore gf, _) => gf.safe_avg),
            ColumnSeries<Getdrivingscore, String>(
                name: "이번주",
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                color: Color(0xFF6a60a9),
                dataSource: saftyscorelist.getRange(7, 14).toList(),
                xValueMapper: (Getdrivingscore gf, _) => DateFormat('EEE')
                    .format(new DateTime(
                        int.parse(gf.Date.split("-")[0]),
                        int.parse(gf.Date.split("-")[1]),
                        int.parse(gf.Date.split("-")[2]))),
                yValueMapper: (Getdrivingscore gf, _) => gf.safe_avg)
          ],
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
            maximum: 100,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        new Container(
            height: 1.0,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.3)),
        SizedBox(
          height: 15,
        ),
        Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "지난주 평균 점수",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "이번주 평균 점수",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "${safelastavg.toStringAsFixed(2)} ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9055A2),
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${safethisavg.toStringAsFixed(2)} ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9055A2),
                        fontSize: 18,
                      ),
                    ),
                  ],
                )
              ],
            )),
        SizedBox(
          height: 15,
        ),
        new Container(
            height: 1.0,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.3)),
        SizedBox(
          height: 5,
        ),
        Align(
            alignment: Alignment.center,
            child: (lastweekcnt > 3) //지난주 주행하지 않은 횟수가 3보다 큰 경우
                ? (safethisavg > 90) // 점수 별로 맞춤 코멘트
                    ? Text(safement2.getRange(0, 3).toList()[mentrandom],
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        textAlign: TextAlign.center)
                    : (safethisavg > 80)
                        ? Text(safement2.getRange(3, 6).toList()[mentrandom],
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            textAlign: TextAlign.center)
                        : Text(safement2.getRange(6, 9).toList()[mentrandom],
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            textAlign: TextAlign.center)
                : (safethisavg > safelastavg)
                    ? Text(safement.getRange(0, 3).toList()[mentrandom],
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        textAlign: TextAlign.center)
                    : Text(safement.getRange(3, 6).toList()[mentrandom],
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        textAlign: TextAlign.center)),
        SizedBox(
          height: 10,
        ),
      ],
    ),
  );

  saftyscoreContainer();
}

class economicscoreContainer implements containerItem {
  final Container mycon = new Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(15),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(activateName[1],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27.0,
                        color: Colors.black)),
              ),
              IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    //팝업창
                    showCupertinoDialog(
                        context: navigatorKey.currentContext,
                        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return new Container(
                              height: 800.0,
                              child: CupertinoAlertDialog(
                                //Dialog Main Title
                                title: Column(
                                  children: <Widget>[
                                    new Text("경제 점수"),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    new Container(
                                        height: 1.0,
                                        width: 400.0,
                                        color: Colors.grey),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                                content: new Text(
                                    "✔경제운전 점수는 주행 중 계산된 연비를 점수화하여, 경제점수가 산정됩니다.\n✔이번주와 저번주의 일일평균을 비교할 수 있습니다."),
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
            ],
          ),
          SfCartesianChart(
            legend: Legend(isVisible: true, position: LegendPosition.top),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
              ColumnSeries<Getdrivingscore, String>(
                  name: "지난주",
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                  color: Color(0xFFCADBE9),
                  dataSource: economicscorelist.getRange(0, 7).toList(),
                  xValueMapper: (Getdrivingscore gf, _) => DateFormat('EEE')
                      .format(new DateTime(
                          int.parse(gf.Date.split("-")[0]),
                          int.parse(gf.Date.split("-")[1]),
                          int.parse(gf.Date.split("-")[2]))),
                  yValueMapper: (Getdrivingscore gf, _) => gf.eco_avg),
              ColumnSeries<Getdrivingscore, String>(
                  name: "이번주",
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                  color: Color(0xFF6AAFE6),
                  dataSource: economicscorelist.getRange(7, 14).toList(),
                  xValueMapper: (Getdrivingscore gf, _) => DateFormat('EEE')
                      .format(new DateTime(
                          int.parse(gf.Date.split("-")[0]),
                          int.parse(gf.Date.split("-")[1]),
                          int.parse(gf.Date.split("-")[2]))),
                  yValueMapper: (Getdrivingscore gf, _) => gf.eco_avg)
            ],
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              maximum: 100,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          new Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.3)),
          SizedBox(
            height: 15,
          ),
          Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "지난주 평균 점수",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "이번주 평균 점수",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "${ecolastavg.toStringAsFixed(2)} ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8EC0E4),
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${ecothisavg.toStringAsFixed(2)} ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8EC0E4),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  )
                ],
              )),
          SizedBox(
            height: 15,
          ),
          new Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.3)),
          SizedBox(
            height: 5,
          ),
          Align(
              alignment: Alignment.center,
              child: (lastweekcnt > 3) //지난주 주행하지 않은 횟수가 3보다 큰 경우
                  ? (ecothisavg > 90) // 점수 별로 맞춤 코멘트
                      ? Text(ecoment2.getRange(0, 3).toList()[ecomentrandom],
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                          textAlign: TextAlign.center)
                      : (ecothisavg > 80)
                          ? Text(
                              ecoment2.getRange(3, 6).toList()[ecomentrandom],
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                              textAlign: TextAlign.center)
                          : Text(
                              ecoment2.getRange(6, 9).toList()[ecomentrandom],
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                              textAlign: TextAlign.center)
                  : (ecothisavg > ecolastavg)
                      ? Text(ecoment.getRange(0, 3).toList()[ecomentrandom],
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                          textAlign: TextAlign.center)
                      : Text(ecoment.getRange(3, 6).toList()[ecomentrandom],
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                          textAlign: TextAlign.center)),
          SizedBox(
            height: 10,
          ),
        ],
      ));

  economicscoreContainer();
}

class drivingwarningscoreContainer implements containerItem {
  final Container mycon = new Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(15),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(activateName[2],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27.0,
                        color: Colors.black)),
              ),
              IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    //팝업창
                    showCupertinoDialog(
                        context: navigatorKey.currentContext,
                        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return new Container(
                              height: 800.0,
                              child: CupertinoAlertDialog(
                                //Dialog Main Title
                                title: Column(
                                  children: <Widget>[
                                    new Text("운전스타일 경고 횟수"),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    new Container(
                                        height: 1.0,
                                        width: 400.0,
                                        color: Colors.grey),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                                content: new Text(
                                    "✔일별로 위험운전행동 발생 횟수를 확인할 수 있습니다.\n✔한 주동안 일어난 급가속, 급감속, 과속, 급회전 횟수를 각각 확인할 수 있고 가운데 횟수는 해당 주에 일어난 위험운전행동 총 횟수를 나타냅니다.\n✔그래프를 클릭하여 자세한 횟수를 확인할 수 있습니다.\n✔이번주와 지난주에 발생한 위험운전행동 횟수를 비교할 수 있습니다."),
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
            ],
          ),
          SfCartesianChart(
            legend: Legend(isVisible: true, position: LegendPosition.top),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
              ColumnSeries<GetDrivingwarningscore, String>(
                  name: "지난주",
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                  color: Color(0xFFF7AA97),
                  dataSource: countAllEventForEachDay.getRange(0, 7).toList(),
                  xValueMapper: (GetDrivingwarningscore gf, _) =>
                      DateFormat('EEE').format(new DateTime(
                          int.parse(gf.Date.split("-")[0]),
                          int.parse(gf.Date.split("-")[1]),
                          int.parse(gf.Date.split("-")[2]))),
                  yValueMapper: (GetDrivingwarningscore gf, _) =>
                      gf.countEvent),
              ColumnSeries<GetDrivingwarningscore, String>(
                  name: "이번주",
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                  color: Color(0xFFDE7E73),
                  dataSource: countAllEventForEachDay.getRange(7, 14).toList(),
                  xValueMapper: (GetDrivingwarningscore gf, _) =>
                      DateFormat('EEE').format(new DateTime(
                          int.parse(gf.Date.split("-")[0]),
                          int.parse(gf.Date.split("-")[1]),
                          int.parse(gf.Date.split("-")[2]))),
                  yValueMapper: (GetDrivingwarningscore gf, _) => gf.countEvent)
            ],
            primaryXAxis: CategoryAxis(),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.5)),
          SizedBox(
            height: 15,
          ),
          Text(
            "유형별 주간 경고 횟수 총합",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(children: [
                Container(
                  width: 10,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xff4A86B8),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                //text
                Text("급감속"),
              ]),
              Row(children: [
                Container(
                  width: 10,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xffC06C84),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                //text
                Text("급가속")
              ]),
              Row(children: [
                Container(
                  width: 10,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xffF67280),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                //text
                Text("급회전"),
              ]),
              Row(children: [
                Container(
                  width: 10,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xffF8B094),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                //text
                Text("공회전"),
              ]),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            //가운데 정렬
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isZeroEventCountForLastWeek //지난주 이벤트 경고 횟수가 0인 경우
                  ? Column(
                      children: [
                        Container(
                          width: 170,
                          height: 170,
                          child: Center(
                            child: Container(
                              child: Text(
                                '이벤트가 일어나지 않았네요.',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              width: 130,
                              height: 130,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: -8,
                                        blurRadius: 5,
                                        offset: Offset(-5, -5),
                                        color: Colors.grey),
                                    BoxShadow(
                                        spreadRadius: -2,
                                        blurRadius: 10,
                                        offset: Offset(7, 7),
                                        color: Colors.black.withOpacity(0.5))
                                  ]),
                            ),
                          ),
                        ),
                        Text(
                          '지난주',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          child: Stack(children: <Widget>[
                            Center(
                              child: Container(
                                width: 115,
                                height: 115,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: -8,
                                          blurRadius: 5,
                                          offset: Offset(-5, -5),
                                          color: Colors.grey),
                                      BoxShadow(
                                          spreadRadius: -2,
                                          blurRadius: 10,
                                          offset: Offset(7, 7),
                                          color: Colors.black.withOpacity(0.5))
                                    ]),
                              ),
                            ),
                            SfCircularChart(
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <CircularSeries>[
                                DoughnutSeries<CountEventForEvent, String>(
                                    dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        labelPosition:
                                            ChartDataLabelPosition.outside,
                                        labelIntersectAction:
                                            LabelIntersectAction.none),
                                    name: "지난주",
                                    dataSource: countEventForLastWeek,
                                    xValueMapper: (CountEventForEvent ce, _) =>
                                        ce.name,
                                    yValueMapper: (CountEventForEvent ce, _) =>
                                        ce.count),
                              ],
                            ),
                            Center(
                              child: Text(
                                countAllEventForLastWeek.toString() + '회',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ]),
                        ),
                        Text(
                          '지난주',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
              SizedBox(
                width: 5,
              ),
              isZeroEventCountForThisWeek //이번주 이벤트 경고 횟수가 0인 경우
                  ? Column(
                      children: [
                        Container(
                          width: 170,
                          height: 170,
                          child: Center(
                            child: Container(
                              child: Text(
                                '이벤트가 일어나지 않았네요.',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              width: 130,
                              height: 130,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: -8,
                                        blurRadius: 5,
                                        offset: Offset(-5, -5),
                                        color: Colors.grey),
                                    BoxShadow(
                                        spreadRadius: -2,
                                        blurRadius: 10,
                                        offset: Offset(7, 7),
                                        color: Colors.black.withOpacity(0.5))
                                  ]),
                            ),
                          ),
                        ),
                        Text(
                          '이번주',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          child: Stack(children: <Widget>[
                            Center(
                              child: Container(
                                width: 115,
                                height: 115,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: -8,
                                          blurRadius: 5,
                                          offset: Offset(-5, -5),
                                          color: Colors.grey),
                                      BoxShadow(
                                          spreadRadius: -2,
                                          blurRadius: 10,
                                          offset: Offset(7, 7),
                                          color: Colors.black.withOpacity(0.5))
                                    ]),
                              ),
                            ),
                            SfCircularChart(
                              legend: Legend(
                                isVisible: false,
                                position: LegendPosition.bottom,
                                title: LegendTitle(
                                    text: '이번주',
                                    textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900)),
                              ),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <CircularSeries>[
                                DoughnutSeries<CountEventForEvent, String>(
                                    dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        labelPosition:
                                            ChartDataLabelPosition.outside,
                                        labelIntersectAction:
                                            LabelIntersectAction.none),
                                    name: "이번주",
                                    dataSource: countEventForThisWeek,
                                    xValueMapper: (CountEventForEvent ce, _) =>
                                        ce.name,
                                    yValueMapper: (CountEventForEvent ce, _) =>
                                        ce.count),
                              ],
                            ),
                            Center(
                              child: Text(
                                countAllEventForThisWeek.toString() + '회',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ]),
                        ),
                        Text(
                          '이번주',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.5)),
          SizedBox(
            height: 15,
          ),
          Text(
            '이번주 경고 횟수 비교',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            child: Text('전체 사용자 평균'),
            alignment: Alignment.centerLeft,
          ),
          FAProgressBar(
            size: 20,
            currentValue: thisTotalEventCountAvgForAllUser.toInt(),
            backgroundColor: Colors.white,
            progressColor: Color(0xFF79bd9a),
            animatedDuration: Duration(milliseconds: 1000),
            maxValue: countAllEventForThisWeek >
                    thisTotalEventCountAvgForAllUser.toInt()
                ? countAllEventForThisWeek
                : thisTotalEventCountAvgForAllUser.toInt(),
            displayText: '회',
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            child: Text('본인'),
            alignment: Alignment.centerLeft,
          ),
          FAProgressBar(
            size: 20,
            currentValue: countAllEventForThisWeek,
            backgroundColor: Colors.white,
            progressColor: countAllEventForThisWeek >
                thisTotalEventCountAvgForAllUser.toInt()
                ? Colors.red
                : Colors.yellow,
            animatedDuration: Duration(milliseconds: 1000),
            maxValue: countAllEventForThisWeek >
                    thisTotalEventCountAvgForAllUser.toInt()
                ? countAllEventForThisWeek
                : thisTotalEventCountAvgForAllUser.toInt(),
            displayText: '회',
          ),
        ],
      ));

  drivingwarningscoreContainer();
}

class daliyfuelContainer implements containerItem {
  final Container mycon = new Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(15),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(activateName[3],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27.0,
                        color: Colors.black)),
              ),
              IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    //팝업창
                    showCupertinoDialog(
                        context: navigatorKey.currentContext,
                        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return new Container(
                              height: 800.0,
                              child: CupertinoAlertDialog(
                                //Dialog Main Title
                                title: Column(
                                  children: <Widget>[
                                    new Text("일일 연비"),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    new Container(
                                        height: 1.0,
                                        width: 400.0,
                                        color: Colors.grey),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                                content: new Text(
                                    "✔ 일일 평균 연비 정보을 요일마다 확인할 수 있습니다.\n✔ 지난주와 이번주의 평균 연비 정보를 비교할 수 있습니다."),
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
            ],
          ),
          SfCartesianChart(
            legend: Legend(isVisible: true, position: LegendPosition.top),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
              LineSeries<Getdaliyfuel, String>(
                name: "지난주",
                color: Color(0xFFaacfd0),
                dataSource: daliyfuellist.getRange(0, 7).toList(),
                xValueMapper: (Getdaliyfuel gf, _) => DateFormat('EEE').format(
                    new DateTime(
                        int.parse(gf.Date.split("-")[0]),
                        int.parse(gf.Date.split("-")[1]),
                        int.parse(gf.Date.split("-")[2]))),
                yValueMapper: (Getdaliyfuel gf, _) => gf.DrvFuelUsement,
                markerSettings: MarkerSettings(
                  isVisible: true,
                  height: 8,
                  width: 8,
                ),
              ),
              LineSeries<Getdaliyfuel, String>(
                name: "이번주",
                color: Color(0xff1f4e5f),
                dataSource: daliyfuellist.getRange(7, 14).toList(),
                xValueMapper: (Getdaliyfuel gf, _) => DateFormat('EEE').format(
                    new DateTime(
                        int.parse(gf.Date.split("-")[0]),
                        int.parse(gf.Date.split("-")[1]),
                        int.parse(gf.Date.split("-")[2]))),
                yValueMapper: (Getdaliyfuel gf, _) => gf.DrvFuelUsement,
                markerSettings: MarkerSettings(
                  isVisible: true,
                  height: 8,
                  width: 8,
                ),
              )
            ],
            primaryXAxis: CategoryAxis(),
          ),
          SizedBox(
            height: 15,
          ),
          new Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.3)),
          SizedBox(
            height: 15,
          ),
          Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "지난주 평균 연비",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "이번주 평균 연비",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Column(
                    children: [  Text(
                      "${fuellastavg.toStringAsFixed(2)} ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff79a8a9),
                        fontSize: 18,
                      ),
                    ),

                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${fuelthisavg.toStringAsFixed(2)} ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff79a8a9),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  )
                ],
              )),
          SizedBox(
            height: 15,
          ),
          new Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.3)),
          SizedBox(
            height: 15,
          ),
          Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "전체 사용자 평균 연비",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  Column(
                    children: [  Text(
                      "${allfluelavg.toStringAsFixed(2)} ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                        fontSize: 18,
                      ),
                    ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  )
                ],
              )),

        ],
      ));

  daliyfuelContainer();
}

class drivingdistanceContainer implements containerItem {
  final Container mycon = new Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(15),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(activateName[4],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27.0,
                        color: Colors.black)),
              ),
              IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    //팝업창
                    showCupertinoDialog(
                        context: navigatorKey.currentContext,
                        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return new Container(
                              height: 800.0,
                              child: CupertinoAlertDialog(
                                //Dialog Main Title
                                title: Column(
                                  children: <Widget>[
                                    new Text("주행 거리"),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    new Container(
                                        height: 1.0,
                                        width: 400.0,
                                        color: Colors.grey),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                                content: new Text(
                                    "✔일주일 동안 주행한 거리의 합을 보여줍니다.\n✔지난주와 이번주 총 주행거리를 확인할 수 있습니다."),
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
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //box
                  Container(
                    width: 10,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color(0xFFcff09e),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  //text
                  Text("지난주")
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //box
                  Container(
                    width: 10,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color(0xFF79bd9a),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  //text
                  Text("이번주")
                ],
              ),

            ],
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
              width: 300,
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.lerp(
                          Alignment.topLeft,
                          Alignment.topRight,
                          drivingdistancelist_last == null
                              ? 0
                              : drivingdistancelist_last / maxdistance),
                      child: Column(
                        children: [
                          Text(
                            "${drivingdistancelist_last == null ? 0 : drivingdistancelist_last} km",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Image(
                            height: 40,
                            width: 40,
                            image: AssetImage('assets/car_img.png'),
                          ),
                        ],
                      )),
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: FAProgressBar(
                        size: 20,
                        currentValue: drivingdistancelist_last == null
                            ? 0
                            : drivingdistancelist_last,
                        backgroundColor: Colors.white,
                        progressColor: Color(0xFFcff09e),
                        animatedDuration: Duration(milliseconds: 1000),
                        maxValue: maxdistance,
                      )),
                ],
              )),
          SizedBox(
              width: 300,
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.lerp(
                          Alignment.topLeft,
                          Alignment.topRight,
                          drivingdistancelist_this == null
                              ? 0
                              : drivingdistancelist_this / maxdistance),
                      child: Column(
                        children: [
                          Text(
                            "${drivingdistancelist_this == null ? 0 : drivingdistancelist_this} km",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Image(
                            height: 40,
                            width: 40,
                            image: AssetImage('assets/car_img.png'),
                          ),
                        ],
                      )),
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: FAProgressBar(
                        size: 20,
                        currentValue: drivingdistancelist_this == null
                            ? 0
                            : drivingdistancelist_this,
                        backgroundColor: Colors.white,
                        progressColor: Color(0xFF79bd9a),
                        animatedDuration: Duration(milliseconds: 1000),
                        maxValue: maxdistance,
                      )),
                ],
              )),
          SizedBox(
            height: 15,
          ),
          Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.5)),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //box
              Container(
                width: 10,
                height: 5,
                decoration: BoxDecoration(
                  color: Color(0xFF3b8686),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              //text
              Text("이번주 모든 사용자")
            ],
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
              width: 300,
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.lerp(
                          Alignment.topLeft,
                          Alignment.topRight,
                          Totaldrivingdistancelist_this == null
                              ? 0
                              : Totaldrivingdistancelist_this / maxdistance),
                      child: Column(
                        children: [
                          Text(
                            "${Totaldrivingdistancelist_this == null ? 0 : Totaldrivingdistancelist_this} km",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Image(
                            height: 40,
                            width: 40,
                            image: AssetImage('assets/car_img.png'),
                          ),
                        ],
                      )),
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: FAProgressBar(
                        size: 20,
                        currentValue: Totaldrivingdistancelist_this == null
                            ? 0
                            : Totaldrivingdistancelist_this,
                        backgroundColor: Colors.white,
                        progressColor: Color(0xFF3b8686),
                        animatedDuration: Duration(milliseconds: 1000),
                        maxValue: maxdistance,
                      )),
                ],
              )),
          SizedBox(
            height: 25,
          ),
          Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.5)),
          SizedBox(
            height: 20,
          ),
          Align(
              alignment: Alignment.center,
              child: ((drivingdistancelist_last == null
                          ? 0
                          : drivingdistancelist_last) >
                      (drivingdistancelist_this == null
                          ? 0
                          : drivingdistancelist_this))
                  //지난주 주행거리가 이번주 주행거리보다 클 경우
                  ? Text(drvment.getRange(0, 3).toList()[drvmentrandom],
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                      textAlign: TextAlign.center)
                  : Text(drvment.getRange(3, 6).toList()[drvmentrandom],
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                      textAlign: TextAlign.center)),
          SizedBox(
            height: 10,
          ),
        ],
      ));

  drivingdistanceContainer();
}

class spendingContainer implements containerItem {
  final Container mycon = new Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(15),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(activateName[5],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23.0,
                        color: Colors.black)),
              ),
              IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    //팝업창
                    showCupertinoDialog(
                        context: navigatorKey.currentContext,
                        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return new Container(
                              height: 800.0,
                              child: CupertinoAlertDialog(
                                //Dialog Main Title
                                title: Column(
                                  children: <Widget>[
                                    new Text("지출 내역"),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    new Container(
                                        height: 1.0,
                                        width: 400.0,
                                        color: Colors.grey),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                                content: new Text(
                                    "✔ 차계부에 기록한 내용을 바탕으로 주간 차트가 띄워집니다.\n✔ 이번주와 저번주의 지출 내역을 비교할 수 있습니다."),
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
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(children: [
                Container(
                  width: 10,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xff4A86B8),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                //text
                Text(
                  "주유•세차비",
                  style: TextStyle(fontSize: 12.5),
                ),
              ]),
              Row(children: [
                Container(
                  width: 10,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xffC06C84),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                //text
                Text(
                  "통행•주차비",
                  style: TextStyle(fontSize: 12.5),
                )
              ]),
              Row(children: [
                Container(
                  width: 10,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xffF67280),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                //text
                Text(
                  "차량정비",
                  style: TextStyle(fontSize: 12.5),
                ),
              ]),
              Row(children: [
                Container(
                  width: 10,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xffF8B094),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                //text
                Text(
                  "보험료",
                  style: TextStyle(fontSize: 12.5),
                ),
              ]),
              Row(children: [
                Container(
                  width: 10,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xff74B49A),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                //text
                Text(
                  "기타",
                  style: TextStyle(fontSize: 12.5),
                ),
              ]),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              sumAllspending_last == 0
                  ? Column(
                      children: [
                        Container(
                          width: 155,
                          height: 155,
                          child: Center(
                            child: Container(
                              child: Text(
                                '지출이 없네요.',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              width: 115,
                              height: 115,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: -8,
                                        blurRadius: 5,
                                        offset: Offset(-5, -5),
                                        color: Colors.grey),
                                    BoxShadow(
                                        spreadRadius: -2,
                                        blurRadius: 10,
                                        offset: Offset(7, 7),
                                        color: Colors.black.withOpacity(0.5))
                                  ]),
                            ),
                          ),
                        ),
                        Text(
                          '지난주',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Container(
                          width: 155,
                          height: 155,
                          child: Stack(children: <Widget>[
                            Center(
                              child: Container(
                                width: 115,
                                height: 115,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: -8,
                                          blurRadius: 5,
                                          offset: Offset(-5, -5),
                                          color: Colors.grey),
                                      BoxShadow(
                                          spreadRadius: -2,
                                          blurRadius: 10,
                                          offset: Offset(7, 7),
                                          color: Colors.black.withOpacity(0.5))
                                    ]),
                              ),
                            ),
                            SfCircularChart(
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <CircularSeries>[
                                DoughnutSeries<GetSpending, String>(
                                    name: "지난주",
                                    dataSource: spendinglist_last,
                                    xValueMapper: (GetSpending ce, _) =>
                                        ce.name,
                                    yValueMapper: (GetSpending ce, _) =>
                                        ce.cost),
                              ],
                            ),
                            Center(
                              child: Text(
                                sumAllspending_last.toString() + '원',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ]),
                        ),
                        Text(
                          '지난주',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
              sumAllspending_this == 0
                  ? Column(
                      children: [
                        Container(
                          width: 155,
                          height: 155,
                          child: Center(
                            child: Container(
                              child: Text(
                                '지출이 없네요.',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              width: 115,
                              height: 115,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: -8,
                                        blurRadius: 5,
                                        offset: Offset(-5, -5),
                                        color: Colors.grey),
                                    BoxShadow(
                                        spreadRadius: -2,
                                        blurRadius: 10,
                                        offset: Offset(7, 7),
                                        color: Colors.black.withOpacity(0.5))
                                  ]),
                            ),
                          ),
                        ),
                        Text(
                          '이번주',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Container(
                          width: 155,
                          height: 155,
                          child: Stack(children: <Widget>[
                            Center(
                              child: Container(
                                //흰색 부분
                                width: 115,
                                height: 115,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: -8,
                                          blurRadius: 5,
                                          offset: Offset(-5, -5),
                                          color: Colors.grey),
                                      BoxShadow(
                                          spreadRadius: -2,
                                          blurRadius: 10,
                                          offset: Offset(7, 7),
                                          color: Colors.black.withOpacity(0.5))
                                    ]),
                              ),
                            ),
                            SfCircularChart(
                              legend: Legend(
                                isVisible: false,
                                position: LegendPosition.bottom,
                                title: LegendTitle(
                                    text: '이번주',
                                    textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900)),
                              ),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <CircularSeries>[
                                DoughnutSeries<GetSpending, String>(
                                    name: "이번주",
                                    dataSource: spendinglist_this,
                                    xValueMapper: (GetSpending ce, _) =>
                                        ce.name,
                                    yValueMapper: (GetSpending ce, _) =>
                                        ce.cost),
                              ],
                            ),
                            Center(
                              child: Text(
                                sumAllspending_this.toString() + '원',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                        ),
                        Text(
                          '이번주',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
            ],
          ),
          SizedBox(height: 15),
          Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.5)),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: (sumAllspending_last == 0 || sumAllspending_this == 0)
                ? //지난주나 이번주 지출내역이 없는 경우
                Text(emptyspdment.getRange(0, 3).toList()[spdmentrandom],
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                    textAlign: TextAlign.center)
                : (sumAllspending_last > sumAllspending_this)
                    //지난주가 지출이 많은 경우
                    ? Text(spdment.getRange(0, 3).toList()[spdmentrandom],
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        textAlign: TextAlign.center)
                    //이번주가 지출이 많은 경우
                    : Text(spdment.getRange(3, 6).toList()[spdmentrandom],
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        textAlign: TextAlign.center),
          ),
          SizedBox(height: 10),
        ],
      ));

  spendingContainer();
}

class inspectionContainer implements containerItem {
  final Container mycon = new Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(15),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(activateName[6],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23.0,
                        color: Colors.black)),
              ),
              IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    //팝업창
                    showCupertinoDialog(
                        context: navigatorKey.currentContext,
                        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return new Container(
                              height: 800.0,
                              child: CupertinoAlertDialog(
                                //Dialog Main Title
                                title: Column(
                                  children: <Widget>[
                                    new Text("점검 필요 항목"),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    new Container(
                                        height: 1.0,
                                        width: 400.0,
                                        color: Colors.grey),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                                content: new Text(
                                    "✔교체주기(km)/교체날짜(일) * 10 의 수식을 적용하여 앞으로 일주일내에 점검해야 할 차량 소모품 정보를 띄워줍니다.\n✔클릭시 해당 정보를 자세히 볼 수 있습니다."),
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
            ],
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              itemCount: replace_item.length,
              itemBuilder: (context, index) {
                String itemname = replace_item[index];

                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.priority_high_outlined,
                          color: Colors.red,
                          size: 21.0,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          itemname,
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 1.0,
                        width: double.infinity,
                        color: Colors.grey.withOpacity(0.5)),
                  ],
                );
              }),
        ],
      ));

  inspectionContainer();
}
