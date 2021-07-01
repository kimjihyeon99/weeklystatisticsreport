import 'package:flutter/material.dart';
import 'statisticview.dart';



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
  Widget build(BuildContext context) {
    print(isActivate);
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
                    if(index==0  && isActivate[index] == true ){
                      return  makeActivationContainer("안전 점수", index);
                    }else if(index==1  && isActivate[index] == true){
                      return  makeActivationContainer("경제 점수", index);
                    }else if(index==2  && isActivate[index] == true){
                      return  makeActivationContainer("운전스타일 경고 점수", index);
                    }else if(index==3  && isActivate[index] == true){
                      return  makeActivationContainer("일일 연비", index);
                    }else if(index==4  && isActivate[index] == true){
                      return  makeActivationContainer("주행 거리", index);
                    }else if(index==5  && isActivate[index] == true){
                      return  makeActivationContainer("지출 내역", index);
                    }else if(index==6  && isActivate[index] == true){
                      return  makeActivationContainer("점검 필요 항목", index);
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
                    if(index==0  && isActivate[index] == false){
                      return  makeDeactivationContainer("안전 점수", index);
                    }else if(index==1  && isActivate[index] == false){
                      return  makeDeactivationContainer("경제 점수", index);
                    }else if(index==2  && isActivate[index] == false){
                      return  makeDeactivationContainer("운전스타일 경고 점수", index);
                    }else if(index==3  && isActivate[index] == false){
                      return  makeDeactivationContainer("일일 연비", index);
                    }else if(index==4  && isActivate[index] == false){
                      return  makeDeactivationContainer("주행 거리", index);
                    }else if(index==5  && isActivate[index] == false){
                      return  makeDeactivationContainer("지출 내역", index);
                    }else if(index==6  && isActivate[index] == false){
                      return  makeDeactivationContainer("점검 필요 항목", index);
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

  Widget makeActivationContainer(String menuName, int id) {
    return Container(
      // border를 추가하기 위해 Row를 Container로 감쌈
      child: Row(
        children: <Widget>[
          Expanded(
            // for Alignment
            child: new IconButton(
              icon: Icon(Icons.remove_circle),
              color: Colors.red,
              onPressed: () {
                isActivate[id] = false;
                print(isActivate);
                //reload
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WeeklyStatisticsEdit()));

              },
            ),
          ),
          Expanded(
            flex: 5, // for Alignment
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

  Widget makeDeactivationContainer(String menuName, int id) {
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
