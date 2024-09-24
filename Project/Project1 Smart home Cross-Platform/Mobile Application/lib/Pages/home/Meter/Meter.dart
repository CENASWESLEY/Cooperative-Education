import 'package:flutter/material.dart';
import 'package:mqtt_app/Pico/data_service.dart';
import 'package:mqtt_app/main.dart';
import 'package:provider/provider.dart';

class Mymeter extends StatelessWidget {
  const Mymeter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EXTERNAL',
                style: TextStyle(
                    color: Color(0xffF5B553),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),
              ),
              Text(
                '1 DEVICE',
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
          width: 300,
          height: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff191919),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff000000),
                  blurRadius: 10,
                ),
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'SENSOR',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal),
                    ),
                    Text(
                      'METER',
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
                      'assets/Icons/electric-meter.png',
                      width: 35,
                    ),
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Meter_volt(),
                          SizedBox(
                            width: 5,
                          ),
                          Meter_current(),
                          SizedBox(
                            width: 5,
                          ),
                          Meter_activepower(),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Meter_reactivepower(),
                          SizedBox(
                            width: 5,
                          ),
                          Meter_pf(),
                          SizedBox(
                            width: 5,
                          ),
                          Meter_frequency(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Meter_volt extends StatefulWidget {
  const Meter_volt({super.key});

  @override
  State<Meter_volt> createState() => _Meter_voltState();
}

class _Meter_voltState extends State<Meter_volt> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 70,
        height: 40,
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
        children: [
          Text(
            'VOLTAGE',
            style: TextStyle(
                color: Color(0xffF5B553),
                fontSize: 7,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
          SizedBox(
            height: 0,
          ),
          ChangeNotifierProvider.value(
            value: dataService,
            child: Consumer<DataService>(
              builder: (BuildContext context, DataService data, Widget? child) {
                final value = data.mqttData['External : Meter_Value_1'];
                final formattedValue =
                    (value != null && double.tryParse(value) != null)
                        ? double.parse(value).toStringAsFixed(2)
                        : 'N/A';

                return Text(
                  formattedValue,
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
          SizedBox(
            height: 0,
          ),
          Text(
            'V',
            style: TextStyle(
                color: Color(0xffF5B553),
                fontSize: 7,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
        ],
      ),
    ]);
  }
}

class Meter_current extends StatefulWidget {
  const Meter_current({super.key});

  @override
  State<Meter_current> createState() => _Meter_currentState();
}

class _Meter_currentState extends State<Meter_current> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 70,
        height: 40,
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
        children: [
          Text(
            'CURRENT',
            style: TextStyle(
                color: Color(0xffF5B553),
                fontSize: 7,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
          SizedBox(
            height: 0,
          ),
          ChangeNotifierProvider.value(
            value: dataService,
            child: Consumer<DataService>(
              builder: (BuildContext context, DataService data, Widget? child) {
                final value = data.mqttData['External : Meter_Value_2'];
                final formattedValue =
                    (value != null && double.tryParse(value) != null)
                        ? double.parse(value).toStringAsFixed(2)
                        : 'N/A';

                return Text(
                  formattedValue,
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
          SizedBox(
            height: 0,
          ),
          Text(
            'A',
            style: TextStyle(
                color: Color(0xffF5B553),
                fontSize: 7,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
        ],
      ),
    ]);
  }
}

class Meter_activepower extends StatefulWidget {
  const Meter_activepower({super.key});

  @override
  State<Meter_activepower> createState() => _Meter_activepowerState();
}

class _Meter_activepowerState extends State<Meter_activepower> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 70,
        height: 40,
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
        children: [
          Text(
            'ACTIVE POWER',
            style: TextStyle(
                color: Color(0xffF5B553),
                fontSize: 7,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
          SizedBox(
            height: 0,
          ),
          ChangeNotifierProvider.value(
            value: dataService,
            child: Consumer<DataService>(
              builder: (BuildContext context, DataService data, Widget? child) {
                final value = data.mqttData['External : Meter_Value_3'];
                final formattedValue =
                    (value != null && double.tryParse(value) != null)
                        ? double.parse(value).toStringAsFixed(2)
                        : 'N/A';

                return Text(
                  formattedValue,
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
          SizedBox(
            height: 0,
          ),
          Text(
            'W',
            style: TextStyle(
                color: Color(0xffF5B553),
                fontSize: 7,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
        ],
      ),
    ]);
  }
}

class Meter_reactivepower extends StatefulWidget {
  const Meter_reactivepower({super.key});

  @override
  State<Meter_reactivepower> createState() => _Meter_reactivepowerState();
}

class _Meter_reactivepowerState extends State<Meter_reactivepower> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 70,
        height: 40,
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
        children: [
          Text(
            'REACTIVE POWER',
            style: TextStyle(
                color: Color(0xffF5B553),
                fontSize: 7,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
          SizedBox(
            height: 0,
          ),
          ChangeNotifierProvider.value(
            value: dataService,
            child: Consumer<DataService>(
              builder: (BuildContext context, DataService data, Widget? child) {
                final value = data.mqttData['External : Meter_Value_4'];
                final formattedValue =
                    (value != null && double.tryParse(value) != null)
                        ? double.parse(value).toStringAsFixed(2)
                        : 'N/A';

                return Text(
                  formattedValue,
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
          SizedBox(
            height: 0,
          ),
          Text(
            'VAR',
            style: TextStyle(
                color: Color(0xffF5B553),
                fontSize: 7,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
        ],
      ),
    ]);
  }
}

class Meter_pf extends StatefulWidget {
  const Meter_pf({super.key});

  @override
  State<Meter_pf> createState() => _Meter_pfState();
}

class _Meter_pfState extends State<Meter_pf> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 70,
        height: 40,
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
        children: [
          Text(
            'POWER FACTOR',
            style: TextStyle(
                color: Color(0xffF5B553),
                fontSize: 7,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
          SizedBox(
            height: 0,
          ),
          ChangeNotifierProvider.value(
            value: dataService,
            child: Consumer<DataService>(
              builder: (BuildContext context, DataService data, Widget? child) {
                final value = data.mqttData['External : Meter_Value_6'];
                final formattedValue =
                    (value != null && double.tryParse(value) != null)
                        ? double.parse(value).toStringAsFixed(2)
                        : 'N/A';

                return Text(
                  formattedValue,
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
          SizedBox(
            height: 0,
          ),
          Text(
            '',
            style: TextStyle(
                color: Color(0xffF5B553),
                fontSize: 7,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
        ],
      ),
    ]);
  }
}

class Meter_frequency extends StatefulWidget {
  const Meter_frequency({super.key});

  @override
  State<Meter_frequency> createState() => _Meter_frequencyState();
}

class _Meter_frequencyState extends State<Meter_frequency> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 70,
        height: 40,
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
        children: [
          Text(
            'FREQUENCY',
            style: TextStyle(
                color: Color(0xffF5B553),
                fontSize: 7,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
          SizedBox(
            height: 0,
          ),
          ChangeNotifierProvider.value(
            value: dataService,
            child: Consumer<DataService>(
              builder: (BuildContext context, DataService data, Widget? child) {
                // Check if the value is not null and is a double
                final value = data.mqttData['External : Meter_Value_7'];
                final formattedValue =
                    (value != null && double.tryParse(value) != null)
                        ? double.parse(value).toStringAsFixed(2)
                        : 'N/A';

                return Text(
                  formattedValue,
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
          SizedBox(
            height: 0,
          ),
          Text(
            'HZ',
            style: TextStyle(
                color: Color(0xffF5B553),
                fontSize: 7,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
        ],
      ),
    ]);
  }
}
