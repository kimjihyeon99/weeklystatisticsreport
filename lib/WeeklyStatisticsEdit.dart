import 'package:flutter/material.dart';
import 'statisticview.dart';

List<bool> isActivate = List<bool>(7);

const PrimaryColor = const Color(0xff2980b9);
const SecondColor = const Color(0xff2B5490);

class WeeklyStatisticsEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '주간 통계 화면 편집',
      theme: new ThemeData(
          primaryColor: PrimaryColor,
          accentColor: PrimaryColor,
          canvasColor: PrimaryColor),
      home: new WeeklyStatisticsEditPage(),
    );
  }
}

class WeeklyStatisticsEditPage extends StatefulWidget {
  WeeklyStatisticsEditPage({Key key}) : super(key: key);

  @override
  _WeeklyStatisticsEditPage createState() => new _WeeklyStatisticsEditPage();
}

class _WeeklyStatisticsEditPage extends State<WeeklyStatisticsEditPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i=0; i<isActivate.length; i++) {
      isActivate[i] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            '주간 통계 화면 편집',
            style: new TextStyle(
              fontSize: 25.0,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // 주간 통계 화면으로 넘어가도록 구현
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => statisticview()));
            },
          ),
        ),
        body: new SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              makeAppbarContainer("활성화"),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:7,
                  itemBuilder: (context,index){
                    var id = "$index";
                    if(isActivate[0]==true && id.compareTo("0")==0){
                      return  makeActivationContainer("안전 점수");
                    }else if(isActivate[1]==true && id.compareTo("1")==0){
                      return  makeActivationContainer("경제 점수");
                    }else if(isActivate[2]==true && id.compareTo("2")==0){
                      return  makeActivationContainer("운전스타일 경고 점수");
                    }else if(isActivate[3]==true && id.compareTo("3")==0){
                      return  makeActivationContainer("일일 연비");
                    }else if(isActivate[4]==true && id.compareTo("4")==0){
                      return  makeActivationContainer("주행 거리");
                    }else if(isActivate[5]==true && id.compareTo("5")==0){
                      return  makeActivationContainer("지출 내역");
                    }else if(isActivate[6]==true && id.compareTo("6")==0){
                      return  makeActivationContainer("점검 필요 항목");
                    }
                    return null;
                  }
              ),
              makeAppbarContainer("비활성화"),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:7,
                  itemBuilder: (context,index){
                    var id = "$index";
                    if(isActivate[0]==false && id.compareTo("0")==0){
                      return  makeDeactivationContainer("안전 점수");
                    }else if(isActivate[1]==false && id.compareTo("1")==0){
                      return  makeDeactivationContainer("경제 점수");
                    }else if(isActivate[2]==false && id.compareTo("2")==0){
                      return  makeDeactivationContainer("운전스타일 경고 점수");
                    }else if(isActivate[3]==false && id.compareTo("3")==0){
                      return  makeDeactivationContainer("일일 연비");
                    }else if(isActivate[4]==false && id.compareTo("4")==0){
                      return  makeDeactivationContainer("주행 거리");
                    }else if(isActivate[5]==false && id.compareTo("5")==0){
                      return  makeDeactivationContainer("지출 내역");
                    }else if(isActivate[6]==false && id.compareTo("6")==0){
                      return  makeDeactivationContainer("점검 필요 항목");
                    }
                    return null;
                  }
              ),
            ],
          ),
        ),
    );
  }

  Widget makeAppbarContainer(String menuName) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(10.0),
      child: Text(
        menuName,
        style: new TextStyle(
          fontSize: 25.0,
          color: Colors.white,
        ),

      ),
      decoration: BoxDecoration(
        color: SecondColor,
      ),
        width: double.infinity,
        height: AppBar().preferredSize.height,
    );
  }

  Widget makeActivationContainer(String menuName) {
    return Container(
      // border를 추가하기 위해 Row를 Container로 감쌈
      child: Row(
        children: <Widget>[
          Expanded(
            // for Alignment
            child: new Icon(
              Icons.remove_circle,
              color: Colors.red,
            ),
          ),
          Expanded(
            flex: 21, // for Alignment
            child: new Text(
              menuName,
              style: new TextStyle(
                fontSize: 25.0,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: new Icon(
              Icons.menu,
              color: Colors.white,
            ),
          )
        ],
      ),
      decoration:
          BoxDecoration(border: Border.all(color: SecondColor, width: 1.2)),
      height: 50,
    );
  }

  Widget makeDeactivationContainer(String menuName) {
    return new Container(
      // border를 추가하기 위해 Row를 Container로 감쌈
      child: Row(children: <Widget>[
        Expanded(
          // for Alignment
          child: new Icon(
            Icons.add_circle,
            color: Colors.green,
          ),
        ),
        Expanded(
          flex: 21, // for Alignment
          child: new Text(
            menuName,
            style: new TextStyle(
              fontSize: 25.0,
              color: new Color(0xffE0E0E0),
            ),
          ),
        ),
        Expanded(
          child: new Icon(
            Icons.menu,
            color: Colors.white,
          ),
        )
      ]),
      decoration:
          BoxDecoration(border: Border.all(color: SecondColor, width: 1.2)),
      height: 50,
    );
  }
}
