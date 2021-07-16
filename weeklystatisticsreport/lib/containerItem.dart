import 'dart:ffi';

import 'package:weeklystatisticsreport/infocarapi_mgr.dart';

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
List daliyfuellist = []; //연비 리스트
double drivingdistancelist=0; //이번주 주행 거리 리스트
double drivingdistancelist_last=0;//지난주 주행거리 리스트
List decelerationscorelist = []; // 급감속 리스트
List accelerationscorelist = []; // 급가속 리스트
List rotationscorelist = []; // 급회전 리스트
List idlescorelist = []; // 공회전 리스트
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
  "저번주보다 경제점수가 낮아지다니💦.\n 더 노력해서 점수를 올려주세요🤦",
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

//주행거리 멘트
//지난주 > 이번주
List drvment = [
  "이번주에는 저번주보다 덜 운전하셨네요👏 \n환경에 큰 도움이 될 거에요🤩",
  "지난주보다 더 적게 달리셨어요~ \n시간 날때 드라이브 한번 다녀오세요🚗",
  "주행거리가 지난주보다 감소했네요!\n덕분에 미세먼지 감축에 도움이 되었어요!",
  "저번주보다 이번주에 운전을 더 많이하셨어요! \n안전운전에 주의하세요😉",
  "저번주보다 더 많이 달리셨어요~ \n세차한번 하고 오세요🌊  ",
  "주행거리가 저번주보다 증가했네요!\n여행이라도 다녀오신건가요?⛱",
];

int lastweekcnt = 0;
//safe
double thisavg = 0;
double lastavg = 0;
// eco
double ecothisavg = 0;
double ecolastavg = 0;

final int mentrandom = Random().nextInt(3);
final int ecomentrandom = Random().nextInt(3);
final int drvmentrandom = Random().nextInt(3);
//각자의 container 생성을 위한것
abstract class containerItem {}


class saftyscoreContainer implements containerItem {
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
    child:
    Column(
      children: [
        Text(activateName[0],
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.black)),

      ],
    )

  );

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
      child:  Column(
        children: [
          Text(activateName[2],
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.black)),
          Text('급감속', style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18.0)),
          Text(decelerationscorelist[0].Date),
          Text(decelerationscorelist[0].countEvent.toString() + '번'),
          Text('급가속', style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18.0)),
          Text(accelerationscorelist[0].Date),
          Text(accelerationscorelist[0].countEvent.toString() + '번'),
          Text('급회전', style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18.0)),
          Text(rotationscorelist[0].Date),
          Text(rotationscorelist[0].countEvent.toString() + '번'),
          //공회전 데이터는 아직 없어서 추가하지 않았습니다.
        ],
      )
  );

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
                fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.black)),

        Text(daliyfuellist[0].Date),
      ],)
  );

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
          Row(
            children: [
              Column (
                children: <Widget>[
                  Image(
                    //위치는 나중에 설정
                    height: 70,
                    width: 70,
                    image: AssetImage('assets/car_img.png'),
                  ),
                  SizedBox(width: 200,
                    child:ClipRRect(
                      // The border radius (`borderRadius`) property, the border radius of the rounded corners.
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: LinearProgressIndicator(
                        minHeight: 20,
                        value: drivingdistancelist_last==null ? 0 : drivingdistancelist_last*0.005,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFF4964)),
                      ),
                    ),
                  ),
                ],
              ),
              Column (
                children: [
                  Text("지난주",
                    style: TextStyle(
                      fontSize: 20,
                    ),textAlign: TextAlign.center
                  ),
                  SizedBox(width: 100,
                  child: Text (
                    "${drivingdistancelist_last==null ? 0 : drivingdistancelist_last.toInt()} km",
                    style: TextStyle(
                      fontSize: 20,
                    ),textAlign: TextAlign.center,
                  ),
                  )
                ],
              ),
              
            ],
          ),
          Row(
            children: [
              Column (
                children: <Widget>[
                  Image(
                    //위치는 나중에 설정
                    height: 70,
                    width: 70,
                    image: AssetImage('assets/car_img.png'),
                  ),
                  SizedBox(width: 200,
                    child:
                    ClipRRect(
                      // The border radius (`borderRadius`) property, the border radius of the rounded corners.
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: LinearProgressIndicator(
                        minHeight: 20,
                        value:  drivingdistancelist==null ? 0 : drivingdistancelist*0.005,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                      ),
                    ),

                  ),
                ],
              ),

              Column (
                children: [
                  Text("이번주",
                      style: TextStyle(
                        fontSize: 20,
                      ),textAlign: TextAlign.center
                  ),
                  SizedBox(width: 100,
                    child: Text (
                      "${drivingdistancelist==null ? 0 : drivingdistancelist.toInt()} km",
                      style: TextStyle(
                        fontSize: 20,
                      ),textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
            ]
          )
      //주행거리 멘트 넣을 곳
          ,Align(
              alignment: Alignment.center,
              //지난주 주행거리가 이번주 주행거리보다 클 경우
              child: ((drivingdistancelist_last==null ? 0: drivingdistancelist_last) >
                            (drivingdistancelist==null ? 0: drivingdistancelist)  ) ?
              Text(
                  drvment.getRange(0, 3).toList()[drvmentrandom],
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                  textAlign: TextAlign.center)
                  :
              Text(drvment.getRange(3, 6).toList()[drvmentrandom],
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
                  fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.black)),
          // Text('차계부 구매 코드: ' + spendinglist[0].CBOOK_CODE),
          // Text('총 지출 금액: ' + spendinglist[0].PRICE.toString() + '원'),
        ],
      )
  );

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
