import 'statisticview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:intl/intl.dart';
import 'save_getapi.dart';

//가져온 api 정보 임시 저장소
List<Getsaftyscore> saftyscorelist = [];
List daliyfuellist = [];
List drivingdistancelist = [];
List economicscorelist = [];
List decelerationscorelist = []; // 급감속 리스트
List accelerationscorelist = []; // 급가속 리스트
List rotationscorelist = []; // 급회전 리스트
List idlescorelist = []; // 공회전 리스트
List spendinglist = [];


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
            legend: Legend(isVisible:true,  position: LegendPosition.top),
            series: <ChartSeries>[
              ColumnSeries<Getsaftyscore, String>(
                  name: "지난주",
                  dataSource: saftyscorelist.getRange(0, 7).toList(),
                  xValueMapper: (Getsaftyscore gf, _) => DateFormat('EEE').format(new DateTime(int.parse(gf.Date.split("-")[0]),int.parse(gf.Date.split("-")[1]),int.parse(gf.Date.split("-")[2]))),
                  yValueMapper: (Getsaftyscore gf, _) => gf.safe_avg),
              ColumnSeries<Getsaftyscore, String>(
                  name: "이번주",
                  dataSource: saftyscorelist.getRange(7, 14).toList(),
                  xValueMapper: (Getsaftyscore gf, _) =>  DateFormat('EEE').format(new DateTime(int.parse(gf.Date.split("-")[0]),int.parse(gf.Date.split("-")[1]),int.parse(gf.Date.split("-")[2]))),
                  yValueMapper: (Getsaftyscore gf, _) => gf.safe_avg)
            ],
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              maximum: 100,
            ),
          ),
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
