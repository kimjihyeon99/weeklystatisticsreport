import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'containerItem.dart';
import 'save_getapi.dart';
import 'package:intl/intl.dart';

//infocar api 서버와 연결
Future<void> getsafyscore() async {
  final DateTime originnow = DateTime.now();

  final DateTime now = new DateTime(originnow.year,originnow.month,originnow.day-3);
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateTime lastweek = new DateTime(originnow.year, originnow.month, originnow.day - 16);

  final String today = formatter.format(now);

  final String lastweekday = formatter.format(lastweek);

  int date = now.day as int;


  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/scoreAvg?userKey=1147&startDate=$lastweekday&endDate=$today';
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

    List<Getsaftyscore> newjr = new List<Getsaftyscore>();
    int index = 0;
    DateTime lastday;
    jr.forEach((x) {
      int day = int.parse(x.Date.split("-")[2]);
      while (date != day) {
        DateTime mydate = new DateTime(now.year, now.month, now.day - index);
        lastday = mydate;
        String mydateday = formatter.format(mydate);
        newjr.insert(
            index, new Getsaftyscore(eco_avg: 0, safe_avg: 0, Date: mydateday ));
        date = date - 1;
        index = index + 1;
      }
      //기존 데이터 넣는 위치
      newjr.insert(index, x);

      date = date - 1;
      index = index + 1;
    });

    int countday =  lastday.difference(lastweek).inDays-1;
    int len = newjr.length;

    for(int i=len;i<len+countday;i++){
      DateTime mydate = new DateTime(now.year, now.month, now.day - i);
      String mydateday = formatter.format(mydate);
      newjr.insert(
          i, new Getsaftyscore(eco_avg: 0, safe_avg: 0, Date: mydateday));
    }

    saftyscorelist = new List.from(newjr.reversed);
    economicscorelist = new List.from(newjr.reversed);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

//주간 평균 연비 확인 기능 - 연료소비 api
void getdaliyfuel() async {
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/recdrvFuelUsement?userKey=1147&startDate=2021-07-04&endDate=2021-07-11';
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
