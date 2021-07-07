import 'package:flutter/material.dart';
import 'statisticview.dart';

const PrimaryColor = const Color(0xff2980b9);
const SecondColor = const Color(0xff2B5490);

//list를 head와 isActivate으로 나누기 위한 구조
abstract class ListItem {}

class HeadingItem implements ListItem {
  final String isActivate;

  HeadingItem(this.isActivate);
}

class isActivateItem implements ListItem {
  String Activatename;
  bool isactivate;

  isActivateItem(this.Activatename, this.isactivate);
}

//업데이트를 위한 activate 개수를 세기 위한것
int countactivate() {
  int count = 0;
  activate = [];
  deactivate = [];

  for (int i = 0; i < mylist.length; i++) {
    final item = mylist[i];
    if (item is isActivateItem) {
      if (item.isactivate) {
        activate.add(item.Activatename);
        count = count + 1;
      } else {
        deactivate.add(item.Activatename);
      }
    }
  }
  return count;
}

//head를 넘어가서 위치 바꾸기 방지를 위한 것
int baseindex = 0;

class WeeklyStatisticsEdit extends StatelessWidget {
  //staticview에서 받아온 정보
  final List<ListItem> items;

  WeeklyStatisticsEdit({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '주간 통계 화면 편집',
      theme: new ThemeData(
          primaryColor: PrimaryColor,
          accentColor: PrimaryColor,
          canvasColor: PrimaryColor),
      home: new WeeklyStatisticsEditPage(items: items),
    );
  }
}

class WeeklyStatisticsEditPage extends StatefulWidget {
  final List<ListItem> items;

  WeeklyStatisticsEditPage({Key key, @required this.items}) : super(key: key);

  @override
  _WeeklyStatisticsEditPage createState() =>
      new _WeeklyStatisticsEditPage(items: items);
}

class _WeeklyStatisticsEditPage extends State<WeeklyStatisticsEditPage> {
  List<ListItem> items;

  _WeeklyStatisticsEditPage({@required this.items});

  @override
  Widget build(BuildContext context) {
    //순서 정보가 바뀔때 마다 , mylist에 저장하기와  activate deactivate 도 업데이트(동기화)
    mylist = items;
    int ct = countactivate();
    print(ct);

    return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
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
        body:
        Container(
            height : MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [PrimaryColor, Color(0xFFD8BFD8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: new ReorderableListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              if (item is HeadingItem) {
                return makeAppbarContainer(item.isActivate, index);
              } else if (item is isActivateItem) {
                if (item.isactivate == true) {
                  return makeActivationContainer(item.Activatename, index);
                } else {
                  return makeDeactivationContainer(item.Activatename, index);
                }
              }
            },
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                //head를 넘어가면 위치바꾸기 적용 안되게 제한하기
                final ListItem temp = items[oldIndex];

                for (int i = 0; i < items.length; i++) {
                  var item = items[i];
                  if (item is HeadingItem) {
                    if (item.isActivate.compareTo("비활성화") == 0) {
                      baseindex = i;
                    }
                  }
                }

                if (temp is isActivateItem) {
                  if (temp.isactivate == true) {
                    //활성화
                    if (baseindex >= newIndex && newIndex != 0) {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final ListItem item = items.removeAt(oldIndex);
                      items.insert(newIndex, item);
                    }
                  } else {
                    //비활성화
                    if (baseindex < newIndex && newIndex != 0) {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final ListItem item = items.removeAt(oldIndex);
                      items.insert(newIndex, item);
                    }
                  }
                }
              });
            },
          ),
        )

    );
  }

  Widget makeAppbarContainer(String menuName, int index) {
    return Container(
      key: Key('$index'),
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

  Widget makeActivationContainer(String menuName, int index) {
    return Container(
      key: Key('$index'),
      // border를 추가하기 위해 Row를 Container로 감쌈
      child: Row(
        children: <Widget>[
          Expanded(
            // for Alignment
            child: new IconButton(
              icon: Icon(Icons.remove_circle),
              color: Colors.red,
              onPressed: () {
                final item = items[index];
                if (item is isActivateItem) {
                  item.isactivate = false;
                }
                Activateinfo[menuName] = false;

                int ct = countactivate();

                items = List<ListItem>.generate(
                    9,
                    (i) => ((i % (ct + 1)) == 0 &&
                            ((i ~/ (ct + 1)) == 0 || (i ~/ (ct + 1)) == 1))
                        ? (i == 0 ? HeadingItem("활성화") : HeadingItem("비활성화"))
                        : ((i ~/ (ct + 1)) == 0
                            ? isActivateItem(activate[i - 1], true)
                            : isActivateItem(deactivate[i - ct - 2], false)));

                //reload
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WeeklyStatisticsEdit(items: items)));
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
          BoxDecoration(
              border: Border.all(color: SecondColor, width: 0.1),
              color:PrimaryColor.withOpacity(0.1)
          ),
      height: 50,
    );
  }

  Widget makeDeactivationContainer(String menuName, int index) {
    return new Container(
      key: Key('$index'),
      // border를 추가하기 위해 Row를 Container로 감쌈
      child: Row(children: <Widget>[
        Expanded(
          // for Alignment
          child: new IconButton(
            icon: Icon(Icons.add_circle),
            color: Colors.green,
            onPressed: () {
              final item = items[index];
              if (item is isActivateItem) {
                item.isactivate = true;
              }
              Activateinfo[menuName] = true;

              int ct = countactivate();

              items = List<ListItem>.generate(
                  9,
                  (i) => ((i % (ct + 1)) == 0 &&
                          ((i ~/ (ct + 1)) == 0 || (i ~/ (ct + 1)) == 1))
                      ? (i == 0 ? HeadingItem("활성화") : HeadingItem("비활성화"))
                      : ((i ~/ (ct + 1)) == 0
                          ? isActivateItem(activate[i - 1], true)
                          : isActivateItem(deactivate[i - ct - 2], false)));

              //reload
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WeeklyStatisticsEdit(items: items)));
            },
          ),
        ),
        Expanded(
          flex: 5, // for Alignment
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
          BoxDecoration(
              border: Border.all(color: SecondColor, width: 0.1),
              color:PrimaryColor.withOpacity(0.1)
          ),
      height: 50,
    );
  }
}
