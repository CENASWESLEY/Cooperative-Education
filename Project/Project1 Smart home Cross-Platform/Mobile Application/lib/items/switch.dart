import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:mqtt_app/Pico/data_service.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../Pico/mqtt_service.dart';

class MyswitchPublish extends StatefulWidget {
  final List<String> topics;
  final String result;

  const MyswitchPublish(
      {super.key, required this.topics, required this.result});

  @override
  State<MyswitchPublish> createState() => _MyswitchPublishState();
}

class _MyswitchPublishState extends State<MyswitchPublish> {
  bool switchValue = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 25,
          height: 15,
          child: FittedBox(
            fit: BoxFit.fill,
            child: ChangeNotifierProvider.value(
              value: dataService,
              child: Consumer<DataService>(
                builder:
                    (BuildContext context, DataService data, Widget? child) {
                  bool combinedValue = widget.topics.any((topic) =>
                      data.mqttData[topic].toString().toLowerCase() == 'true');
                  return Switch(
                    activeColor: Color(0xff282424),
                    activeTrackColor: Color(0xffF5B553),
                    inactiveThumbColor: Color(0xffF5B553),
                    inactiveTrackColor: Colors.black,
                    value: combinedValue,
                    onChanged: (newValue) {
                      setState(() {
                        switchValue = newValue;
                        widget.topics.forEach((topic) {
                          if (mqttClientWrapper.isConnected) {
                            mqttClientWrapper.publishMessage(
                                topic, newValue ? 'true' : 'false');
                          } else {
                            log('Cannot publish message, client is not connected');
                          }
                        });
                        log('${widget.result} : $newValue');
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyswitchSubscribe extends StatefulWidget {
  final List<String> topics;
  final String result;

  const MyswitchSubscribe(
      {super.key, required this.topics, required this.result});

  @override
  State<MyswitchSubscribe> createState() => _MyswitchSubscribeState();
}

class _MyswitchSubscribeState extends State<MyswitchSubscribe> {
  bool switchValue = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 25,
          height: 15,
          child: FittedBox(
            fit: BoxFit.fill,
            child: ChangeNotifierProvider.value(
              value: dataService,
              child: Consumer<DataService>(
                builder:
                    (BuildContext context, DataService data, Widget? child) {
                  bool combinedValue = widget.topics.any((topic) =>
                      data.mqttData[topic].toString().toLowerCase() == 'true');
                  return Switch(
                    activeColor: Color(0xff282424),
                    activeTrackColor: Color(0xffF5B553),
                    inactiveThumbColor: Color(0xffF5B553),
                    inactiveTrackColor: Colors.black,
                    value: combinedValue,
                    onChanged: (newValue) {
                      setState(() {
                        switchValue = newValue;
                        log('${widget.result} : $newValue');
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
