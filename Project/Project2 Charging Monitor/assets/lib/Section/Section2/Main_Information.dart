import 'dart:developer';

import 'package:dashboard_ems/Component/Theme.dart';
import 'package:dashboard_ems/Section/Section6/Charging_UsageChangeNotifier.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

class Main_Information extends StatefulWidget {
  const Main_Information({super.key});

  @override
  State<Main_Information> createState() => _Main_InformationState();
}

class _Main_InformationState extends State<Main_Information>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Map<String, String> stationBackgrounds = {
    'Bang Khen': 'assets/images/background1.jpg',
    'Lat Krabang': 'assets/images/background2.jpg',
    'Phloen Chit': 'assets/images/background3.jpg',
    'Thon Buri': 'assets/images/background4.jpg',
  };
  final Map<String, double> stationAlignmentY = {
    'Bang Khen': 0.1,
    'Lat Krabang': 0.4,
    'Phloen Chit': 0.4,
    'Thon Buri': 0.1,
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // ระยะเวลาหมุน 360 องศา
      vsync: this,
    )..repeat(); // ทำให้หมุนไปเรื่อยๆ ไม่มีหยุด
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StationProvider>(
        builder: (context, stationProvider, child) {
      final energyProvider = Provider.of<EnergyProvider>(context);
      String selectedStation = stationProvider.selectedStation;
      String backgroundImage = stationBackgrounds[selectedStation] ??
          'assets/images/background1.jpg';
      double alignmentY = stationAlignmentY[selectedStation] ?? 0.0;
      return Container(
        width: 800,
        height: 515,
        decoration: BoxDecoration(
          border: GradientBoxBorder(
            gradient: Theme_Colors.general_gradient_maintext,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(50),
          color: Theme_Colors.black,
          boxShadow: [
            BoxShadow(color: const Color.fromARGB(255, 0, 0, 0), blurRadius: 10)
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 800,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                  alignment: Alignment(0, alignmentY),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(48),
                  topRight: Radius.circular(48),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.zero,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(1),
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.4],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/Main logo.png',
                        width: 300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 750,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: Theme_Colors.station_gradient_orange,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return ShaderMask(
                            shaderCallback: (bounds) => Theme_Colors
                                .general_gradient_maintext
                                .createShader(bounds),
                            child: Text(
                              "CHARGING\nSTATION",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                shadows: [
                                  Shadow(
                                    color: Color(0xFFFFEEBB).withOpacity(0.8),
                                    blurRadius: 10,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          );
                        }),
                  ),
                  Container(
                    width: 2,
                    height: 50,
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Theme_Colors.black.withOpacity(0.25),
                          offset: Offset(0, 5))
                    ]),
                  ),
                  Container(
                    width: 530,
                    height: 100,
                    child: StationSelector(),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 0,
            ),
            Container(
              width: 750,
              height: 280,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Element_green(
                        icon: 'assets/icons/element/Co2.png',
                        name: 'CO2\nREDUCTION',
                        value: NumberFormat("#,##0.00")
                            .format(energyProvider.calculateCO2Reduction()),
                        unit: 'KG',
                        ref: '1 liter of gasoline emits 2.31 kg CO2',
                      ),
                      Element_green(
                        icon: 'assets/icons/element/Tree_Planted.png',
                        name: 'EQUIVALENT\nTREE PLANTED',
                        value: NumberFormat("#,##0.00")
                            .format(energyProvider.calculateTreeEquivalent()),
                        unit: 'TREES',
                        ref: '1 tree absorbs 22 kg CO2 annually',
                      ),
                      Element_green(
                        icon: 'assets/icons/element/Fuel_Savings.png',
                        name: 'FUEL\nSAVINGS',
                        value: NumberFormat("#,##0.00")
                            .format(energyProvider.calculateCostSaving()),
                        unit: '฿',
                        ref: 'Gasoline costs 40 THB/liter',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Element_yellow(
                        icon: 'assets/icons/element/Energy_Production.png',
                        name: 'Electrical\nGrid Power',
                        value: NumberFormat("#,##0.00").format(
                            energyProvider.calculateElectricalGridPower()),
                        unit: 'KWH',
                        ref: 'Annual Electrical Grid Power 80%',
                      ),
                      Element_yellow(
                        icon: 'assets/icons/element/Overall_Energy.png',
                        name: 'Renewable\nEnergy',
                        value: NumberFormat("#,##0.00")
                            .format(energyProvider.calculateRenewableEnergy()),
                        unit: 'KWH',
                        ref: 'Annual Renewable Energy 20%',
                      ),
                      Element_yellow(
                        icon: 'assets/icons/element/Energy_Consumption.png',
                        name: 'Monthly Energy\nConsumptionn',
                        value: NumberFormat("#,##0.00")
                            .format(energyProvider.calculateMonthlyEnergy()),
                        unit: 'KWH',
                        ref: 'Estimated Monthly Energy Usage',
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

// TODO: UI

class Element_green extends StatefulWidget {
  final String icon;
  final String name;
  final String value;
  final String unit;
  final String ref;

  const Element_green({
    super.key,
    required this.icon,
    required this.name,
    required this.value,
    required this.unit,
    required this.ref,
  });

  @override
  _Element_greenState createState() => _Element_greenState();
}

class _Element_greenState extends State<Element_green>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // ระยะเวลาการหมุน 360 องศา
      vsync: this,
    )..repeat(); // ทำให้หมุนไปเรื่อยๆ แบบไม่มีการย้อนกลับ
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme_Colors.element_green,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    widget.icon,
                    width: 40,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return ShaderMask(
                        shaderCallback: (bounds) {
                          return SweepGradient(
                            colors: [
                              Color(0xFF2AA04D),
                              Color(0xFF80BF2A),
                              Color(0xFFD8FFA3),
                              Color(
                                  0xFF2AA04D), // เพิ่มสีเดียวกันที่จุดเริ่มต้นเพื่อให้ smooth
                            ],
                            stops: [0.0, 0.5, 0.8, 1.0],
                            center: Alignment.center,
                            startAngle: 0.0,
                            endAngle: 2 * 3.141592653589793, // หมุนครบ 360 องศา
                            transform: GradientRotation(
                                _controller.value * 2 * 3.141592653589793),
                          ).createShader(bounds);
                        },
                        child: Row(
                          children: [
                            Text(
                              '${widget.name}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                shadows: [
                                  Shadow(
                                    color: Color(0xFFD8FFA3).withOpacity(1),
                                    blurRadius: 10,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                color: Colors.white, // ตัวอักษรสีขาว
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${widget.value} ${widget.unit}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme_Colors.element_green,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${widget.ref}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Color(0xFFD8FFA3),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class Element_yellow extends StatefulWidget {
  final String icon;
  final String name;
  final String value;
  final String unit;
  final String ref;

  const Element_yellow({
    super.key,
    required this.icon,
    required this.name,
    required this.value,
    required this.unit,
    required this.ref,
  });

  @override
  _Element_yellowState createState() => _Element_yellowState();
}

class _Element_yellowState extends State<Element_yellow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFDC75),
              Color(0xFFFFA951),
            ], // เปลี่ยนสีเหลืองเป็นสีเขียว
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    widget.icon,
                    width: 40,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return ShaderMask(
                        shaderCallback: (bounds) {
                          return SweepGradient(
                            colors: [
                              Color(0xFFFFEEBB),
                              Color(0xFFFFDC75),
                              Color(0xFFFFA951),
                              Color(0xFFFFEEBB),
                              // เพิ่มสีเดียวกันที่จุดเริ่มต้นเพื่อให้ smooth
                            ],
                            stops: [0.0, 0.5, 0.8, 1.0],
                            center: Alignment.center,
                            startAngle: 0.0,
                            endAngle: 2 * 3.141592653589793, // หมุนครบ 360 องศา
                            transform: GradientRotation(
                                _controller.value * 2 * 3.141592653589793),
                          ).createShader(bounds);
                        },
                        child: Text(
                          '${widget.name}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            shadows: [
                              Shadow(
                                color: Color(0xFFFFEEBB).withOpacity(1),
                                blurRadius: 10,
                                offset: Offset(0, 0),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${widget.value} ${widget.unit}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme_Colors
                          .element_yellow, // เปลี่ยนสีตัวเลขเป็นสีเขียว
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${widget.ref}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Color(0xFFFFEEBB),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

// TODO: ChangeNotifier Select Station

// คลาส StationProvider สำหรับการจัดการสถานะของสถานีที่ถูกเลือก
class StationProvider with ChangeNotifier {
  String _selectedStation = "Bang Khen"; // สถานีที่ถูกเลือกเริ่มต้น
  int _selectedPageIndex = 0; // ตำแหน่งเริ่มต้นของ PageView

  String get selectedStation => _selectedStation;
  int get selectedPageIndex => _selectedPageIndex;

  StationProvider() {
    _loadSelectedStation(); // โหลดสถานีที่ถูกเลือกจาก SharedPreferences เมื่อเริ่มต้น
  }

  Future<void> selectStation(String station, int stationIndex) async {
    _selectedStation = _capitalizeFirstLetterOfEachWord(station);
    _selectedPageIndex = (stationIndex / 4).floor();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedStation', _selectedStation);
    await prefs.setInt('selectedPageIndex', _selectedPageIndex);

    log('Selected Station Saved: $_selectedStation');
    notifyListeners(); // แจ้งให้ UI รู้เมื่อสถานีถูกเปลี่ยน
  }

  Future<void> _loadSelectedStation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? station = prefs.getString('selectedStation');
    int? pageIndex = prefs.getInt('selectedPageIndex');

    if (station != null && pageIndex != null) {
      _selectedStation = station;
      _selectedPageIndex = pageIndex;
      notifyListeners();
    } else {
      _selectedStation = "Bang Khen";
    }
  }

  String _capitalizeFirstLetterOfEachWord(String text) {
    return text.split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}

// รายการสถานี
final List<String> stationList = [
  'Bang Khen',
  'Lat Krabang',
  'Phloen Chit',
  'Thon Buri',
  'Samutprakan',
  'Yanawa',
  'Min Buri',
  'Nuan Chan',
];

// TODO: The Widget use Changenotifier

class StationSelector extends StatefulWidget {
  @override
  _StationSelectorState createState() => _StationSelectorState();
}

class _StationSelectorState extends State<StationSelector> {
  PageController? _pageController; // ตัวควบคุม PageView
  late Future<void> _loadPageIndexFuture; // โหลดข้อมูลที่บันทึกไว้

  @override
  void initState() {
    super.initState();
    _loadPageIndexFuture =
        _initializePageController(); // เริ่มการโหลดข้อมูลที่บันทึกไว้
  }

  Future<void> _initializePageController() async {
    // โหลดสถานีและตำแหน่งจาก StationProvider
    await Provider.of<StationProvider>(context, listen: false)
        ._loadSelectedStation();

    // ตั้งค่า PageController ด้วยตำแหน่งที่บันทึกไว้
    final selectedPageIndex =
        Provider.of<StationProvider>(context, listen: false).selectedPageIndex;
    setState(() {
      _pageController = PageController(initialPage: selectedPageIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadPageIndexFuture, // รอการโหลดข้อมูล
      builder: (context, snapshot) {
        return Consumer<StationProvider>(
          builder: (context, stationProvider, child) {
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: (stationList.length / 4).ceil(),
              itemBuilder: (context, pageIndex) {
                int startIndex = pageIndex * 4;
                int endIndex = (startIndex + 4 > stationList.length)
                    ? stationList.length
                    : startIndex + 4;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: stationList
                      .sublist(startIndex, endIndex)
                      .map((stationName) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Station(
                        name: stationName
                            .toUpperCase(), // แปลงเป็นตัวใหญ่ทั้งคำสำหรับการแสดงผล
                        isSelected:
                            stationProvider.selectedStation == stationName,
                        onSelected: (station) {
                          int stationIndex = stationList.indexOf(station);
                          stationProvider.selectStation(
                              station, stationIndex); // บันทึกสถานีที่ถูกเลือก
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController?.dispose(); // ลบ PageController เมื่อไม่ใช้งานแล้ว
    super.dispose();
  }
}

class Station extends StatefulWidget {
  final String name;
  final bool isSelected; // ฟิลด์ที่บอกว่าสถานีถูกเลือกหรือไม่
  final Function(String) onSelected; // ฟังก์ชันเมื่อสถานีถูกเลือก

  Station({
    required this.name,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  _StationState createState() => _StationState();
}

class _StationState extends State<Station> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelected(
            widget.name); // เรียกใช้ฟังก์ชัน onSelected เมื่อสถานีถูกกด
      },
      child: Container(
        width: 120,
        height: 30,
        decoration: BoxDecoration(
          color: widget.isSelected
              ? Theme_Colors.orange
              : Theme_Colors.white, // เปลี่ยนสีเมื่อเลือก
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 2, color: Theme_Colors.white),
          boxShadow: [
            BoxShadow(
              color: Theme_Colors.black.withOpacity(0.5),
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.name.toUpperCase(), // แปลงเป็นตัวใหญ่ทั้งคำ
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: widget.isSelected
                  ? Theme_Colors.white
                  : Color(0xFF393939), // เปลี่ยนสีตัวอักษรเมื่อถูกเลือก
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant Station oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ตรวจสอบการเปลี่ยนแปลงของสถานะการเลือก
    if (widget.isSelected != oldWidget.isSelected) {
      setState(() {
        // อัปเดตสถานะการเลือกเมื่อมีการเปลี่ยนสถานี
      });
    }
  }
}
