import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Pico/data_service.dart';
import '../../../main.dart';

class Myweather extends StatelessWidget {
  const Myweather({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient:
              LinearGradient(colors: [Color(0xff854836), Color(0xffF5B553)])),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/Icons/clear-sky.png',
                      width: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          'WIND',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                              fontWeight: FontWeight.w500),
                        ),
                        // ใช้ Package Provider โดยมี value เป็น dataService ที่สร้างเอง
                        ChangeNotifierProvider.value(
                          value: dataService,
                          child: Consumer<DataService>(
                            builder: (BuildContext context, DataService data,
                                Widget? child) {
                              return Text(
                                //ถ้าใช้แค่ data จะไม่สามารถเข้าถึงข้อมูลใน Map ได้
                                '${data.mqttData['Weather : Wind']} m/s',
                                style: TextStyle(
                                    shadows: [
                                      Shadow(
                                          color: Colors.black.withOpacity(0.8),
                                          offset: Offset(0, 1),
                                          blurRadius: 3)
                                    ],
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            VerticalDivider(
              width: 30,
              thickness: 1,
              indent: 1,
              endIndent: 1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/Icons/thermometer (1).png',
                      width: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          'TEMPERATURE',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                              fontWeight: FontWeight.w500),
                        ),
                        ChangeNotifierProvider.value(
                          value: dataService,
                          child: Consumer<DataService>(
                            builder: (BuildContext context, DataService data,
                                Widget? child) {
                              return Text(
                                '${data.mqttData['Weather : Temperature']} °C',
                                style: TextStyle(
                                    shadows: [
                                      Shadow(
                                          color: Colors.black.withOpacity(0.8),
                                          offset: Offset(0, 1),
                                          blurRadius: 3)
                                    ],
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            VerticalDivider(
              width: 30,
              thickness: 1,
              indent: 1,
              endIndent: 1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/Icons/thermometer (2).png',
                      width: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          'Humidity',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                              fontWeight: FontWeight.w500),
                        ),
                        ChangeNotifierProvider.value(
                          value: dataService,
                          child: Consumer<DataService>(
                            builder: (BuildContext context, DataService data,
                                Widget? child) {
                              return Text(
                                '${data.mqttData['Weather : Humidity']} %',
                                style: TextStyle(
                                    shadows: [
                                      Shadow(
                                          color: Colors.black.withOpacity(0.8),
                                          offset: Offset(0, 1),
                                          blurRadius: 3)
                                    ],
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
