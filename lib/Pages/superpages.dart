import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mqtt_app/Pages/Profile/Profile.dart';
import 'package:mqtt_app/Pages/Room/Room.dart';
import 'package:mqtt_app/Pages/home/home.dart';

class Mysuperpages extends StatefulWidget {
  const Mysuperpages({super.key});

  @override
  State<Mysuperpages> createState() => _MysuperpagesState();
}

class _MysuperpagesState extends State<Mysuperpages> {
  int mycurrentindex = 0;
  List pages = [
    Myhome(),
    MyRoom(),
    MyProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(child: pages[mycurrentindex]),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 375,
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                      offset: Offset(0, 10),
                      blurRadius: 20,
                    )
                  ],
                  gradient: LinearGradient(
                    colors: [Color(0xff854836), Color(0xffF5B553)],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Iconsax.home),
                        label: 'คอร์สเรียน',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Iconsax.grid_24),
                        label: 'คอร์สเรียน',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Iconsax.user),
                        label: 'คอร์สเรียน',
                      ),
                    ],
                    backgroundColor: Colors.transparent,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.black,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    elevation: 0,
                    onTap: (index) {
                      setState(() {
                        mycurrentindex = index;
                      });
                    },
                    currentIndex: mycurrentindex,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xff191919),
    );
  }
}
