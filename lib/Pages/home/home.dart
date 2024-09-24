import 'package:flutter/material.dart';
import 'Meter/Meter.dart';
import 'Alert/Alert_card.dart';
import 'Favourite/Favourite_card.dart';
import 'Location/Location.dart';
import 'Title/Title.dart';
import 'Weather/Weather.dart';

class Myhome extends StatelessWidget {
  const Myhome({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Column(
          children: [
            // Title
            Mytitle(),

            SizedBox(
              height: 10,
            ),

            //Weather
            Myweather(),

            SizedBox(
              height: 10,
            ),

            //Location
            MyLocation(),

            SizedBox(
              height: 10,
            ),

            //Fabourite
            Myfavourite(),

            //Alert
            MyAlert(),

            SizedBox(
              height: 10,
            ),

            //Meter
            Mymeter(),

            SizedBox(
              height: 100,
            ),
          ],
        ),
      ],
    );
  }
}
