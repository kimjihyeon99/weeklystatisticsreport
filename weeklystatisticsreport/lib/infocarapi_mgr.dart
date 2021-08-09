import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'containerItem.dart';
import 'save_getapi.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

//날짜 선언
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
//infocar api 서버와 연결

Future<String> getallapi() async {
  await getServerUploadtime();
  await getsafyscore();
  await getdaliyfuel();
  await getTotaldailyfuel();
  await getdrivingdistance_last();
  await getdrivingdistance_this();
  await getTotalDrivingdistance();
  await getdecelerationscore();
  await geteventscore("EventCode02", "급가속");
  await geteventscore("EventCode10", "급회전");
  await geteventscore("EventCode01", "공회전");
  await getTotalEventCount();
  await getSpending();
  await getInspection();

  return 'Data Loaded';
}

void getServerUploadtime() async {
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/userUploadTime?userKey=1147';
  var response = await http.get(
    Uri.parse(url),
    headers: {
      "F_TOKEN":
          "D5CFB732E7BA8E56356AA766B61EEF32F5F1BCA6F554FB0A9432D285A7E012A3"
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var jr = jsonResponse['response']['body']['items'][0];

    uploadTime = jr['LAST_UPLOAD_TIME'];
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

//// 안전운전, 경제운전 점수 기능 api
void getsafyscore() async {
  //현재 날짜와 지난주 날짜 가져오기
  final DateTime now =
      new DateTime(originnow.year, originnow.month, originnow.day - numyoil);
  final DateTime lastweek = new DateTime(
      originnow.year, originnow.month, originnow.day - 13 - numyoil);

  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // string으로 바꾸기 위함

  //날짜를 문자열로 변환하기, class에 넣어주기 위함
  final String today = formatter.format(now);
  final String lastweekday = formatter.format(lastweek);

  DateTime date = now; //현재 날짜에서 '일'만 가져와서 아래에서 카운트 하기 위함

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
    jr = jr
        .map<Getdrivingscore>((json) => Getdrivingscore.fromJson(json))
        .toList();

    List<Getdrivingscore> newjr = []; //json 받아왔을 때 비어있는 데이터 처리를 위한 리스트

    int index = 0;

    DateTime lastday =
        new DateTime(now.year, now.month, now.day + 1); //다 돌아간 날짜를 체크하기 위함

    jr.forEach((x) {
      var date_str = formatter.format(date);

      while (date_str != x.Date) {
        DateTime mydate = new DateTime(now.year, now.month, now.day - index);
        String mydateday = formatter.format(mydate);
        //비어있는 데이터 넣기
        newjr.insert(index,
            new Getdrivingscore(eco_avg: 0, safe_avg: 0, Date: mydateday));

        date = new DateTime(date.year, date.month, date.day - 1);
        date_str = formatter.format(date);
        index = index + 1;
      }

      lastday = DateFormat('yyyy-MM-dd').parse(x.Date);

      //기존 데이터 넣기
      newjr.insert(index, x);

      date = new DateTime(date.year, date.month, date.day - 1);
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
          i, new Getdrivingscore(eco_avg: 0, safe_avg: 0, Date: mydateday));
    }

    //안전운전 점수 리스트 저장
    saftyscorelist = new List.from(newjr.reversed);

    double safesum = 0;
    double ecosum = 0;
    int lastonecount = 0; //지난주 주행 횟수 확인
    //지난주 운전 횟수 계산, 지난주 평균 계산
    saftyscorelist.getRange(0, 7).toList().forEach((element) {
      if (element.safe_avg == 0) {
        lastweekcnt = lastweekcnt + 1;
      } else {
        safesum = safesum + element.safe_avg;
        ecosum = ecosum + element.eco_avg;

        lastonecount = lastonecount + 1;
      }
    });
    //안전,경제 점수 평균
    safelastavg = safesum / lastonecount;
    ecolastavg = ecosum / lastonecount;

    if (lastonecount == 0) {
      safelastavg = 0;
      ecolastavg = 0;
    } else {
      safelastavg = safesum / lastonecount;
      ecolastavg = ecosum / lastonecount;
    }

    //이번주 평균 계산
    safesum = 0;
    ecosum = 0;
    int thisonecount = 0;
    saftyscorelist.getRange(7, 14).toList().forEach((element) {
      if (element.safe_avg != 0) {
        safesum = safesum + element.safe_avg;
        ecosum = ecosum + element.eco_avg;

        thisonecount = thisonecount + 1;
      }
    });
    // 안전, 경제점수 평균
    safethisavg = safesum / thisonecount;
    ecothisavg = ecosum / thisonecount;

    if (thisonecount == 0) {
      safethisavg = 0;
      ecothisavg = 0;
    } else {
      safethisavg = safesum / thisonecount;
      ecothisavg = ecosum / thisonecount;
    }

    //경제운전 점수 리스트에 추가
    economicscorelist = new List.from(newjr.reversed);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

// 연비 점수 api
void getdaliyfuel() async {
  //현재 날짜와 지난주 날짜 가져오기
  final DateTime now =
      new DateTime(originnow.year, originnow.month, originnow.day - numyoil);
  final DateTime lastweek = new DateTime(
      originnow.year, originnow.month, originnow.day - 13 - numyoil);

  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // string으로 바꾸기 위함

  //날짜를 문자열로 변환하기, class에 넣어주기 위함
  final String today = formatter.format(now);
  final String lastweekday = formatter.format(lastweek);

  DateTime date = now; //현재 날짜에서 '일'만 가져와서 아래에서 카운트 하기 위함

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

    List<Getdaliyfuel> newjr = []; //json 받아왔을 때 비어있는 데이터 처리를 위한 리스트

    int index = 0;

    DateTime lastday =
        new DateTime(now.year, now.month, now.day + 1); //다 돌아간 날짜를 체크하기 위함
    jr.forEach((x) {
      var date_str = formatter.format(date);

      while (date_str != x.Date) {
        DateTime mydate = new DateTime(now.year, now.month, now.day - index);
        String mydateday = formatter.format(mydate);
        //비어있는 데이터 넣기
        newjr.insert(
            index, new Getdaliyfuel(DrvFuelUsement: 0, Date: mydateday));
        date = new DateTime(date.year, date.month, date.day - 1);
        date_str = formatter.format(date);
        index = index + 1;
      }

      lastday = DateFormat('yyyy-MM-dd').parse(x.Date);
      //기존 데이터 넣기
      newjr.insert(index, x);

      date = new DateTime(date.year, date.month, date.day - 1);
      index = index + 1;
    });

    //마지막 날짜와 원하는 날짜까지의 차이
    int countday = lastday.difference(lastweek).inDays;
    int len = newjr.length;

    //만약에 들어있는 데이터가 마지막 날짜가 아니라면, 나머지 데이터 모두 0으로 채우기
    for (int i = len; i < len + countday; i++) {
      DateTime mydate = new DateTime(now.year, now.month, now.day - i);
      String mydateday = formatter.format(mydate);
      newjr.insert(i, new Getdaliyfuel(DrvFuelUsement: 0, Date: mydateday));
    }
    //거꾸로 들어온 데이터 뒤집기
    daliyfuellist = new List.from(newjr.reversed);

    double feulsum = 0;
    int lastonecount = 0; //지난주 연비 값이 존재하는 수

    //지난주 연비평균 계산
    daliyfuellist.getRange(0, 7).toList().forEach((element) {
      if (element.DrvFuelUsement == 0) {
        lastweekcnt = lastweekcnt + 1;
      } else {
        feulsum = feulsum + element.DrvFuelUsement;
        lastonecount = lastonecount + 1;
      }
    });

    if (lastonecount == 0) {
      fuellastavg = 0;
    } else {
      fuellastavg = feulsum / lastonecount;
    }

    //이번주 평균 계산
    feulsum = 0;
    int thisonecount = 0;
    daliyfuellist.getRange(7, 14).toList().forEach((element) {
      if (element.DrvFuelUsement != 0) {
        feulsum = feulsum + element.DrvFuelUsement;
        thisonecount = thisonecount + 1;
      }
    });

    if (thisonecount == 0) {
      fuelthisavg = 0;
    } else {
      fuelthisavg = feulsum / thisonecount;
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

// 총 사용자 이번주 연비 점수 api
void getTotaldailyfuel() async {
  //이번주 날짜 가져오기
  final DateTime now =
      new DateTime(originnow.year, originnow.month, originnow.day - numyoil);
  final DateTime lastweek = new DateTime(
      originnow.year, originnow.month, originnow.day - 6 - numyoil);

  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // string으로 바꾸기 위함

  //날짜를 문자열로 변환하기, class에 넣어주기 위함
  final String today = formatter.format(now);
  final String lastweekday = formatter.format(lastweek);

  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/totalCbookAvg?startDate=$lastweekday&endDate=$today';
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
    Totalfluelavg = jr['CbookCountAvg'];
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

//지난주 주행거리 합 api
void getdrivingdistance_last() async {
  //현재 날짜와 지난주 날짜 가져오기
  final DateTime now = new DateTime(
      originnow.year, originnow.month, originnow.day - 7 - numyoil);
  final DateTime lastweek = new DateTime(
      originnow.year, originnow.month, originnow.day - 13 - numyoil);

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
    if (response.body.isNotEmpty) {
      //데이터가 있는 경우
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

      drivingdistancelist_last = (jr[0].RecDrvDisSum).toInt();
    } else {
      //데이터가 없는 경우
      drivingdistancelist_last = 0;
    }
  } else {
    //불러오기 실패!
    print('Request failed with status: ${response.statusCode}.');
  }
}

//이번주 주행거리 합
void getdrivingdistance_this() async {
  //현재 날짜와 지난주 날짜 가져오기
  final DateTime now =
      new DateTime(originnow.year, originnow.month, originnow.day - numyoil);
  final DateTime lastweek = new DateTime(
      originnow.year, originnow.month, originnow.day - 6 - numyoil);

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
    if (response.body.isNotEmpty) {
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

      drivingdistancelist_this = (jr[0].RecDrvDisSum).toInt();

      maxdistance = (drivingdistancelist_this > drivingdistancelist_last)
          ? drivingdistancelist_this
          : drivingdistancelist_last;
    } else {
      drivingdistancelist_this = 0;
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

//총 사용자 이번주 주행거리 합 평균
void getTotalDrivingdistance() async {
  //현재 날짜와 지난주 날짜 가져오기
  final DateTime now =
      new DateTime(originnow.year, originnow.month, originnow.day - numyoil);
  final DateTime lastweek = new DateTime(
      originnow.year, originnow.month, originnow.day - 6 - numyoil);

  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // string으로 바꾸기 위함

  //날짜를 문자열로 변환하기, class에 넣어주기 위함
  final String today = formatter.format(now);
  final String lastweekday = formatter.format(lastweek);

  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/totalDrvDisAvg?startDate=$lastweekday&endDate=$today';
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
    TotaldrivingdistanceForAllUser = jr['DrvDisAvg'].toInt();

    maxdistance = (maxdistance > TotaldrivingdistanceForAllUser)
        ? maxdistance
        : TotaldrivingdistanceForAllUser;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

////위험 운전행동 발생 횟수 기능 api
//급감속 api
void getdecelerationscore() async {
  // 초기화
  countAllEventForLastWeek = 0;
  countAllEventForThisWeek = 0;
  countAllEventForEachDay = [];
  countEventForLastWeek = [];
  countEventForThisWeek = [];

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

  DateTime date = now; //현재 날짜에서 '일'만 가져와서 아래에서 카운트 하기 위함

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
  int index = 0; //2주간의 날짜를 순서대로 가져오기 위한 것

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var jr = jsonResponse['response']['body']['items'];

    jr = jr.cast<Map<String, dynamic>>();
    jr = jr
        .map<GetDrivingwarningscore>(
            (json) => GetDrivingwarningscore.fromJson(json))
        .toList();

    int thiscountSum = 0; // 해당 날짜에 일어난 이번주 급감속 총 횟수 계산
    DateTime lastday = new DateTime(now.year, now.month, now.day + 1);

    jr.forEach((x) {
      thiscountSum += x.countEvent;

      var date_str = formatter.format(date);

      while (date_str != x.Date) {
        DateTime mydate = new DateTime(now.year, now.month, now.day - index);
        String mydateday = formatter.format(mydate);

        //비어있는 데이터 넣기
        countAllEventForEachDay.insert(
            index, new GetDrivingwarningscore(countEvent: 0, Date: mydateday));
        //update
        date = new DateTime(date.year, date.month, date.day - 1);
        date_str = formatter.format(date);
        index = index + 1;
      }

      lastday = DateFormat('yyyy-MM-dd').parse(x.Date);
      countAllEventForEachDay.insert(index, x);

      //update
      date = new DateTime(date.year, date.month, date.day - 1);
      index = index + 1;
    });

    countEventForThisWeek
        .add(new CountEventForEvent(name: "급감속", count: thiscountSum));
    countAllEventForThisWeek += thiscountSum;

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

    int lastcountSum = 0; // 해당 날짜에 일어난 저번주 급감속 총 횟수 계산
    DateTime lastday = new DateTime(now.year, now.month, now.day - index + 1);
    jr.forEach((x) {
      lastcountSum += x.countEvent;

      var date_str = formatter.format(date);

      while (date_str != x.Date) {
        DateTime mydate = new DateTime(now.year, now.month, now.day - index);
        String mydateday = formatter.format(mydate);
        //비어있는 데이터 넣기
        countAllEventForEachDay.insert(
            index, new GetDrivingwarningscore(countEvent: 0, Date: mydateday));
        date = new DateTime(date.year, date.month, date.day - 1);
        date_str = formatter.format(date);
        index = index + 1;
      }
      lastday = DateFormat('yyyy-MM-dd').parse(x.Date);
      countAllEventForEachDay.insert(index, x);

      date = new DateTime(date.year, date.month, date.day - 1);
      index = index + 1;
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
        .add(new CountEventForEvent(name: "급감속", count: lastcountSum));

    countAllEventForLastWeek += lastcountSum;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

//급가속, 급회전, 공회전 api
void geteventscore(String eventcode, String eventname) async {
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

  DateTime date = now; //현재 날짜에서 '일'만 가져와서 아래에서 카운트 하기 위함

  // 이번주
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=$thisMondayDay&endDate=$today&eventCode=$eventcode'; //이벤트 코드
  var response = await http.get(
    Uri.parse(url),
    headers: {
      "F_TOKEN":
          "D5CFB732E7BA8E56356AA766B61EEF32F5F1BCA6F554FB0A9432D285A7E012A3"
    },
  );
  int index = 0; //2주간의 날짜를 순서대로 가져오기 위한 것
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var jr = jsonResponse['response']['body']['items'];
    jr = jr.cast<Map<String, dynamic>>();
    jr = jr
        .map<GetDrivingwarningscore>(
            (json) => GetDrivingwarningscore.fromJson(json))
        .toList();

    int thiscountSum = 0; // 해당 날짜에 일어난 이번주 공회전 총 횟수 계산
    jr.forEach((x) {
      thiscountSum += x.countEvent;
      var date_str = formatter.format(date);

      while (date_str != x.Date) {
        date = new DateTime(date.year, date.month, date.day - 1);
        date_str = formatter.format(date);
        index = index + 1;
      }
      countAllEventForEachDay[index].countEvent += x.countEvent; //일일 공회전 횟수 계산

      date = new DateTime(date.year, date.month, date.day - 1);
      index = index + 1;
    });

    countEventForThisWeek
        .add(new CountEventForEvent(name: eventname, count: thiscountSum));

    countAllEventForThisWeek += thiscountSum;

    if (eventname == "공회전" && countAllEventForThisWeek == 0) {
      isZeroEventCountForThisWeek = true;
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }

  // 저번주
  url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/eventCount?userKey=1147&startDate=$lastweekday&endDate=$lastSundayDay&eventCode=$eventcode';

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

    int lastcountSum = 0; // 해당 날짜에 일어난 지난주 공회전 총 횟수 계산
    jr.forEach((x) {
      lastcountSum += x.countEvent;
      var date_str = formatter.format(date);
      while (date_str != x.Date) {
        date = new DateTime(date.year, date.month, date.day - 1);
        date_str = formatter.format(date);
        index = index + 1;
      }
      countAllEventForEachDay[index].countEvent += x.countEvent; //일일 공회전 횟수 계산

      date = new DateTime(date.year, date.month, date.day - 1);
      index = index + 1;
    });
    //고치기-> countAll 로 지난주 카운트가 있는지 확인하기

    countEventForLastWeek
        .add(new CountEventForEvent(name: eventname, count: lastcountSum));

    countAllEventForLastWeek += lastcountSum;
    if (eventname == "공회전" && countAllEventForLastWeek == 0) {
      isZeroEventCountForLastWeek = true;
    }
    if (eventname == "공회전") {
      countAllEventForEachDay = new List.from(countAllEventForEachDay.reversed);
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

// 이번주 전체 사용자 위험운전행동 평균횟수 api
void getTotalEventCount() async {
  final DateTime thisSundayDate =
      new DateTime(originnow.year, originnow.month, originnow.day - numyoil);
  final DateTime thisMondayDate = new DateTime(
      originnow.year, originnow.month, originnow.day - 6 - numyoil);

  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // string으로 바꾸기 위함

  //날짜를 문자열로 변환하기, class에 넣어주기 위함
  final String thisSunday = formatter.format(thisSundayDate);
  final String thisMonday = formatter.format(thisMondayDate);

  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/totalEventCountAvg?userKey=1147&startDate=$thisMonday&endDate=$thisSunday';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      "F_TOKEN":
          "D5CFB732E7BA8E56356AA766B61EEF32F5F1BCA6F554FB0A9432D285A7E012A3"
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    TotalEventCountAvgForAllUser =
        jsonResponse['response']['body']['items']['EventCountAvg'].toInt();
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

// 지출 내역 api
void getSpending() async {
  //초기화
  spendinglist_last = [];
  spendinglist_this = [];
  sumAllspending_last = 0;
  sumAllspending_this = 0;

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

  //지난주
  String url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/cbookCraditLite?userKey=1147&startDate=$lastweekday&endDate=$lastSundayDay';
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

    spendinglist_last.add(new GetSpending(
        name: "주유•세차비",
        cost: jr["fuel_cost"].toDouble() + jr["car_wash_cost"].toDouble()));
    spendinglist_last.add(new GetSpending(
        name: "통행•주차비",
        cost: jr["toll_fee"].toDouble() + jr["parking_fee"].toDouble()));
    spendinglist_last.add(new GetSpending(
        name: "차량정비", cost: jr["vehicle_maintenance"].toDouble()));
    spendinglist_last
        .add(new GetSpending(name: "보험료", cost: jr["car_premium"].toDouble()));
    spendinglist_last
        .add(new GetSpending(name: "기타", cost: jr["etc"].toDouble()));

    sumAllspending_last = (jr["fuel_cost"].toDouble() +
            jr["car_wash_cost"].toDouble() +
            jr["toll_fee"].toDouble() +
            jr["parking_fee"].toDouble() +
            jr["vehicle_maintenance"].toDouble() +
            jr["car_premium"].toDouble() +
            jr["etc"].toDouble())
        .toInt();
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }

  //이번주
  url =
      'https://server2.mureung.com/infocarAdminPageAPI/sideproject/cbookCraditLite?userKey=1147&startDate=$thisMondayDay&endDate=$today';
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

    //mapping
    spendinglist_this.add(new GetSpending(
        name: "주유•세차비",
        cost: jr["fuel_cost"].toDouble() + jr["car_wash_cost"].toDouble()));
    spendinglist_this.add(new GetSpending(
        name: "통행•주차비",
        cost: jr["toll_fee"].toDouble() + jr["parking_fee"].toDouble()));
    spendinglist_this.add(new GetSpending(
        name: "차량정비", cost: jr["vehicle_maintenance"].toDouble()));
    spendinglist_this
        .add(new GetSpending(name: "보험료", cost: jr["car_premium"].toDouble()));
    spendinglist_this
        .add(new GetSpending(name: "기타", cost: jr["etc"].toDouble()));

    sumAllspending_this = (jr["fuel_cost"].toDouble() +
            jr["car_wash_cost"].toDouble() +
            jr["toll_fee"].toDouble() +
            jr["parking_fee"].toDouble() +
            jr["vehicle_maintenance"].toDouble() +
            jr["car_premium"].toDouble() +
            jr["etc"].toDouble())
        .toInt();
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

void getInspection() async {
  replace_item = [];

  var result = await rootBundle.loadString('json/inspection.json');

  var response = convert.json.decode(result);

  var jr = response["items"];
  jr = jr.cast<Map<String, dynamic>>();
  List<GetInspection> inspections =
      jr.map<GetInspection>((json) => GetInspection.fromJson(json)).toList();

  inspections.forEach((element) {
    var remain_distance =
        element.replacement_cycle_distance - element.usage_distance;
    //10일 간 주행할 수 있는 거리 계산
    var weekuse = (element.replacement_cycle_distance /
            (element.replacement_cycle_due * 30)) *
        10;
    //10일동안 사용할 수 있는 거리 이하인 경우 점검 필요항목에 추가
    if (remain_distance <= weekuse) {
      replace_item.add(element.name);
    }
  });
}
