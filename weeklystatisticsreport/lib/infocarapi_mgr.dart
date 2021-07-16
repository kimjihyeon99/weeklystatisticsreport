import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'containerItem.dart';
import 'save_getapi.dart';
import 'package:intl/intl.dart';

//infocar api 서버와 연결

Future<String> getallapi() async {
  await getsafyscore();
  await getdaliyfuel();

  await getdrivingdistance_last();//지난주
  await getdrivingdistance();//이번주
  await getdecelerationscore();
  await getaccelerationscore();
  await getrotationscore();
  await getidlescore();
  await getSpending();

  return 'Data Loaded';
}

//// 안전운전, 경제운전 점수 기능 api
void getsafyscore() async {
  final DateTime originnow = DateTime.now();
  Map yoil = {
    "Mon": 1,
    "Tue": 2,
    "Wed": 3,
    "Thu": 4,
    "Fri": 5,
    "Sat": 6,
    "Sun": 7
  };

  String todayyoil = DateFormat('EEE').format(originnow);

  int numyoil = yoil[todayyoil];

  //현재 날짜와 지난주 날짜 가져오기
  final DateTime now =
      new DateTime(originnow.year, originnow.month, originnow.day - numyoil);
  final DateTime lastweek = new DateTime(
      originnow.year, originnow.month, originnow.day - 13 - numyoil);

  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // string으로 바꾸기 위함

  //날짜를 문자열로 변환하기, class에 넣어주기 위함
  final String today = formatter.format(now);
  final String lastweekday = formatter.format(lastweek);

  int date = now.day as int; //현재 날짜에서 '일'만 가져와서 아래에서 카운트 하기 위함

  //api 연결
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/scoreAvg?userKey=1147&startDate=$lastweekday&endDate=$today';
  var response = await http.get(
    Uri.parse(url),
    headers: {"F_TOKEN": "D5CFB732E7BA8E56356AA766B61EEF32F5F1BCA6F554FB0A9432D285A7E012A3"},
  );
  if (response.statusCode == 200) {
    var jsonResponse =
    convert.jsonDecode(response.body);
    var jr= jsonResponse['response']['body']['items'];
    jr= jr.cast<Map<String, dynamic>>();
    jr = jr.map<Getsaftyscore>((json) => Getsaftyscore.fromJson(json)).toList();
    saftyscorelist= jr;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

//주간 평균 연비 확인 기능 - 연료소비 api
void getdaliyfuel() async{
  String url = 'https://server2.mureung.com/infocarAdminPageAPI/sideproject/recdrvFuelUsement?userKey=1147&startDate=2021-07-04&endDate=2021-07-11';
   final response = await http.get(
    Uri.parse(url),
    headers: {"F_TOKEN": "D5CFB732E7BA8E56356AA766B61EEF32F5F1BCA6F554FB0A9432D285A7E012A3"},
  );
  if (response.statusCode == 200) {
    var jsonResponse =
    convert.jsonDecode(response.body);
    var jr= jsonResponse['response']['body']['items'];
    jr= jr.cast<Map<String, dynamic>>();
    
    jr = jr.map<Getdaliyfuel>((json) => Getdaliyfuel.fromJson(json)).toList();
    daliyfuellist= jr;
      } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

//지난주 주행거리 합 api
void getdrivingdistance_last() async {
  print("지난주");
  final DateTime originnow = DateTime.now();
  Map yoil = {
    "Mon": 1,
    "Tue": 2,
    "Wed": 3,
    "Thu": 4,
    "Fri": 5,
    "Sat": 6,
    "Sun": 7
  };

  String todayyoil = DateFormat('EEE').format(originnow);
  int numyoil = yoil[todayyoil];

  //현재 날짜와 지난주 날짜 가져오기
  final DateTime now =
  new DateTime(originnow.year, originnow.month, originnow.day -7 -numyoil);
  final DateTime lastweek = new DateTime(
      originnow.year, originnow.month, originnow.day -13 -numyoil);

  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // string으로 바꾸기 위함

  //날짜를 문자열로 변환하기, class에 넣어주기 위함
  final String today = formatter.format(now);
  final String lastweekday = formatter.format(lastweek);

  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/recdrvDisSum?userKey=1147&startDate=$lastweekday&endDate=$today';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      "F_TOKEN":
      "D5CFB732E7BA8E56356AA766B61EEF32F5F1BCA6F554FB0A9432D285A7E012A3"
    },
  );

  print("dklfjdklfjdklf");
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var jr = jsonResponse['response']['body']['items'];
    // 전처리
    List tempjr = [];
    tempjr.add(jr);
    jr = tempjr;

    jr = jr.cast<Map<String, dynamic>>();
    jr = jr
        .map<Getdrivingdistance>((json) => Getdrivingdistance.fromJson(json))
        .toList();

    drivingdistancelist_last = jr[0].RecDrvDisSum ;
    print(jr[0].RecDrvDisSum);
  } else {//불러오기 실패!
    print('Request failed with status: ${response.statusCode}.');
  }
}


//이번주 주행거리 합
void getdrivingdistance() async {
  print("이번주");
  final DateTime originnow = DateTime.now();
  Map yoil = {
    "Mon": 1,
    "Tue": 2,
    "Wed": 3,
    "Thu": 4,
    "Fri": 5,
    "Sat": 6,
    "Sun": 7
  };

  String todayyoil = DateFormat('EEE').format(originnow);
  int numyoil = yoil[todayyoil];

  //현재 날짜와 지난주 날짜 가져오기
  final DateTime now =
  new DateTime(originnow.year, originnow.month, originnow.day - numyoil);
  final DateTime lastweek = new DateTime(
      originnow.year, originnow.month, originnow.day - 6 - numyoil);

  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // string으로 바꾸기 위함

  //날짜를 문자열로 변환하기, class에 넣어주기 위함
  final String today = formatter.format(now);
  final String lastweekday = formatter.format(lastweek);
  print(today);
  print(lastweekday);
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/recdrvDisSum?userKey=1147&startDate=$lastweekday&endDate=$today';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      "F_TOKEN":
      "D5CFB732E7BA8E56356AA766B61EEF32F5F1BCA6F554FB0A9432D285A7E012A3"
    },
  );
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var jr = jsonResponse['response']['body']['items'];
    // 전처리
    List tempjr = [];
    tempjr.add(jr);
    jr = tempjr;

    jr = jr.cast<Map<String, dynamic>>();
    jr = jr
        .map<Getdrivingdistance>((json) => Getdrivingdistance.fromJson(json))
        .toList();

    drivingdistancelist = jr[0].RecDrvDisSum;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }

}



////위험 운전행동 발생 횟수 기능 api

//급감속 api

void getdecelerationscore() async{
  String url = 'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=2021-07-05&endDate=2021-07-12&eventCode=EventCode03';
  final response = await http.get(
  Uri.parse(url),
  headers: {"F_TOKEN": "D5CFB732E7BA8E56356AA766B61EEF32F5F1BCA6F554FB0A9432D285A7E012A3"},
  );
  if (response.statusCode == 200) {
  var jsonResponse =
  convert.jsonDecode(response.body);
  var jr = jsonResponse['response']['body']['items'];
  jr = jr.cast<Map<String, dynamic>>();
  jr = jr.map<GetDrivingwarningscore>((json) =>
  GetDrivingwarningscore.fromJson(json)).toList();
  decelerationscorelist = jr;
  }
  else {
  print('Request failed with status: ${response.statusCode}.');
  }

  }

void getaccelerationscore() async{
  String url = 'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=2021-07-05&endDate=2021-07-12&eventCode=EventCode02';
  final response = await http.get(
    Uri.parse(url),
    headers: {"F_TOKEN": "D5CFB732E7BA8E56356AA766B61EEF32F5F1BCA6F554FB0A9432D285A7E012A3"},
  );
  if (response.statusCode == 200) {
    var jsonResponse =
    convert.jsonDecode(response.body);
    var jr= jsonResponse['response']['body']['items'];
    jr= jr.cast<Map<String, dynamic>>();
    jr = jr.map<GetDrivingwarningscore>((json) => GetDrivingwarningscore.fromJson(json)).toList();
    accelerationscorelist= jr;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

void getrotationscore() async{
  String url = 'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=2021-07-05&endDate=2021-07-12&eventCode=EventCode10';
  final response = await http.get(
    Uri.parse(url),
    headers: {"F_TOKEN": "D5CFB732E7BA8E56356AA766B61EEF32F5F1BCA6F554FB0A9432D285A7E012A3"},
  );
  if (response.statusCode == 200) {
    var jsonResponse =
    convert.jsonDecode(response.body);
    var jr= jsonResponse['response']['body']['items'];
    jr= jr.cast<Map<String, dynamic>>();
    jr = jr.map<GetDrivingwarningscore>((json) => GetDrivingwarningscore.fromJson(json)).toList();
    rotationscorelist= jr;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

void getidlescore() async{
  String url = 'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=2021-07-05&endDate=2021-07-12&eventCode=EventCode01';
  final response = await http.get(
    Uri.parse(url),
    headers: {"F_TOKEN": "D5CFB732E7BA8E56356AA766B61EEF32F5F1BCA6F554FB0A9432D285A7E012A3"},
  );
  if (response.statusCode == 200) {
    var jsonResponse =
    convert.jsonDecode(response.body);
    var jr= jsonResponse['response']['body']['items'];
    jr= jr.cast<Map<String, dynamic>>();
    jr = jr.map<GetDrivingwarningscore>((json) => GetDrivingwarningscore.fromJson(json)).toList();
    idlescorelist= jr;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

void getSpending() async{
  String url = 'https://server2.mureung.com/infocarAdminPageAPI/sideproject/cbookCradit?userKey=1147';
  final response = await http.get(
    Uri.parse(url),
    headers: {"F_TOKEN": "D5CFB732E7BA8E56356AA766B61EEF32F5F1BCA6F554FB0A9432D285A7E012A3"},
  );
  if (response.statusCode == 200) {
    var jsonResponse =
    convert.jsonDecode(response.body);
    var jr= jsonResponse['response']['body']['items'];
    jr= jr.cast<Map<String, dynamic>>();
    jr = jr.map<GetSpending>((json) => GetSpending.fromJson(json)).toList();
    spendinglist= jr;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
