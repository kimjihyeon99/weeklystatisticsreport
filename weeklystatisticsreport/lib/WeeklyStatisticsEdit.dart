import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'statisticview.dart';
import 'package:shared_preferences/shared_preferences.dart';

const headingColor = const Color(0xff022E57);
const PrimaryColor = const Color(0xff3C5186);
const SecondColor = Color(0xFFC6B4CE);

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

//head를 넘어가서 위치 바꾸기 방지를 위한 것
int baseindex = 0;

class WeeklyStatisticsEditPage extends StatefulWidget {
  final List<ListItem> items;

  WeeklyStatisticsEditPage({@required this.items});

  @override
  _WeeklyStatisticsEditPage createState() =>
      new _WeeklyStatisticsEditPage(items: items);
}

class _WeeklyStatisticsEditPage extends State<WeeklyStatisticsEditPage>
    with WidgetsBindingObserver {
  List<ListItem> items;

  _WeeklyStatisticsEditPage({@required this.items});

  //업데이트를 위한 activate 개수를 세기 위한것
  int countactivate() {
    int count = 0;
    activate = [];
    deactivate = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
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

  _saveInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('activate', activate?.cast<String>());
      prefs.setStringList('deactivate', deactivate?.cast<String>());

      prefs.setBool('isactivate1', Activateinfo['안전 점수']);
      prefs.setBool('isactivate2', Activateinfo['경제 점수']);
      prefs.setBool('isactivate3', Activateinfo['운전스타일 경고 횟수']);
      prefs.setBool('isactivate4', Activateinfo['일일 연비']);
      prefs.setBool('isactivate5', Activateinfo['주행 거리']);
      prefs.setBool('isactivate6', Activateinfo['지출 내역']);
      prefs.setBool('isactivate7', Activateinfo['점검 필요 항목']);
    });
  }

  @override
  void initState() {
    //앱 상태 변경 이벤트 등록
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    //앱 상태 변경 이벤트 해제
    //문제는 앱 종료시 dispose함수가 호출되지 않아 해당 함수를 실행 할 수가 없다.
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //백그라운드 상태에서 종료해도 데이터 저장하기
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _saveInfo();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    void _BottomSheet(context) {
      showModalBottomSheet(
          isDismissible: false,
          enableDrag: false,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (builder) {
            return new Container(
                height: 60,
                margin: EdgeInsets.all(20),
                decoration: new BoxDecoration(
                    color: SecondColor.withOpacity(0.5),
                    borderRadius: new BorderRadius.all(
                      const Radius.circular(15.0),
                    )),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "화면 배치가 초기화 되었습니다.",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ));
          });
    }

    void _BottomalertSheet(context) {
      showModalBottomSheet(
          isDismissible: false,
          enableDrag: false,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (builder) {
            return new Container(
                height: 60,
                margin: EdgeInsets.all(20),
                decoration: new BoxDecoration(
                    color: SecondColor.withOpacity(0.5),
                    borderRadius: new BorderRadius.all(
                      const Radius.circular(15.0),
                    )),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "최소 한개의 메뉴는 있어야 합니다.",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ));
          });
    }

    Widget makeAppbarContainer(String menuName, int index) {
      return IgnorePointer(
        key: Key('$index'),
        ignoring: true,
        child: Container(
          alignment: Alignment.centerLeft,
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 10),
          child: Text(
            menuName,
            style: new TextStyle(
              fontSize: 25.0,
              color: Colors.white,
            ),
          ),
          decoration: BoxDecoration(
            color: headingColor,
          ),
          width: double.infinity,
          height: AppBar().preferredSize.height,
        ),
      );
    }

    Widget makeActivationContainer(String menuName, int index) {
      return Container(
        key: Key('$index'),
        child: ListTile(
            dense: true,
            // border를 추가하기 위해 Row를 Container로 감쌈
            leading: IconButton(
              icon: Icon(Icons.remove_circle),
              color: Color(0xFFff7473),
              onPressed: () {
                int activatecnt = 0;

                for (int i = 0; i < items.length; i++) {
                  final myitem = items[i];
                  if (myitem is isActivateItem) {
                    if (myitem.isactivate == true) {
                      activatecnt = activatecnt + 1;
                    }
                  }
                }

                if (activatecnt == 1) {
                  //최소 한개는 아이템이 있어야한다는 알림 문구
                  _BottomalertSheet(context);
                  Future.delayed(const Duration(seconds: 1), () {
                    // deleayed code here
                    Navigator.pop(context);
                  });
                } else {
                  final item = items[index];

                  if (item is isActivateItem) {
                    item.isactivate = false;
                  }
                  Activateinfo[menuName] = false;

                  int ct = countactivate();

                  setState(() {
                    items = List<ListItem>.generate(
                        9,
                        (i) => ((i % (ct + 1)) == 0 &&
                                ((i ~/ (ct + 1)) == 0 || (i ~/ (ct + 1)) == 1))
                            ? (i == 0
                                ? HeadingItem("활성화")
                                : HeadingItem("비활성화"))
                            : ((i ~/ (ct + 1)) == 0
                                ? isActivateItem(activate[i - 1], true)
                                : isActivateItem(
                                    deactivate[i - ct - 2], false)));
                  });
                }
              },
            ),
            title: Text(
              menuName,
              style: new TextStyle(
                fontSize: 25.0,
                color: Colors.white,
              ),
            ),
            trailing: ReorderableDragStartListener(
              index: index,
              child: Icon(
                Icons.reorder,
                color: Colors.white,
                size: 24.0,
              ),
            )),
        decoration: BoxDecoration(
            border: Border.all(color: headingColor, width: 0.1),
        ),
        height: 50,
      );
    }

    Widget makeDeactivationContainer(String menuName, int index) {
      return new Container(
        key: Key('$index'),
        // border를 추가하기 위해 Row를 Container로 감쌈
        child: ListTile(
          dense: true,
          leading: new IconButton(
            icon: Icon(Icons.add_circle),
            color: Color(0xFF8FBC94),
            onPressed: () {
              final item = items[index];
              if (item is isActivateItem) {
                item.isactivate = true;
              }
              Activateinfo[menuName] = true;

              int ct = countactivate();

              setState(() {
                items = List<ListItem>.generate(
                    9,
                    (i) => ((i % (ct + 1)) == 0 &&
                            ((i ~/ (ct + 1)) == 0 || (i ~/ (ct + 1)) == 1))
                        ? (i == 0 ? HeadingItem("활성화") : HeadingItem("비활성화"))
                        : ((i ~/ (ct + 1)) == 0
                            ? isActivateItem(activate[i - 1], true)
                            : isActivateItem(deactivate[i - ct - 2], false)));
              });
            },
          ),
          title: new Text(
            menuName,
            style: new TextStyle(
              fontSize: 25.0,
              color: new Color(0xffE0E0E0),
            ),
          ),
          trailing: ReorderableDragStartListener(
              index: index,
              child: Icon(
                Icons.reorder,
                color: Colors.white.withOpacity(0.5),
                size: 24.0,
              )),
        ),
        decoration: BoxDecoration(
            border: Border.all(color: headingColor, width: 0.1),
            ),
        height: 50,
      );
    }

    return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          title: new Text(
            '주간 통계 화면 편집',
            style: new TextStyle(fontSize: 25.0, color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              _saveInfo();
              Navigator.pop(context, items);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                // 초기화 동작
                activate = [
                  "안전 점수",
                  "경제 점수",
                  "운전스타일 경고 횟수",
                  "일일 연비",
                  "주행 거리",
                  "지출 내역",
                  "점검 필요 항목"
                ];
                deactivate = [];

                Activateinfo = {
                  "안전 점수": true,
                  "경제 점수": true,
                  "운전스타일 경고 횟수": true,
                  "일일 연비": true,
                  "주행 거리": true,
                  "지출 내역": true,
                  "점검 필요 항목": true
                };
                setState(() {
                  items = List<ListItem>.generate(
                      9,
                      (i) => (i == 8
                          ? HeadingItem("비활성화")
                          : (i == 0)
                              ? HeadingItem("활성화")
                              : isActivateItem(activate[i - 1], true)));
                });

                _BottomSheet(context);

                Future.delayed(const Duration(seconds: 1), () {
                  // deleayed code here
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
        body: WillPopScope(
          //물리적 뒤로가기 처리
          onWillPop: () {
            _saveInfo();
            Navigator.pop(context, items);
            return Future.value(true);
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [PrimaryColor, SecondColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: new ReorderableListView.builder(
              buildDefaultDragHandles: false,
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
                      if (newIndex != 0) {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final ListItem item = items.removeAt(oldIndex);
                        items.insert(newIndex, item);

                        //deactive 영역으로 넘어가는 경우 아이콘 바꾸기

                        if ((baseindex - 1) == 1) {
                          //최소 한개는 남겨두어야함
                          _BottomalertSheet(context);
                          Future.delayed(const Duration(seconds: 1), () {
                            // deleayed code here
                            Navigator.pop(context);
                          });
                        } else if (baseindex - 1 < newIndex) {
                          //icon 바꾸기
                          temp.isactivate = false;
                          Activateinfo[temp.Activatename] = false;
                        }
                      }
                    } else {
                      //비활성화
                      if (newIndex != 0) {
                        // 조건 지우기
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final ListItem item = items.removeAt(oldIndex);
                        items.insert(newIndex, item);

                        //active 영역으로 넘어가는 경우 아이콘 바꾸기
                        if (baseindex + 1 > newIndex) {
                          temp.isactivate = true;
                          Activateinfo[temp.Activatename] = true;
                        }
                      }
                    }

                    int ct = countactivate();

                    items = List<ListItem>.generate(
                        9,
                        (i) => ((i % (ct + 1)) == 0 &&
                                ((i ~/ (ct + 1)) == 0 || (i ~/ (ct + 1)) == 1))
                            ? (i == 0
                                ? HeadingItem("활성화")
                                : HeadingItem("비활성화"))
                            : ((i ~/ (ct + 1)) == 0
                                ? isActivateItem(activate[i - 1], true)
                                : isActivateItem(
                                    deactivate[i - ct - 2], false)));
                  }
                });
              },
            ),
          ),
        ));
  }
}
