import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'containerItem.dart';
import 'save_getapi.dart';
import 'package:intl/intl.dart';

//infocar api 서버와 연결
void getsafyscore() async {
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/scoreAvg?userKey=1147&startDate=2021-07-04&endDate=2021-07-11';
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
    jr = jr.cast<Map<String, dynamic>>();
    jr = jr.map<Getsaftyscore>((json) => Getsaftyscore.fromJson(json)).toList();
    saftyscorelist = jr;
    economicscorelist = jr;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

//주간 평균 연비 확인 기능 - 연료소비 api
void getdaliyfuel() async {
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


  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/recdrvFuelUsement?userKey=1147&startDate=$lastweekday&endDate=$today';
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
    jr = jr.cast<Map<String, dynamic>>();
    jr = jr.map<Getdaliyfuel>((json) => Getdaliyfuel.fromJson(json)).toList();
    daliyfuellist = jr;

    List<Getdaliyfuel> newjr = []; //json 받아왔을 때 비어있는 데이터 처리를 위한 리스트

    int index = 0;

    DateTime lastday; //다 돌아간 날짜를 체크하기 위함
    jr.forEach((x) {
      int day = int.parse(x.Date.split("-")[2]);
      while (date != day) {
        DateTime mydate = new DateTime(now.year, now.month, now.day - index);
        lastday = mydate;
        String mydateday = formatter.format(mydate);
        //비어있는 데이터 넣기
        newjr.insert(
            index, new Getdaliyfuel(DrvFuelUsement: 0,  Date: mydateday));
        date = date - 1;
        index = index + 1;
      }
      //기존 데이터 넣기
      newjr.insert(index, x);

      date = date - 1;
      index = index + 1;
    });

    //마지막 날짜와 원하는 날짜까지의 차이
    int countday = lastday.difference(lastweek).inDays - 1;

    int len = newjr.length;
    //만약에 들어있는 데이터가 마지막 날짜가 아니라면, 나머지 데이터 모두 0으로 채우기
    for (int i = len; i < len + countday; i++) {
      DateTime mydate = new DateTime(now.year, now.month, now.day - i);
      String mydateday = formatter.format(mydate);
      newjr.insert(
          i, new Getdaliyfuel(DrvFuelUsement: 0, Date: mydateday));
    }
    //거꾸로 들어온 데이터 뒤집기
    daliyfuellist = new List.from(newjr.reversed);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

void getdecelerationscore() async {
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=2021-07-05&endDate=2021-07-12&eventCode=EventCode03';

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
    jr = jr.cast<Map<String, dynamic>>();
    jr = jr
        .map<GetDrivingwarningscore>(
            (json) => GetDrivingwarningscore.fromJson(json))
        .toList();
    decelerationscorelist = jr;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

//주간 주행거리 확인 기능 api
void getdrivingdistance() async {
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/recdrvDisSum?userKey=1147&startDate=2021-07-04&endDate=2021-07-11';
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
    jr = jr.cast<Map<String, dynamic>>();
    jr = jr
        .map<Getdrivingdistance>((json) => Getdrivingdistance.fromJson(json))
        .toList();
    drivingdistancelist = jr;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

void getaccelerationscore() async {
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=2021-07-05&endDate=2021-07-12&eventCode=EventCode02';
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
    jr = jr.cast<Map<String, dynamic>>();
    jr = jr
        .map<GetDrivingwarningscore>(
            (json) => GetDrivingwarningscore.fromJson(json))
        .toList();
    accelerationscorelist = jr;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

void getrotationscore() async {
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=2021-07-05&endDate=2021-07-12&eventCode=EventCode10';
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
    jr = jr.cast<Map<String, dynamic>>();
    jr = jr
        .map<GetDrivingwarningscore>(
            (json) => GetDrivingwarningscore.fromJson(json))
        .toList();
    rotationscorelist = jr;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

void getidlescore() async {
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=2021-07-05&endDate=2021-07-12&eventCode=EventCode01';
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
    jr = jr.cast<Map<String, dynamic>>();
    jr = jr
        .map<GetDrivingwarningscore>(
            (json) => GetDrivingwarningscore.fromJson(json))
        .toList();
    idlescorelist = jr;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

void getSpending() async {
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/cbookCradit?userKey=1147';
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
    jr = jr.cast<Map<String, dynamic>>();
    jr = jr.map<GetSpending>((json) => GetSpending.fromJson(json)).toList();
    spendinglist = jr;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
