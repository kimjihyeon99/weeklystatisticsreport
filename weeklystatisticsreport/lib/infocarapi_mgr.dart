import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'containerItem.dart';
import 'save_getapi.dart';

//infocar api 서버와 연결
void getsafyscore() async{
  String url = 'https://server2.mureung.com/infocarAdminPageAPI/sideproject/scoreAvg?userKey=1147&startDate=2021-07-04&endDate=2021-07-11';
  final response = await http.get(
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

//주간 주행거리 확인 기능 api
void getdrivingdistance() async{
  String url = 'https://server2.mureung.com/infocarAdminPageAPI/sideproject/recdrvDisSum?userKey=1147&startDate=2021-07-04&endDate=2021-07-11';
  final response = await http.get(
    Uri.parse(url),
    headers: {"F_TOKEN": "D5CFB732E7BA8E56356AA766B61EEF32F5F1BCA6F554FB0A9432D285A7E012A3"},
  );
  if (response.statusCode == 200) {
    var jsonResponse =
    convert.jsonDecode(response.body);
    var jr= jsonResponse['response']['body']['items'];
    jr= jr.cast<Map<String, dynamic>>();
    jr = jr.map<Getdrivingdistance>((json) => Getdrivingdistance.fromJson(json)).toList();
    drivingdistancelist= jr;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

