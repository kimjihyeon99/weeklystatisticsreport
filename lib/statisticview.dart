import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'mainmenu.dart';

class statisticview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Generated App',
      theme: new ThemeData(
          primaryColor: const Color(0xff2980b9),
          accentColor: const Color(0xff2980b9),
          canvasColor: const Color(0xff2980b9)),
      home: new statisticviewPage(),
    );
  }
}

class statisticviewPage extends StatefulWidget {
  statisticviewPage({Key key, this.conlist}) : super(key: key);

  final List conlist;
  @override
  statistic_viewPage createState() => new statistic_viewPage();
}

class statistic_viewPage extends State<statisticviewPage> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(
          child: new Text(
            '주간 통계',
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 25.0,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => mainmenu()));
          },
        ),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                //팝업창
                showCupertinoDialog(
                    context: context,
                    //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new Container(
                              height: 800.0,
                              child: CupertinoAlertDialog(
                                //Dialog Main Title
                                title: Column(
                                  children: <Widget>[
                                    new Text("주간 통계"),
                                    new Container(height: 1.0, width: 400.0,color: Colors.grey)
                                  ],
                                ),
                                content: new Text("앱 내의 흩어져있는 차량 정보들을 수집하여 일주일마다 통계를 냅니다.\n\n ✔ 매주 월요일에 오전에 업데이트 됩니다. \n\n ✔ 설정버튼을 눌러 통계 정보들의 위치와 \n활성화 여부를 선택할 수 있습니다. "),
                                actions: <Widget>[
                                  new TextButton(
                                    child: Text("확인"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ));
                    });
              }),
          new IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                  //아영이 화면 가져오기
              })
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: 7,
        itemBuilder: (context, index){
          var id = "$index";
          if(id.compareTo("0")==0){
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.all(15),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(5,5), // changes position of shadow
                  ),
                ],
              ),
              child: Text("안전 점수", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23.0, color: Colors.black)),
            );
          }else if(id.compareTo("1")==0){
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.all(15),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(5,5), // changes position of shadow
                  ),
                ],
              ),
              child: Text("경제 점수", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23.0, color: Colors.black)),
            );
          }else if(id.compareTo("2")==0){
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.all(15),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(5,5), // changes position of shadow
                  ),
                ],
              ),
              child: Text("운전스타일 경고 점수", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23.0, color: Colors.black)),
            );
          }else if(id.compareTo("3")==0){
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.all(15),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(5,5), // changes position of shadow
                  ),
                ],
              ),
              child: Text("일일 연비", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23.0, color: Colors.black)),
            );
          }else if(id.compareTo("4")==0){
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.all(15),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(5,5), // changes position of shadow
                  ),
                ],
              ),
              child: Text("주행 거리", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23.0, color: Colors.black)),
            );
          }else if(id.compareTo("5")==0){
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.all(15),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(5,5), // changes position of shadow
                  ),
                ],
              ),
              child: Text("지출 내역", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23.0, color: Colors.black)),
            );
          }else if(id.compareTo("6")==0){
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.all(15),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(5,5), // changes position of shadow
                  ),
                ],
              ),
              child: Text("점검 필요 항목", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23.0, color: Colors.black)),
            );
          }

        } ,
      )
    );
  }
}
