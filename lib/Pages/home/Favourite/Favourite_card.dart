import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../items/switch.dart';

class Myfavourite extends StatelessWidget {
  const Myfavourite({super.key});

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
                  'FAVOURITE',
                  style: TextStyle(
                      color: Color(0xffF5B553),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal),
                ),
                Text(
                  '5 DEVICE',
                  style: TextStyle(
                      color: Color(0xffF5B553),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal),
                ),
              ],
            ),
          ),
          Container(
            width: 320,
            height: 120,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  SizedBox(
                    width: 20,
                  ),
                  FavouriteCardSubscribe(
                      category: 'SECURITY',
                      name: 'DOOR',
                      icon: 'assets/Icons/smart-door.png',
                      textStatus: 'LOCK',
                      topics: ['Security : Door'],
                      result: 'Door Status'),
                  SizedBox(
                    width: 15,
                  ),
                  FavouriteCardPublish(
                      category: 'LIVING ROOM',
                      name: 'LIGHT',
                      icon: 'assets/Icons/lamp.png',
                      textStatus: 'TURN',
                      topics: ['Living Room : Light'],
                      result: 'Light Status'),
                  SizedBox(
                    width: 15,
                  ),
                  FavouriteCardSubscribe(
                      category: 'GAMES ROOM',
                      name: 'POWER',
                      icon: 'assets/Icons/power-off.png',
                      textStatus: 'TURN',
                      topics: ['Games Room : Power'],
                      result: 'Power Status'),
                  SizedBox(
                    width: 15,
                  ),
                  FavouriteCardSubscribe(
                      category: 'SECURITY',
                      name: 'DOOR',
                      icon: 'assets/Icons/smart-door.png',
                      textStatus: 'LOCK',
                      topics: ['Security : Door'],
                      result: 'Door Status'),
                  SizedBox(
                    width: 15,
                  ),
                  FavouriteCardPublish(
                      category: 'LIVING ROOM',
                      name: 'LIGHT',
                      icon: 'assets/Icons/lamp.png',
                      textStatus: 'TURN',
                      topics: ['Living Room : Light'],
                      result: 'Light Status'),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FavouriteCardPublish extends StatelessWidget {
  final String category;
  final String name;
  final String icon;
  final String textStatus;
  final List<String> topics;
  final String result;

  const FavouriteCardPublish({
    super.key,
    required this.category,
    required this.name,
    required this.icon,
    required this.textStatus,
    required this.topics,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 85,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 27, 27, 27),
            boxShadow: [
              BoxShadow(
                color: Color(0xff000000),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ]),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            category,
            style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
          Text(
            name,
            style: TextStyle(
                color: Color(0xffF5B553),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal),
          ),
          SizedBox(
            height: 5,
          ),
          Image.asset(
            icon,
            width: 30,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                textStatus,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal),
              ),
              SizedBox(
                width: 10,
              ),
              MyswitchPublish(topics: topics, result: result)
            ],
          )
        ],
      ),
    ]);
  }
}

class FavouriteCardSubscribe extends StatelessWidget {
  final String category;
  final String name;
  final String icon;
  final String textStatus;
  final List<String> topics;
  final String result;

  const FavouriteCardSubscribe({
    super.key,
    required this.category,
    required this.name,
    required this.icon,
    required this.textStatus,
    required this.topics,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 85,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 27, 27, 27),
            boxShadow: [
              BoxShadow(
                color: Color(0xff000000),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ]),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            category,
            style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
          Text(
            name,
            style: TextStyle(
                color: Color(0xffF5B553),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal),
          ),
          SizedBox(
            height: 5,
          ),
          Image.asset(
            icon,
            width: 30,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                textStatus,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal),
              ),
              SizedBox(
                width: 10,
              ),
              MyswitchSubscribe(topics: topics, result: result)
            ],
          )
        ],
      ),
    ]);
  }
}
