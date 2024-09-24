import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mqtt_app/Pages/Room/ChangeRoom.dart';
import 'package:mqtt_app/Pages/Room/Room.dart';
import 'package:mqtt_app/Pages/superpages.dart';
import 'package:provider/provider.dart';

class MyLocation extends StatelessWidget {
  const MyLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LOCATION',
                  style: TextStyle(
                      color: Color(0xffF5B553),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal),
                ),
                Text(
                  'MY HOME',
                  style: TextStyle(
                      color: Color(0xffF5B553),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 330,
            height: 200, // Fixed height for visible rows
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/Home.png',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          LocationCard(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var rooms = context.watch<RoomModel>().rooms;
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        for (int i = 0;
            i < rooms.length;
            i += 6) // 6 widgets per column (2 rows x 3 widgets)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int j = i; j < i + 6 && j < rooms.length; j += 3)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    for (int k = j; k < j + 3 && k < rooms.length; k++)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Mysuperpages()),
                            );
                          },
                          child: LocationRoom(
                            icon: rooms[k].icon,
                            name: rooms[k].name,
                            device: rooms[k].devices.toString(),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}

class LocationRoom extends StatelessWidget {
  final String icon;
  final String name;
  final String device;

  const LocationRoom({
    super.key,
    required this.icon,
    required this.name,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider getImageProvider(String path) {
      if (path.startsWith('assets/')) {
        return AssetImage(path);
      } else {
        return FileImage(File(path));
      }
    }

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 70,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff1B1B1B).withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Image(
                      image: getImageProvider(icon),
                      fit: BoxFit.cover,
                      width: 70,
                      height: 80,
                    ),
                    Container(
                      width: 70,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xff191919).withOpacity(1),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 5,
              right: 5,
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 5,
              right: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Color(0xff00FF85),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff00FF85),
                          blurRadius: 4,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '$device Devices',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 7,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
