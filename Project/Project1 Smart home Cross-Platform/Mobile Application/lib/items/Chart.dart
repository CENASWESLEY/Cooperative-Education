import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_app/main.dart';
import 'package:provider/provider.dart';
import 'package:mqtt_app/Pico/data_service.dart';

class Mychart_Meter extends StatefulWidget {
  const Mychart_Meter({super.key});

  @override
  State<Mychart_Meter> createState() => _Mychart_MeterState();
}

class _Mychart_MeterState extends State<Mychart_Meter> {
  List<FlSpot> _getSpots(DataService data) {
    // Example data extraction from DataService
    final meterValues = [
      'Meter_Value_1',
      'Meter_Value_2',
      'Meter_Value_3',
      'Meter_Value_4',
      'Meter_Value_6',
      'Meter_Value_7'
    ];

    List<FlSpot> spots = [];
    for (int i = 0; i < meterValues.length; i++) {
      final value = data.mqttData['External : ${meterValues[i]}'];
      final yValue = (value != null && double.tryParse(value) != null)
          ? double.parse(value)
          : 0.0;
      spots.add(FlSpot(i.toDouble(), yValue));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: dataService,
      child: Consumer<DataService>(
        builder: (BuildContext context, DataService data, Widget? child) {
          return Container(
            height: 300,
            width: 350,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xff000000),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
              color: Color(0xff191919).withOpacity(1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Meter', // Title of the chart
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10), // Space between title and chart
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: 5,
                        minY: 0,
                        maxY: 500,
                        backgroundColor: Colors.transparent,
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 20,
                              getTitlesWidget: (value, meta) {
                                const Labels = [
                                  'V',
                                  'A',
                                  'W',
                                  'VAR',
                                  'PF',
                                  'HZ',
                                ];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    Labels[value.toInt()],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: Color(0xffF5B553),
                            barWidth: 2,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xffF5B553).withOpacity(0.5),
                                  Color(0xff854836).withOpacity(0.0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            spots: _getSpots(data),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
