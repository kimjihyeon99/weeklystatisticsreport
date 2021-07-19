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
  await getdrivingdistance();//이번주
  await getdrivingdistance_last();//지난주
  await getdecelerationscore();
  await getaccelerationscore();
  await getrotationscore();
  await getidlescore();
  await getSpending();

  return 'Data Loaded';
}

//// 안전운전, 경제운전 점수 기능 api
void getsafyscore() async {
  print("안전운전 경제운전 점수");
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
    headers: {
      "F_TOKEN":
          "D5CFB732E7BA8E56356AA766B61EEF32F5F1BCA6F554FB0A9432D285A7E012A3"
    },
  );
  if (response.statusCode == 200) {
    //json파일을 decode하고, class에 바로 넣어주고, 리스트로 변환
    var jsonResponse = convert.jsonDecode(response.body);
    var jr = jsonResponse['response']['body']['items'];
    jr = jr.cast<Map<String, dynamic>>();
    jr = jr.map<Getsaftyscore>((json) => Getsaftyscore.fromJson(json)).toList();

    List<Getsaftyscore> newjr = []; //json 받아왔을 때 비어있는 데이터 처리를 위한 리스트

    int index = 0;

    DateTime lastday= new DateTime(now.year, now.month, now.day  + 1); //다 돌아간 날짜를 체크하기 위함
    jr.forEach((x) {
      int day = int.parse(x.Date.split("-")[2]);
      while (date != day) {
        DateTime mydate = new DateTime(now.year, now.month, now.day - index);
        lastday = mydate;
        String mydateday = formatter.format(mydate);
        //비어있는 데이터 넣기
        newjr.insert(
            index, new Getsaftyscore(eco_avg: 0, safe_avg: 0, Date: mydateday));
        date = date - 1;
        index = index + 1;
      }

      lastday = DateFormat('yyyy-MM-dd').parse(x.Date);

      //기존 데이터 넣기
      newjr.insert(index, x);

      date = date - 1;
      index = index + 1;
    });

    //마지막 날짜와 원하는 날짜까지의 차이
    int countday = lastday.difference(lastweek).inDays;

    int len = newjr.length;
    //만약에 들어있는 데이터가 마지막 날짜가 아니라면, 나머지 데이터 모두 0으로 채우기
    for (int i = len; i < len + countday; i++) {
      DateTime mydate = new DateTime(now.year, now.month, now.day - i);
      String mydateday = formatter.format(mydate);
      newjr.insert(
          i, new Getsaftyscore(eco_avg: 0, safe_avg: 0, Date: mydateday));
    }
    //거꾸로 들어온 데이터 뒤집기
    //안전운전 점수 리스트 저장
    saftyscorelist = new List.from(newjr.reversed);

    double sum = 0;
    double ecosum = 0;
    int lastonecount = 0;
    //지난주 운전 횟수 계산, 지난주 평균 계산
    saftyscorelist.getRange(0, 7).toList().forEach((element) {
      if (element.safe_avg == 0) {
        lastweekcnt = lastweekcnt + 1;
      } else {
        sum = sum + element.safe_avg;
        ecosum = ecosum + element.eco_avg;
        //경제 점수 평균
        lastonecount = lastonecount + 1;
      }
    });

    lastavg = (sum / lastonecount);
    ecolastavg = ecosum / lastonecount;


    //이번주 평균 계산
    sum = 0;
    ecosum = 0;
    int onecount = 0;
    saftyscorelist.getRange(7, 14).toList().forEach((element) {
      if (element.safe_avg != 0) {
        sum = sum + element.safe_avg;
        ecosum = ecosum + element.eco_avg;
        // 경제점수 평균
        onecount = onecount + 1;
      }
    });
    thisavg = sum / onecount;
    ecothisavg = ecosum / onecount;

    //경제운전 점수 리스트에 추가
    economicscorelist = new List.from(newjr.reversed);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

// 연비 점수 api
void getdaliyfuel() async {
  print("연비점수");
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
<<<<<<< Updated upstream
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
=======
      //거꾸로 들어온 데이터 뒤집기
      daliyfuellist = new List.from(newjr.reversed);

      double feulsum = 0;
      int lastonecount = 0;
      //지난주 연비평균 계산, 지난주 평균 계산
      daliyfuellist.getRange(0, 7).toList().forEach((element) {
        if (element.DrvFuelUsement == 0) {
          lastweekcnt = lastweekcnt + 1;
        } else {
          feulsum = feulsum + element.DrvFuelUsement;
          //경제 점수 평균
          lastonecount = lastonecount + 1;
        }
      });

      fuellastavg = feulsum / lastonecount;

      //이번주 평균 계산
      feulsum = 0;
      int onecount = 0;
      daliyfuellist.getRange(7, 14).toList().forEach((element) {
        if (element.DrvFuelUsement != 0) {
          feulsum = feulsum + element.DrvFuelUsement;
          // 연비점수 평균
          onecount = onecount + 1;
        }
      });
      fuelthisavg = feulsum / lastonecount;

    } else {
      //빈 파일 처리
>>>>>>> Stashed changes
    }
    //거꾸로 들어온 데이터 뒤집기
    daliyfuellist = new List.from(newjr.reversed);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

//지난주 주행거리 합 api
void getdrivingdistance_last() async {
  print("지난주 주행");
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
  new DateTime(originnow.year, originnow.month, originnow.day -numyoil);
  final DateTime lastweek = new DateTime(
      originnow.year, originnow.month, originnow.day -6 -numyoil);

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

    drivingdistancelist = jr[0].RecDrvDisSum ;
  } else {//불러오기 실패!
    print('Request failed with status: ${response.statusCode}.');
  }
}


////위험 운전행동 발생 횟수 기능 api

//급감속 api
void getdecelerationscore() async {
  print("급감속");
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
  final DateTime lastSunday = new DateTime(
      originnow.year, originnow.month, originnow.day - numyoil - 7);
  final DateTime thisMonday = new DateTime(
      originnow.year, originnow.month, originnow.day - numyoil - 6);
  final DateTime lastweek = new DateTime(
      originnow.year, originnow.month, originnow.day - 13 - numyoil);

  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // string으로 바꾸기 위함

  //날짜를 문자열로 변환하기, class에 넣어주기 위함
  final String today = formatter.format(now);
  final String lastSundayDay = formatter.format(lastSunday);
  final String thisMondayDay = formatter.format(thisMonday);
  final String lastweekday = formatter.format(lastweek);

  int date = now.day as int; //현재 날짜에서 '일'만 가져와서 아래에서 카운트 하기 위함

  // 이번주
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=$thisMondayDay&endDate=$today&eventCode=EventCode03';

  var response = await http.get(
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


    int index = 0;
    int countSum = 0;
    DateTime lastday = new DateTime(now.year, now.month, now.day  + 1);

    jr.forEach((x) {
      countSum += x.countEvent; // 해당 날짜에 일어난 급감속 총 횟수 계산

      int day = int.parse(x.Date.split("-")[2]);

      while (date != day) {
        DateTime mydate = new DateTime(now.year, now.month, now.day - index);
        String mydateday = formatter.format(mydate);

        //비어있는 데이터 넣기
        countAllEventForEachDay.insert(
            index, new GetDrivingwarningscore(countEvent: 0, Date: mydateday));
        //update
        date = date - 1;
        index = index + 1;
      }

      lastday = DateFormat('yyyy-MM-dd').parse(x.Date);
      countAllEventForEachDay.insert(index, x);

      //update
      index = index + 1;
      date = date - 1;
    });


    countEventForThisWeek
        .add(new CountEventForEvent(name: "급감속", count: countSum));

    int countday = lastday.difference(thisMonday).inDays;

    int len = countAllEventForEachDay.length;

    //만약에 들어있는 데이터가 마지막 날짜가 아니라면, 나머지 데이터 모두 0으로 채우기
    for (int i = len; i < len + countday; i++) {
      DateTime mydate = new DateTime(now.year, now.month, now.day - i);
      String mydateday = formatter.format(mydate);
      countAllEventForEachDay.insert(
          i, new GetDrivingwarningscore(countEvent: 0, Date: mydateday));
    }

  } else {
    print('Request failed with status: ${response.statusCode}.');
  }

  // 저번주
  url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=$lastweekday&endDate=$lastSundayDay&eventCode=EventCode03';

  response = await http.get(
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

    int index = 7;
    int countSum = 0;
    DateTime lastday = new DateTime(now.year, now.month, now.day - index + 1);
    jr.forEach((x) {

      countSum += x.countEvent; // 해당 날짜에 일어난 급감속 총 횟수 계산
      int day = int.parse(x.Date.split("-")[2]);
      while (date != day) {
        DateTime mydate = new DateTime(now.year, now.month, now.day - index);

        String mydateday = formatter.format(mydate);
        //비어있는 데이터 넣기

        countAllEventForEachDay.insert(
            index, new GetDrivingwarningscore(countEvent: 0, Date: mydateday));
        date = date - 1;
        index = index + 1;


      }
      lastday = DateFormat('yyyy-MM-dd').parse(x.Date);
      countAllEventForEachDay.insert(index, x);

      index = index + 1;
      date = date - 1;
    });

    int countday = lastday.difference(lastweek).inDays;
    int len = countAllEventForEachDay.length;

    //만약에 들어있는 데이터가 마지막 날짜가 아니라면, 나머지 데이터 모두 0으로 채우기
    for (int i = len; i < len + countday; i++) {
      DateTime mydate = new DateTime(now.year, now.month, now.day - i);
      String mydateday = formatter.format(mydate);
      countAllEventForEachDay.insert(
          i, new GetDrivingwarningscore(countEvent: 0, Date: mydateday));
    }

    countEventForLastWeek
        .add(new CountEventForEvent(name: "급감속", count: countSum));


  } else {
    print('Request failed with status: ${response.statusCode}.');
  }

}

//급가속 api
void getaccelerationscore() async {
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
  final DateTime lastSunday = new DateTime(
      originnow.year, originnow.month, originnow.day - numyoil - 7);
  final DateTime thisMonday = new DateTime(
      originnow.year, originnow.month, originnow.day - numyoil - 6);
  final DateTime lastweek = new DateTime(
      originnow.year, originnow.month, originnow.day - 13 - numyoil);

  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // string으로 바꾸기 위함

  //날짜를 문자열로 변환하기, class에 넣어주기 위함
  final String today = formatter.format(now);
  final String lastSundayDay = formatter.format(lastSunday);
  final String thisMondayDay = formatter.format(thisMonday);
  final String lastweekday = formatter.format(lastweek);

  int date = now.day as int; //현재 날짜에서 '일'만 가져와서 아래에서 카운트 하기 위함

  // 이번주
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=$thisMondayDay&endDate=$today&eventCode=EventCode02';
  var response = await http.get(
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

    int index = 0;
    int countSum = 0;
    jr.forEach((x) {
      countSum += x.countEvent; // 해당 날짜에 일어난 급가속 총 횟수 계산
      int day = int.parse(x.Date.split("-")[2]);
      while (date != day) {
        date = date - 1;
        index = index + 1;
      }
      countAllEventForEachDay[index].countEvent += x.countEvent;

      index = index + 1;
      date = date - 1;
    });

    countEventForThisWeek
        .add(new CountEventForEvent(name: "급가속", count: countSum));
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }

  // 저번주
  url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=$lastweekday&endDate=$lastSundayDay&eventCode=EventCode02';
  response = await http.get(
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

    int index = 7;
    int countSum = 0;
    jr.forEach((x) {
      countSum += x.countEvent; // 해당 날짜에 일어난 급가속 총 횟수 계산
      int day = int.parse(x.Date.split("-")[2]);
      while (date != day) {
        date = date - 1;
        index = index + 1;
      }
      countAllEventForEachDay[index].countEvent += x.countEvent;

      index = index + 1;
      date = date - 1;
    });

    countEventForLastWeek
        .add(new CountEventForEvent(name: "급가속", count: countSum));

    print('급가속');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

//급회전 api
void getrotationscore() async {
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
  final DateTime lastSunday = new DateTime(
      originnow.year, originnow.month, originnow.day - numyoil - 7);
  final DateTime thisMonday = new DateTime(
      originnow.year, originnow.month, originnow.day - numyoil - 6);
  final DateTime lastweek = new DateTime(
      originnow.year, originnow.month, originnow.day - 13 - numyoil);

  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // string으로 바꾸기 위함

  //날짜를 문자열로 변환하기, class에 넣어주기 위함
  final String today = formatter.format(now);
  final String lastSundayDay = formatter.format(lastSunday);
  final String thisMondayDay = formatter.format(thisMonday);
  final String lastweekday = formatter.format(lastweek);

  int date = now.day as int; //현재 날짜에서 '일'만 가져와서 아래에서 카운트 하기 위함

  // 이번주
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=$thisMondayDay&endDate=$today&eventCode=EventCode02';
  var response = await http.get(
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

    int index = 0;
    int countSum = 0;
    jr.forEach((x) {
      countSum += x.countEvent; // 해당 날짜에 일어난 급회전 총 횟수 계산
      int day = int.parse(x.Date.split("-")[2]);
      while (date != day) {
        date = date - 1;
        index = index + 1;
      }
      countAllEventForEachDay[index].countEvent += x.countEvent;

      index = index + 1;
      date = date - 1;
    });

    countEventForThisWeek
        .add(new CountEventForEvent(name: "급회전", count: countSum));
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }

  // 저번주
  url =
  'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=$lastweekday&endDate=$lastSundayDay&eventCode=EventCode02';
  response = await http.get(
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

    int index = 7;
    int countSum = 0;
    jr.forEach((x) {
      countSum += x.countEvent; // 해당 날짜에 일어난 급회전 총 횟수 계산
      int day = int.parse(x.Date.split("-")[2]);
      while (date != day) {
        date = date - 1;
        index = index + 1;
      }
      countAllEventForEachDay[index].countEvent += x.countEvent;

      index = index + 1;
      date = date - 1;
    });

    countEventForLastWeek
        .add(new CountEventForEvent(name: "급회전", count: countSum));
    print(countEventForLastWeek);
    print('급회전');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

//공회전 api
void getidlescore() async {
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
  final DateTime lastSunday = new DateTime(
      originnow.year, originnow.month, originnow.day - numyoil - 7);
  final DateTime thisMonday = new DateTime(
      originnow.year, originnow.month, originnow.day - numyoil - 6);
  final DateTime lastweek = new DateTime(
      originnow.year, originnow.month, originnow.day - 13 - numyoil);

  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // string으로 바꾸기 위함

  //날짜를 문자열로 변환하기, class에 넣어주기 위함
  final String today = formatter.format(now);
  final String lastSundayDay = formatter.format(lastSunday);
  final String thisMondayDay = formatter.format(thisMonday);
  final String lastweekday = formatter.format(lastweek);

  int date = now.day as int; //현재 날짜에서 '일'만 가져와서 아래에서 카운트 하기 위함

  // 이번주
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=$thisMondayDay&endDate=$today&eventCode=EventCode02';
  var response = await http.get(
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

    int index = 0;
    int countSum = 0;
    jr.forEach((x) {
      countSum += x.countEvent; // 해당 날짜에 일어난 공회전 총 횟수 계산
      int day = int.parse(x.Date.split("-")[2]);
      while (date != day) {
        date = date - 1;
        index = index + 1;
      }
      countAllEventForEachDay[index].countEvent += x.countEvent;

      index = index + 1;
      date = date - 1;
    });

    countEventForThisWeek
        .add(new CountEventForEvent(name: "공회전", count: countSum));

    print('공회전');
    print(countEventForLastWeek);

  } else {
    print('Request failed with status: ${response.statusCode}.');
  }

  // 저번주
  url =
  'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=$lastweekday&endDate=$lastSundayDay&eventCode=EventCode02';
  response = await http.get(
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

    int index = 7;
    int countSum = 0;
    jr.forEach((x) {
      countSum += x.countEvent; // 해당 날짜에 일어난 공회전 총 횟수 계산
      int day = int.parse(x.Date.split("-")[2]);
      while (date != day) {
        date = date - 1;
        index = index + 1;
      }
      countAllEventForEachDay[index].countEvent += x.countEvent;

      index = index + 1;
      date = date - 1;
    });

    countEventForLastWeek
        .add(new CountEventForEvent(name: "공회전", count: countSum));

    countAllEventForEachDay = new List.from(countAllEventForEachDay.reversed);


  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

// 지출 내역 api
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
