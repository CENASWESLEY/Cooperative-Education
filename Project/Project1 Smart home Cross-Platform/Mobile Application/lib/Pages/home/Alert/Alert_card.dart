import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../items/progress.dart';

class MyAlert extends StatelessWidget {
  const MyAlert({super.key});

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
                  'ALERT',
                  style: TextStyle(
                      color: Color(0xffF5B553),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal),
                ),
                Text(
                  '3 DEVICE',
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
            width: 320,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyAlertCard(
                  category: 'SENSOR',
                  name: 'ULTRASONIC',
                  topics: ['Sensor : Ultrasonic'],
                ),
                MyAlertCard(
                  category: 'SENSOR',
                  name: 'WATER LEVEL',
                  topics: ['Sensor : Water Level'],
                ),
                MyAlertCard(
                  category: 'SENSOR',
                  name: 'PUMP',
                  topics: ['Sensor : Pump'],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyAlertCard extends StatelessWidget {
  final String category;
  final String name;
  final List<String> topics;

  const MyAlertCard({
    super.key,
    required this.category,
    required this.name,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 85,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xff191919),
            boxShadow: [
              BoxShadow(
                color: Color(0xff000000),
                blurRadius: 10,
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
          MypregressDigital(
              topics: topics), //topic จาก Mypregress จะรับขอมูลจาก topics
        ],
      ),
    ]);
  }
}
