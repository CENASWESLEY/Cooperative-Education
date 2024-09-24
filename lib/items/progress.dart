import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../Pico/data_service.dart';
import '../main.dart';

class MypregressDigital extends StatefulWidget {
  final List<String> topics;

  const MypregressDigital({super.key, required this.topics});

  @override
  State<MypregressDigital> createState() => _MypregressDigitalState();
}

class _MypregressDigitalState extends State<MypregressDigital> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: dataService,
      child: Consumer<DataService>(
        builder: (BuildContext context, DataService data, Widget? child) {
          var val = 0.0;
          var displayVal = "00";
          try {
            val = double.tryParse(data.mqttData[widget.topics.first]) ?? 0.0;
            val /= 65535;
            displayVal = (val * 100).round().toString().padLeft(2, '0');
          } catch (e) {
            // Handle error if necessary
          }
          return CircularPercentIndicator(
            radius: 25,
            lineWidth: 5,
            animation: true,
            percent: val.clamp(0.0, 1.0),
            center: Text(
              "$displayVal%",
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 10,
                color: Colors.white,
              ),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: const Color.fromARGB(255, 255, 255, 255),
            backgroundColor: Colors.black,
          );
        },
      ),
    );
  }
}
