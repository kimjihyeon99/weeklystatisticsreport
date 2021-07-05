import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'statisticview.dart';

const PrimaryColor = const Color(0xff2980b9);
const SecondColor = const Color(0xff2B5490);

List activeOrder = new List();
List deActiveOrder =new List();

class WeeklyStatisticsEdit extends StatelessWidget {
  final List<DraggableList> items;

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
  final List<DraggableList> items;

  WeeklyStatisticsEditPage({Key key, @required this.items}) : super(key: key);

  @override
  _WeeklyStatisticsEditPage createState() =>
      new _WeeklyStatisticsEditPage(items: items);
}

class _WeeklyStatisticsEditPage extends State<WeeklyStatisticsEditPage> {
  List<DraggableList> items;
  List<DragAndDropList> lists;

  _WeeklyStatisticsEditPage({@required this.items});


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lists = items.map(buildList).toList();
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
            print(lists);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => statisticview()));
          },
        ),
      ),
      body: DragAndDropLists(
        listPadding: EdgeInsets.all(16),
        listInnerDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(10),
        ),
        children: lists,
        itemDivider: Divider(thickness: 2, height: 2, color: SecondColor),
        itemDecorationWhileDragging: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        listDragHandle: buildDragHandle(isList: true),
        itemDragHandle: buildDragHandle(),
        onItemReorder: onReorderListItem,
        onListReorder: onReorderList,
      ),
    );
  }

  DragHandle buildDragHandle({bool isList = false}) {
    final verticalAlignment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;
    final color = isList ? Colors.blueGrey : Colors.black26;
    return DragHandle(
      verticalAlignment: verticalAlignment,
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: Icon(Icons.menu, color: color),
      ),
    );
  }

  void onReorderListItem(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      final oldListItems = lists[oldListIndex].children;
      final newListItems = lists[newListIndex].children;
      final movedItem = oldListItems.removeAt(oldItemIndex);
      newListItems.insert(newItemIndex, movedItem);
    });
  }

  void onReorderList(
    int oldListIndex,
    int newListIndex,
  ) {
    setState(() {
      final movedList = lists.removeAt(oldListIndex);
      lists.insert(newListIndex, movedList);

    });
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

  DragAndDropList buildList(DraggableList list) => DragAndDropList(
        header: makeAppbarContainer(list.header),
        canDrag: false,
        children: list.items
            .map((item) => DragAndDropItem(
                  child: ListTile(
                    leading: new IconButton(icon: item.icons, onPressed: () {
                      Activateinfo[item.Activatename][1]  = !item.isactivate;

                      List<DraggableList> allLists = [
                        DraggableList(
                          header: '활성화',
                          items: [
                          ],
                        ),
                        DraggableList(
                          header: '비활성화',
                          items: [
                          ],
                        ),
                      ];


                      for(int i=0;i<Activateinfo.length;i++){
                        if(Activateinfo[activateName[i]][1] ==true){

                          allLists[0].items.add(DraggableListItem(
                            Activatename: activateName[i],
                            isactivate: true,
                            icons: Icon(Icons.remove_circle,color: Colors.red),
                          ));
                        }else{
                          allLists[1].items.add(DraggableListItem(
                            Activatename: activateName[i],
                            isactivate: false,
                            icons: Icon(Icons.add_circle,color: Colors.green),
                          ));

                        }
                      }

                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WeeklyStatisticsEdit(items: allLists,
                                      )));
                    }),
                    title: Text(item.Activatename),
                  ),
                ))
            .toList(),
      );
}
