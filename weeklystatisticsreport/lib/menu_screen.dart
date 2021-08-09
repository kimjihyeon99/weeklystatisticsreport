import 'package:flutter/material.dart';
import 'package:weeklystatisticsreport/mainmenu.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColor,
      body: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  border: Border.all(width: 0, color: PrimaryColor)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image(
                        image: AssetImage("assets/bmw_logo.png"),
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        "BMW i4",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text("홍길동",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                          ))
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                child: Row(
                  children: [
                    Icon(
                      Icons.apps,
                      color: Colors.white60,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '내 차 목록',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Colors.white60),
                    SizedBox(
                      width: 20,
                    ),
                    Text('설정', style: TextStyle(color: Colors.white60)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
