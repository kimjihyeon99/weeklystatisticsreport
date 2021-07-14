import 'statisticview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'save_getapi.dart';

import 'dart:math'; //random 수 가져오기 위한것

//가져온 api 정보 임시 저장소
List<Getsaftyscore> saftyscorelist = []; //안전운전 점수리스트
List economicscorelist = []; // 경제운전 점수 리스트
List daliyfuellist = []; //연비 리스트
List drivingdistancelist = []; //주행 거리 리스트
List decelerationscorelist = []; // 급감속 리스트
List accelerationscorelist = []; // 급가속 리스트
List rotationscorelist = []; // 급회전 리스트
List idlescorelist = []; // 공회전 리스트
List spendinglist = []; //지출 내역 리스트

//지난주와  비교하는 코멘트
List ment = [
  "지난주보다 안전하게 운전한 덕분에 안전점수가 더 높아졌어요o(*￣▽￣*)o \n 앞으로도 안전운전 부탁해요✨",
  "지난주보다 안전점수가 높아졌어요😀 \n 점차 안전점수를 높여보세요!",
  "지난주보다 더 안전하게 운전하셨어요! \n 100점을 목표로 고고고🔥",
  "이럴수가...저번주보다 점수가 낮아지다니... \n 😥담주에는 조금 더 조심해서 운전해요ಥ_ಥ",
  "지난주보다 안전점수가 떨어졌어요😥 \n 다음에는 좀 더 안전하게 운전해봐요",
  "안전점수가 지난번보다 떨어졌어요.. \n 조금 더 분발하세요💪 ",
];

//이번주만 데이터 있을 경우 코멘트
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
int lastweekcnt = 0;
double thisavg = 0;
double lastavg = 0;

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
                      ? Text(ment2.getRange(0, 3).toList()[Random().nextInt(3)],
                          style: TextStyle(fontSize: 18.0, color: Colors.black))
                      : (thisavg > 80)
                          ? Text(
                              ment2
                                  .getRange(3, 6)
                                  .toList()[Random().nextInt(3)],
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black))
                          : Text(
                              ment2
                                  .getRange(6, 9)
                                  .toList()[Random().nextInt(3)],
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black))
                  : (thisavg > lastavg)
                      ? Text(ment.getRange(0, 3).toList()[Random().nextInt(3)],
                          style: TextStyle(fontSize: 18.0, color: Colors.black))
                      : Text(ment.getRange(3, 6).toList()[Random().nextInt(3)],
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.black))),
        ],
      ));

  saftyscoreContainer();
}

class economicscoreContainer implements containerItem {
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

  economicscoreContainer();
}

class drivingwarningscoreContainer implements containerItem {
  final Container mycon = new Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(15),
      height: 300,
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
          Text(activateName[2],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23.0,
                  color: Colors.black)),
          Text('급감속',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
          Text(decelerationscorelist[0].Date),
          Text(decelerationscorelist[0].countEvent.toString() + '번'),
          Text('급가속',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
          Text(accelerationscorelist[0].Date),
          Text(accelerationscorelist[0].countEvent.toString() + '번'),
          Text('급회전',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
          Text(rotationscorelist[0].Date),
          Text(rotationscorelist[0].countEvent.toString() + '번'),
          //공회전 데이터는 아직 없어서 추가하지 않았습니다.
        ],
      ));

  drivingwarningscoreContainer();
}

class daliyfuelContainer implements containerItem {
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
          Text(activateName[3],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23.0,
                  color: Colors.black)),
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
          Text('차계부 구매 코드: ' + spendinglist[0].CBOOK_CODE),
          Text('총 지출 금액: ' + spendinglist[0].PRICE.toString() + '원'),
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
