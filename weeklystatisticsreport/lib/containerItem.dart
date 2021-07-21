import 'statisticview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'save_getapi.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import 'dart:math'; //random 수 가져오기 위한것

//가져온 api 정보 임시 저장소
List<Getsaftyscore> saftyscorelist = []; //안전운전 점수리스트
List<Getsaftyscore> economicscorelist = []; // 경제운전 점수 리스트
List<Getdaliyfuel> daliyfuellist = []; //연비 리스트
int drivingdistancelist = 0; //주행 거리 리스트
int drivingdistancelist_last = 0; //이전주 주행 거리 리스트
int drivingdistancelist_last_per = 0;
int maxdistance =0;

List<GetDrivingwarningscore> countAllEventForEachDay = [];
List<CountEventForEvent> countEventForLastWeek = [];
List<CountEventForEvent> countEventForThisWeek = [];
int countAllEventForLastWeek = 0;
int countAllEventForThisWeek = 0;
List<GetSpending> spendinglist_last = []; //지난주 지출 내역
List<GetSpending> spendinglist_this = []; //이번주 지출 내역
int sumAllspending_last = 0;
int sumAllspending_this = 0;

//안전 점수 : 지난주와  비교하는 코멘트
List ment = [
  "\n지난주보다 안전하게 운전한 덕분에 안전점수가 더 높아졌어요o(*￣▽￣*)o \n 앞으로도 안전운전 부탁해요✨",
  "\n지난주보다 안전점수가 높아졌어요😀 \n 점차 안전점수를 높여보세요!",
  "\n지난주보다 더 안전하게 운전하셨어요! \n 100점을 목표로 고고고🔥",
  "\n이럴수가...저번주보다 점수가 낮아지다니... \n 😥담주에는 조금 더 조심해서 운전해요ಥ_ಥ",
  "\n지난주보다 안전점수가 떨어졌어요😥 \n 다음에는 좀 더 안전하게 운전해봐요",
  "\n안전점수가 지난번보다 떨어졌어요.. \n 조금 더 분발하세요💪 ",
];

//안전 점수 : 이번주만 데이터 있을 경우 코멘트
List ment2 = [
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

//주행거리 멘트
//지난주 > 이번주
List drvment = [
  "이번주에는 저번주보다 덜 운전하셨네요👏\n환경에 큰 도움이 될 거에요🤩",
  "지난주보다 더 적게 달리셨어요~\n시간 날때 드라이브 한번 다녀오세요🚗",
  "주행거리가 지난주보다 감소했네요!\n덕분에 미세먼지 감축에 도움이 되었어요!",
  "저번주보다 이번주에 운전을 더 많이하셨어요!\n안전운전에 주의하세요😉",
  "저번주보다 더 많이 달리셨어요~\n세차한번 하고 오세요🌊  ",
  "주행거리가 저번주보다 증가했네요!\n여행이라도 다녀오신건가요?⛱",
];

//지출 내역 멘트
//지난주,이번주 비교
List spdment = [
  "저번주보다 지출이 줄었어요👍👍\n이번주도 줄일 수 있도록 노력해봐요😁",
  "지난주 보다 지출 내역이 감소했어요 \n 좋은 운전 습관을 가지고 계시네요👍",
  "지출이 지난주보다 적어지셨네요!\n절약하는 습관 아주좋아요👍",
  "지난주 보다 더 지출 내역이 많네요! \n 경제운전으로 절약해보시면 어떨까요?😂",
  "저번주보다 지출이 많았어요!\n혹시 불필요한 지출은없었는지 생각해보세요😃",
  "지출이 지난주보다 많아지셨네요!\n다음세차는 손세차 어떠세요?🧼"
];

int lastweekcnt = 0;
//safe
double thisavg = 0.00;
double lastavg = 0.00;
// eco
double ecothisavg = 0;
double ecolastavg = 0;
//fuel
double fuelthisavg = 0;
double fuellastavg = 0;

bool isZeroEventCountForLastWeek = true;
bool isZeroEventCountForThisWeek = true;

final int mentrandom = Random().nextInt(3);
final int ecomentrandom = Random().nextInt(3);
final int drvmentrandom = Random().nextInt(3);
final int spdmentrandom = Random().nextInt(3);

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
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    topLeft: Radius.circular(5)
                  ),
                  color: Color(0xFFdedcee),
                  dataSource: saftyscorelist.getRange(0, 7).toList(),
                  xValueMapper: (Getsaftyscore gf, _) => DateFormat('EEE')
                      .format(new DateTime(
                          int.parse(gf.Date.split("-")[0]),
                          int.parse(gf.Date.split("-")[1]),
                          int.parse(gf.Date.split("-")[2]))),
                  yValueMapper: (Getsaftyscore gf, _) => gf.safe_avg),
              ColumnSeries<Getsaftyscore, String>(
                  name: "이번주",
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5)
                  ),
                  color: Color(0xFF6a60a9),
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
          SizedBox(height: 15,),
          new Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.3)),
          SizedBox(height: 15,),
          Align(
            alignment: Alignment.center,
            child:
            Row(
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
                    SizedBox(height: 5,),
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
                      "${lastavg.toStringAsFixed(2)} ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9055A2),
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      "${thisavg.toStringAsFixed(2)} ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9055A2),
                        fontSize: 18,
                      ),
                    ),
                  ],
                )
              ],
            )
          ),
          SizedBox(height: 15,),
          new Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.3)),
          SizedBox(height: 5,),
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
          SizedBox(height: 10,),
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
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5)
                  ),
                  color: Color(0xFFCADBE9),
                  dataSource: economicscorelist.getRange(0, 7).toList(),
                  xValueMapper: (Getsaftyscore gf, _) => DateFormat('EEE')
                      .format(new DateTime(
                          int.parse(gf.Date.split("-")[0]),
                          int.parse(gf.Date.split("-")[1]),
                          int.parse(gf.Date.split("-")[2]))),
                  yValueMapper: (Getsaftyscore gf, _) => gf.eco_avg),
              ColumnSeries<Getsaftyscore, String>(
                  name: "이번주",
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5)
                  ),
                  color: Color(0xFF6AAFE6),
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
          SizedBox(height: 15,),
          new Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.3)),
          SizedBox(height: 15,),
          Align(
              alignment: Alignment.center,
              child:
              Row(
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
                      SizedBox(height: 5,),
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
                      SizedBox(height: 5,),
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
              )
          ),
          SizedBox(height: 15,),
          new Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.3)),
          SizedBox(height: 5,),
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
          SizedBox(height: 10,),
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
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5)
                  ),
                  color:Color(0xFFF7AA97),
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
                      topLeft: Radius.circular(5)
                  ),
                  color:Color(0xFFDE7E73),
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
                            Center(
                              child: Container(
                                width: 130,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: -8,
                                          blurRadius: 5,
                                          offset: Offset(-5,-5),
                                          color: Colors.grey
                                      ),
                                      BoxShadow(
                                          spreadRadius: -2,
                                          blurRadius: 10,
                                          offset: Offset(7,7),
                                          color: Colors.black.withOpacity(0.5)
                                      )
                                    ]
                                ),
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
              isZeroEventCountForThisWeek
                  ? Container(
                      child: Text('이번주에 이벤트가\n아예 일어나지 않았네요.'),
                    )
                  : Column(
                      children: [
                        Container(
                          width: 170,
                          height: 170,
                          child: Stack(children: <Widget>[
                            Center(
                              child: Container(
                                width: 130,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: -8,
                                          blurRadius: 5,
                                          offset: Offset(-5,-5),
                                          color: Colors.grey
                                      ),
                                      BoxShadow(
                                          spreadRadius: -2,
                                          blurRadius: 10,
                                          offset: Offset(7,7),
                                          color: Colors.black.withOpacity(0.5)
                                      )
                                    ]
                                ),
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
            // primaryYAxis: NumericAxis(
            // ),
          ),
          SizedBox(height: 15,),
          new Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.3)),
          SizedBox(height: 15,),
          Align(
              alignment: Alignment.center,
              child:
              Row(
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
                      SizedBox(height: 5,),
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
                        "${fuellastavg.toStringAsFixed(2)} ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff79a8a9),
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5,),
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
              )
          ),
          SizedBox(height: 15,),
          new Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.3)),
          SizedBox(height: 5,),
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
          Align(
            alignment: Alignment.topLeft,
            child: Text(activateName[4],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 27.0,
                    color: Colors.black)),
          ),
          Column(
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
                height: 5,
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
              )
            ],
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
                            //위치는 나중에 설정
                            height: 40,
                            width: 40,
                            image: AssetImage('assets/car_img.png'),
                          ),
                        ],
                      )),
                  ClipRRect(
                      // The border radius (`borderRadius`) property, the border radius of the rounded corners.
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: FAProgressBar (
                        size: 20,
                        currentValue:
                        drivingdistancelist_last == null
                            ? 0
                            : drivingdistancelist_last,
                        backgroundColor: Colors.white,
                        progressColor: Color(0xFFcff09e),
                        animatedDuration: Duration(milliseconds: 1000),
                        maxValue: maxdistance,
                        // AlwaysStoppedAnimation<Color>(Color(0xFFcff09e)),
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
                          drivingdistancelist == null
                              ? 0
                              : drivingdistancelist / maxdistance),
                      child: Column(
                        children: [
                          Text(
                            "${drivingdistancelist == null ? 0 : drivingdistancelist} km",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Image(
                            //위치는 나중에 설정
                            height: 40,
                            width: 40,
                            image: AssetImage('assets/car_img.png'),
                          ),
                        ],
                      )),
                  ClipRRect(
                      // The border radius (`borderRadius`) property, the border radius of the rounded corners.
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child:  FAProgressBar (
                        size: 20,
                        currentValue:
                        drivingdistancelist_last == null
                            ? 0
                            : drivingdistancelist,
                        backgroundColor: Colors.white,
                        progressColor: Color(0xFF79bd9a),
                        animatedDuration: Duration(milliseconds: 1000),
                        maxValue: maxdistance,
                        // AlwaysStoppedAnimation<Color>(Color(0xFFcff09e)),
                      )),
                ],
              )),
          SizedBox(
            height: 20,
          ),
          Align(
              alignment: Alignment.center,
              //지난주 주행거리가 이번주 주행거리보다 클 경우
              child: ((drivingdistancelist_last == null
                          ? 0
                          : drivingdistancelist_last) >
                      (drivingdistancelist == null ? 0 : drivingdistancelist))
                  ? Text(drvment.getRange(0, 3).toList()[drvmentrandom],
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                      textAlign: TextAlign.center)
                  : Text(drvment.getRange(3, 6).toList()[drvmentrandom],
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                      textAlign: TextAlign.center)),
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
          Align(
            alignment: Alignment.topLeft,
            child: Text(activateName[5],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                    color: Colors.black)),
          ),
          SizedBox(height: 15),
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
                Text("주유•세차비"),
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
                Text("통행•주차비")
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
                Text("차량정비"),
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
                Text("보험료"),
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
                Text("기타"),
              ]),
            ],
          ),
          Row(
            children: [
              sumAllspending_last == 0
                  ? Container(
                      child: Text('지난주 지출이 없네요.'),
                    )
                  : Column(
                      children: [
                        Container(
                          width: 170,
                          height: 170,
                          child: Stack(children: <Widget>[
                            Center(
                              child: Container(
                                width: 130,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: -8,
                                          blurRadius: 5,
                                          offset: Offset(-5,-5),
                                          color: Colors.grey
                                      ),
                                      BoxShadow(
                                          spreadRadius: -2,
                                          blurRadius: 10,
                                          offset: Offset(7,7),
                                          color: Colors.black.withOpacity(0.5)
                                      )
                                    ]
                                ),
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
                width: 20,
              ),
              sumAllspending_this == 0
                  ? Container(
                      child: Text('이번주지출이 없네요'),
                    )
                  : Column(
                      children: [
                        Container(
                          width: 170,
                          height: 170,
                          child: Stack(children: <Widget>[
                            Center(
                              child: Container(
                                width: 130,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: -8,
                                          blurRadius: 5,
                                          offset: Offset(-5,-5),
                                          color: Colors.grey
                                      ),
                                      BoxShadow(
                                          spreadRadius: -2,
                                          blurRadius: 10,
                                          offset: Offset(7,7),
                                          color: Colors.black.withOpacity(0.5)
                                      )
                                    ]
                                ),
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

          SizedBox(height: 15),
          //ment
          Align(
            alignment: Alignment.center,
            child: (sumAllspending_last > sumAllspending_this)
                //지난주가 지출이 많은 경우
                ? Text(spdment.getRange(0, 3).toList()[spdmentrandom],
                    style: TextStyle(fontSize: 18.0, color: Colors.black),textAlign: TextAlign.center)
                //이번주가 지출이 많은 경우
                : Text(spdment.getRange(3, 6).toList()[spdmentrandom],
                    style: TextStyle(fontSize: 18.0, color: Colors.black),textAlign: TextAlign.center),
          ),
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
