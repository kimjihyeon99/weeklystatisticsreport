import 'statisticview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'save_getapi.dart';

import 'dart:math'; //random 수 가져오기 위한것

//가져온 api 정보 임시 저장소
List<Getsaftyscore> saftyscorelist = []; //안전운전 점수리스트
List<Getsaftyscore> economicscorelist = []; // 경제운전 점수 리스트
List<Getdaliyfuel> daliyfuellist = []; //연비 리스트

List drivingdistancelist = []; //주행 거리 리스트
List<GetDrivingwarningscore> countAllEventForEachDay = [];
List<CountEventForEvent> countEventForLastWeek = [];
List<CountEventForEvent> countEventForThisWeek = [];
int countAllEventForLastWeek = 0;
int countAllEventForThisWeek = 0;
List spendinglist = []; //지출 내역 리스트

//안전 점수 : 지난주와  비교하는 코멘트
List ment = [
  "지난주보다 안전하게 운전한 덕분에 안전점수가 더 높아졌어요o(*￣▽￣*)o \n 앞으로도 안전운전 부탁해요✨",
  "지난주보다 안전점수가 높아졌어요😀 \n 점차 안전점수를 높여보세요!",
  "지난주보다 더 안전하게 운전하셨어요! \n 100점을 목표로 고고고🔥",
  "이럴수가...저번주보다 점수가 낮아지다니... \n 😥담주에는 조금 더 조심해서 운전해요ಥ_ಥ",
  "지난주보다 안전점수가 떨어졌어요😥 \n 다음에는 좀 더 안전하게 운전해봐요",
  "안전점수가 지난번보다 떨어졌어요.. \n 조금 더 분발하세요💪 ",
];

//안전 점수 : 이번주만 데이터 있을 경우 코멘트
List ment2 = [
  "베스트 드라이버!! 앞으로도 안전운전 약속🤙",
  "안전 점수가 상위 5% 이네요🏆",
  "안전 운행으로 수명 1년 증가!👏",
  "안전 운전을 위해 노력하셨네요🎉 조금 더 노력하면 90점은 충분히 넘겠어요👏",
  "안전운전 고생했어요😊다음 주에는 90점을 목표로 안전운전해요!👍",
  "아쉽게도 90점을 못넘겼네요😥 이번 주에는 조금 더 노력해서 90점을 넘겨봐요✨",
  "지속적인 위험운전은 내 생명을 위협해요.",
  "한발먼저 가기전에 한발멈춰 여유를 가지세요.",
  "바쁠수록 양보운전! 급할수록 안전운전!"
];

//경제 점수 : 지난주와  비교하는 코멘트
List ecoment = [
  "지난주보다 더 절약해서 운전 하셨네요! \n 돈도 천원 벌었어요💰",
  "저번주보다 더 경제적으로 운전하셨네요🤩 \n 아주 멋져요👍👍",
  "지난주보다 경제점수가 높아졌어요😀 \n 점차 경제점수를 높여보세요!",
  "이런, 지난주보다 경제점수가 떨어졌어요.. \n 이번주는 조금 더 노력해봐요😅",
  "저번주보다 경제점수가 낮아지다니💦.\n 더 노력해서 점수를 올려주세요🤦 ♀",
  "지난주보다 경제점수가 떨어졌어요😥 \n 다음에는 좀 더 경제적으로 운전해봐요!",
];

//경제 점수 : 이번주만 데이터 있을 경우 코멘트
List ecoment2 = [
  "베스트 드라이버!! 앞으로도 절약하기 약속🤙",
  "90점 달성 축하드려요~ \n 앞으로도 쭉 이대로만🏃‍♂️",
  "절약 운행으로 5천원 벌었어요! 축하합니다👏",
  "경제적으로 운전하려 노력하셨네요👏 \n 아주 멋져요q(≧▽≦q)",
  "80점을 넘다니! \n 경제 운전 습관이 점차 배어질거에요😁",
  "한주도 고생했어요! \n 평균 90점을 목표로 더 노력해보아요!✨",
  "경제운전으로 환경문제의 주범인 이산화탄소를 줄여보는 것이 어떨까요?😊",
  "한 템포 느린 운전으로 연비를 감소시켜봐요!",
  "경제운전으로 기름값 아끼고 치킨 한마리 더!🍗"
];

int lastweekcnt = 0;
//safe
double thisavg = 0;
double lastavg = 0;
// eco
double ecothisavg = 0;
double ecolastavg = 0;

bool isZeroEventCountForLastWeek = true;
bool isZeroEventCountForThisWeek = true;

final int mentrandom = Random().nextInt(3);
final int ecomentrandom = Random().nextInt(3);

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
          Align(
            alignment: Alignment.topLeft,
            child: Text(activateName[0],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 27.0,
                    color: Colors.black)),
          ),
          SfCartesianChart(
            legend: Legend(isVisible: true, position: LegendPosition.top),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
              ColumnSeries<Getsaftyscore, String>(
                  name: "지난주",
                  dataSource: saftyscorelist.getRange(0, 7).toList(),
                  xValueMapper: (Getsaftyscore gf, _) => DateFormat('EEE')
                      .format(new DateTime(
                          int.parse(gf.Date.split("-")[0]),
                          int.parse(gf.Date.split("-")[1]),
                          int.parse(gf.Date.split("-")[2]))),
                  yValueMapper: (Getsaftyscore gf, _) => gf.safe_avg),
              ColumnSeries<Getsaftyscore, String>(
                  name: "이번주",
                  dataSource: saftyscorelist.getRange(7, 14).toList(),
                  xValueMapper: (Getsaftyscore gf, _) => DateFormat('EEE')
                      .format(new DateTime(
                          int.parse(gf.Date.split("-")[0]),
                          int.parse(gf.Date.split("-")[1]),
                          int.parse(gf.Date.split("-")[2]))),
                  yValueMapper: (Getsaftyscore gf, _) => gf.safe_avg)
            ],
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              maximum: 100,
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: (lastweekcnt > 3)
                  ? (thisavg > 90)
                      ? Text(ment2.getRange(0, 3).toList()[mentrandom],
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                          textAlign: TextAlign.center)
                      : (thisavg > 80)
                          ? Text(ment2.getRange(3, 6).toList()[mentrandom],
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                              textAlign: TextAlign.center)
                          : Text(ment2.getRange(6, 9).toList()[mentrandom],
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                              textAlign: TextAlign.center)
                  : (thisavg > lastavg)
                      ? Text(ment.getRange(0, 3).toList()[mentrandom],
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                          textAlign: TextAlign.center)
                      : Text(ment.getRange(3, 6).toList()[mentrandom],
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                          textAlign: TextAlign.center)),
        ],
      ));

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
          Align(
            alignment: Alignment.topLeft,
            child: Text(activateName[1],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 27.0,
                    color: Colors.black)),
          ),
          SfCartesianChart(
            legend: Legend(isVisible: true, position: LegendPosition.top),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
              ColumnSeries<Getsaftyscore, String>(
                  name: "지난주",
                  dataSource: economicscorelist.getRange(0, 7).toList(),
                  xValueMapper: (Getsaftyscore gf, _) => DateFormat('EEE')
                      .format(new DateTime(
                          int.parse(gf.Date.split("-")[0]),
                          int.parse(gf.Date.split("-")[1]),
                          int.parse(gf.Date.split("-")[2]))),
                  yValueMapper: (Getsaftyscore gf, _) => gf.eco_avg),
              ColumnSeries<Getsaftyscore, String>(
                  name: "이번주",
                  dataSource: economicscorelist.getRange(7, 14).toList(),
                  xValueMapper: (Getsaftyscore gf, _) => DateFormat('EEE')
                      .format(new DateTime(
                          int.parse(gf.Date.split("-")[0]),
                          int.parse(gf.Date.split("-")[1]),
                          int.parse(gf.Date.split("-")[2]))),
                  yValueMapper: (Getsaftyscore gf, _) => gf.eco_avg)
            ],
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              maximum: 100,
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: (lastweekcnt > 3)
                  ? (ecothisavg > 90)
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
          Align(
            alignment: Alignment.topLeft,
            child: Text(activateName[2],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 27.0,
                    color: Colors.black)),
          ),
          SfCartesianChart(
            legend: Legend(isVisible: true, position: LegendPosition.top),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
              ColumnSeries<GetDrivingwarningscore, String>(
                  name: "지난주",
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
          // Align(
          //     alignment: Alignment.center,
          //     child: (lastweekcnt > 3)
          //         ? (thisavg > 90)
          //         ? Text(ment2.getRange(0, 3).toList()[mentrandom],
          //         style: TextStyle(fontSize: 18.0, color: Colors.black),
          //         textAlign: TextAlign.center)
          //         : (thisavg > 80)
          //         ? Text(ment2.getRange(3, 6).toList()[mentrandom],
          //         style: TextStyle(
          //             fontSize: 18.0, color: Colors.black),
          //         textAlign: TextAlign.center)
          //         : Text(ment2.getRange(6, 9).toList()[mentrandom],
          //         style: TextStyle(
          //             fontSize: 18.0, color: Colors.black),
          //         textAlign: TextAlign.center)
          //         : (thisavg > lastavg)
          //         ? Text(ment.getRange(0, 3).toList()[mentrandom],
          //         style: TextStyle(fontSize: 18.0, color: Colors.black),
          //         textAlign: TextAlign.center)
          //         : Text(ment.getRange(3, 6).toList()[mentrandom],
          //         style: TextStyle(fontSize: 18.0, color: Colors.black),
          //         textAlign: TextAlign.center)),
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
          Row(
            children: [
              isZeroEventCountForLastWeek
                  ? Container(
                      child: Text('지난주에 이벤트가\n아예 일어나지 않았네요.'),
                    )
                  : Column(
                      children: [
                        Container(
                          width: 170,
                          height: 170,
                          child: Stack(children: <Widget>[
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
              isZeroEventCountForThisWeek
                  ? Container(
                      child: Text('이번주에 이벤트가\n아예 일어나지 않았네요.'),
                    )
                  : Column(
                      children: [
                        Container(
                          width: 170,
                          height: 170,
                          child: Stack(children: <Widget>[SfCircularChart(
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
                          ]
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
            ],
          )
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
          Align(
            alignment: Alignment.topLeft,
            child: Text(activateName[3],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 27.0,
                    color: Colors.black)),
          ),
          SfCartesianChart(
            legend: Legend(isVisible: true, position: LegendPosition.top),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
              LineSeries<Getdaliyfuel, String>(
                  name: "지난주",
                  dataSource: daliyfuellist.getRange(0, 7).toList(),
                  xValueMapper: (Getdaliyfuel gf, _) => DateFormat('EEE')
                      .format(new DateTime(
                          int.parse(gf.Date.split("-")[0]),
                          int.parse(gf.Date.split("-")[1]),
                          int.parse(gf.Date.split("-")[2]))),
                  yValueMapper: (Getdaliyfuel gf, _) => gf.DrvFuelUsement),
              LineSeries<Getdaliyfuel, String>(
                  name: "이번주",
                  dataSource: daliyfuellist.getRange(7, 14).toList(),
                  xValueMapper: (Getdaliyfuel gf, _) => DateFormat('EEE')
                      .format(new DateTime(
                          int.parse(gf.Date.split("-")[0]),
                          int.parse(gf.Date.split("-")[1]),
                          int.parse(gf.Date.split("-")[2]))),
                  yValueMapper: (Getdaliyfuel gf, _) => gf.DrvFuelUsement)
            ],
            primaryXAxis: CategoryAxis(),
            // primaryYAxis: NumericAxis(
            // ),
          ),
        ],
      ));

  daliyfuelContainer();
}

class drivingdistanceContainer implements containerItem {
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
      child: Column(
        children: [
          Text(activateName[4],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23.0,
                  color: Colors.black)),
          //double만 가짐.
        ],
      ));

  drivingdistanceContainer();
}

class spendingContainer implements containerItem {
  final Container mycon = new Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(15),
      height: 130,
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
          Text(activateName[5],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23.0,
                  color: Colors.black)),
          //Text('차계부 구매 코드: ' + spendinglist[0].CBOOK_CODE),
          //Text('총 지출 금액: ' + spendinglist[0].PRICE.toString() + '원'),
        ],
      ));

  spendingContainer();
}

class inspectionContainer implements containerItem {
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

  inspectionContainer();
}
