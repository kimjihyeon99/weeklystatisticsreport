import 'package:flutter/material.dart';
import 'statisticview.dart';

const PrimaryColor = const Color(0xff2980b9);
const SecondColor = const Color(0xff2B5490);

abstract class ListItem {}

class HeadingItem implements ListItem {
  final String isActivate;

  HeadingItem(this.isActivate);
}

class isActivateItem implements ListItem {
  final String Activatename;
  final bool isactivate;

  isActivateItem(this.Activatename, this.isactivate);
}

class WeeklyStatisticsEdit extends StatelessWidget {
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
  final List<ListItem> items;

  _WeeklyStatisticsEditPage({@required this.items});

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < items.length; i++) {
      var item = items[i];

      if (item is HeadingItem) {
        print(item.isActivate);
      }
      else if (item is isActivateItem) {
        print(item.Activatename);

      }
    }

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
        body: new ReorderableListView.builder(
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
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final ListItem item = items.removeAt(oldIndex);
              items.insert(newIndex, item);
            });
          },
        ));
  }

  Widget makeAppbarContainer(String menuName,int index) {
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
                Activateinfo[menuName] = false;

                int ct = countactivate();
                //reload
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WeeklyStatisticsEdit(
                            items: List<ListItem>.generate(
                                9,
                                (i) => ((i % (ct + 1)) == 0 &&
                                        ((i ~/ (ct + 1)) == 0 ||
                                            (i ~/ (ct + 1)) == 1))
                                    ? (i == 0
                                        ? HeadingItem("활성화")
                                        : HeadingItem("비활성화"))
                                    : ((i ~/ (ct + 1)) == 0
                                        ? isActivateItem(activate[i - 1], true)
                                        : isActivateItem(
                                            deactivate[i - ct - 2], false))))));
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
              Activateinfo[menuName] = true;

              int ct = countactivate();
              //reload
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WeeklyStatisticsEdit(
                          items: List<ListItem>.generate(
                              9,
                              (i) => ((i % (ct + 1)) == 0 &&
                                      ((i ~/ (ct + 1)) == 0 ||
                                          (i ~/ (ct + 1)) == 1))
                                  ? (i == 0
                                      ? HeadingItem("활성화")
                                      : HeadingItem("비활성화"))
                                  : ((i ~/ (ct + 1)) == 0
                                      ? isActivateItem(activate[i - 1], true)
                                      : isActivateItem(
                                          deactivate[i - ct - 2], false))))));
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
          BoxDecoration(border: Border.all(color: SecondColor, width: 1.2)),
      height: 50,
    );
  }
}
