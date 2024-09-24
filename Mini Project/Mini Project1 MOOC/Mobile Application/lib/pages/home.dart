import 'package:flutter/material.dart';

class Myhome extends StatelessWidget {
  const Myhome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyApp(),
    );
  }
}

/* ================ AppPages ================= */
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int mycurrentindex = 1;
  List pages = [
    Listview_home(),
    Listview__course(),
    Listview_profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: pages[mycurrentindex]),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าแรก'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books_rounded), label: 'คอร์สเรียน'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'โปรไฟล์'),
        ],
        backgroundColor: Color.fromRGBO(243, 111, 33, 1),
        selectedItemColor: Colors.white,
        unselectedItemColor: Color.fromARGB(255, 44, 44, 44),
        onTap: (index) {
          setState(() {
            mycurrentindex = index;
          });
        },
        currentIndex: mycurrentindex,
      ),
    );
  }
}

/* ================ CreatePages ================= */

class Listview_home extends StatelessWidget {
  const Listview_home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        /* Head */

        header(),

        /* Categoty */

        Container(
          width: double.infinity,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'หมวดหมู่วิชา',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              category_mainbox(),
            ],
          ),
        ),

        /* Course */

        Container(
          width: double.infinity,
          height: 110,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'คอร์สเรียน',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/programming.png',
                            width: 106,
                            height: 68,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: 106,
                        height: 68,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color.fromRGBO(255, 94, 0, 1),
                              Color.fromARGB(0, 255, 255, 255)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          'PROGRAMMING\nWeb Development',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors
                                    .black, // Choose the color of the shadow
                                blurRadius:
                                    2, // Adjust the blur radius for the shadow effect
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/economy.png',
                            width: 106,
                            height: 68,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: 106,
                        height: 68,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color.fromRGBO(255, 94, 0, 1),
                              Color.fromARGB(0, 255, 255, 255)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          'ECONOMY\nFinance and Tax',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors
                                    .black, // Choose the color of the shadow
                                blurRadius:
                                    2, // Adjust the blur radius for the shadow effect
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/language.png',
                            width: 106,
                            height: 68,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: 106,
                        height: 68,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color.fromRGBO(255, 94, 0, 1),
                              Color.fromARGB(0, 255, 255, 255)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          'LANGUAGE\nEnglish',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors
                                    .black, // Choose the color of the shadow
                                blurRadius:
                                    2, // Adjust the blur radius for the shadow effect
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),

        /* Activity */

        Container(
          width: double.infinity,
          height: 175,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'กิจกรรมสุดพิเศษ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/activity1.png',
                          width: 94,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        child: Column(
                          children: [
                            Text(
                              '10 December 2024\n09.00 - 12.00 Am',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors
                                        .black, // Choose the color of the shadow
                                    blurRadius:
                                        2, // Adjust the blur radius for the shadow effect
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              children: [
                                Text(
                                  'BEGINNER\nDEVELOPER',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors
                                            .black, // Choose the color of the shadow
                                        blurRadius:
                                            2, // Adjust the blur radius for the shadow effect
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 10,
                                      color: Color.fromRGBO(243, 111, 33, 1),
                                    ),
                                    Container(
                                      child: Text(
                                        'ณ หอประชุม',
                                        style: TextStyle(
                                            fontSize: 7,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/activity2.png',
                          width: 94,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        child: Column(
                          children: [
                            Text(
                              '10 December 2024\n09.00 - 12.00 Am',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors
                                        .black, // Choose the color of the shadow
                                    blurRadius:
                                        2, // Adjust the blur radius for the shadow effect
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              children: [
                                Text(
                                  'LEADERSHIP\nMANAGEMENT',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors
                                            .black, // Choose the color of the shadow
                                        blurRadius:
                                            2, // Adjust the blur radius for the shadow effect
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 10,
                                      color: Color.fromRGBO(243, 111, 33, 1),
                                    ),
                                    Container(
                                      child: Text(
                                        'ณ หอประชุม',
                                        style: TextStyle(
                                            fontSize: 7,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/activity3.png',
                          width: 94,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        child: Column(
                          children: [
                            Text(
                              '10 December 2024\n09.00 - 12.00 Am',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors
                                        .black, // Choose the color of the shadow
                                    blurRadius:
                                        2, // Adjust the blur radius for the shadow effect
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              children: [
                                Text(
                                  'DIGITAL\nMARKETING',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    shadows: [
                                      Shadow(
                                        color: Colors
                                            .black, // Choose the color of the shadow
                                        blurRadius:
                                            2, // Adjust the blur radius for the shadow effect
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 10,
                                      color: Color.fromRGBO(243, 111, 33, 1),
                                    ),
                                    Container(
                                      child: Text(
                                        'ณ หอประชุม',
                                        style: TextStyle(
                                            fontSize: 7,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/activity4.png',
                          width: 94,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        child: Column(
                          children: [
                            Text(
                              '10 December 2024\n09.00 - 12.00 Am',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors
                                        .black, // Choose the color of the shadow
                                    blurRadius:
                                        2, // Adjust the blur radius for the shadow effect
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              children: [
                                Text(
                                  'ELECTRICITY\n&ELECTRONICS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors
                                            .black, // Choose the color of the shadow
                                        blurRadius:
                                            2, // Adjust the blur radius for the shadow effect
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 10,
                                      color: Color.fromRGBO(243, 111, 33, 1),
                                    ),
                                    Container(
                                      child: Text(
                                        'ณ หอประชุม',
                                        style: TextStyle(
                                            fontSize: 7,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),

        /* News */

        Container(
          width: double.infinity,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'หมวดหมู่วิชา',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 350,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          blurRadius: 20),
                    ],
                  ),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(0),
                            ),
                            child: Image.asset(
                              'assets/images/new.png',
                              width: 155,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'เตรียมพบกับคอร์สเรียนใหม่',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              'ในเดือนมกราคมนี้เตรียมพบกับคอร์สเรียนใหม่ๆที่จะเพิ่ม\nเติมเข้ามาอีก 3 คอร์สด้วยกันในหมวดหมู่วิชา Technology\nและ Business ได้แก่ Data analysis , Invesment\nMachine Learning',
                              style: TextStyle(
                                  fontSize: 7, fontWeight: FontWeight.w500),
                            ),
                            Center(
                              child: SizedBox(
                                height: 25,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    'ลงทะเบียนล่วงหน้า',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 8),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(243, 111, 33, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }
}

class Listview__course extends StatelessWidget {
  const Listview__course({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Column(
          children: [
            /* Head Course */

            Stack(
              children: [
                Container(
                  child: Image.asset(
                    'assets/images/Course_Technology.png',
                    width: double.infinity,
                    height: 210,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, left: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'เทคโนโลยี',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 50,
                                color: Color.fromRGBO(243, 111, 33, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'TECHNOLOGY',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 10,
                                  height: -1.1),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: 300,
                              child: Text(
                                'หลักสูตรเทคโนโลยีนี้จะทำให้คุณสามารถนำความรู้ไปประยุกต์ใช้ได้ในแต่ละสายงานอาชีพเพราะว่าหลักสูตรของเรามีคอร์สให้เลือกเรียนมากมายโดยความรู้ในแต่ละบทนั้นถูกคัดสรรจากผู้เชี่ยวชาญโดยเฉพาะ ซึ่งสามารถเรียนได้ทั้งระดับผู้ที่พึ่งเริ่มต้นศึกษาไปจนถึงผู้ที่มีความรู้ระดับกลางที่พร้อมจะต่อยอดให้ไปถึงระดับที่สามารถนำความรู้มาประยุกต์ใช้เองได้และสร้างสรรค์สิ่งใหม่ๆจากองค์ความรู้เดิม',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ), // Second child
              ],
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'คอร์สเรียน',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  /* GRid Course */

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: 180,
                              height: 190,
                              color: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Image.asset('assets/images/Fullsatck.png'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Web Development (Full Stack)',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color.fromRGBO(243, 111, 33, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'การพัฒนาเว็ปไซต์ทั้งด้าน Frontend และ Backend ด้วย HTML,CSS และ Javascript ซึ่งคอร์สนี้จะพาคุณลงมือทำเว็ปไซต์แบบครบวงจร',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'เนื้อหา : 10 บทเรียน',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 7,
                                            color: Color.fromARGB(
                                                255, 226, 226, 226),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'ผู้สอน : สมาคมสารสนเทศ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 7,
                                            color: Color.fromARGB(
                                                255, 226, 226, 226),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: 180,
                              height: 190,
                              color: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Image.asset('assets/images/Iot.png'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Internet of thing (IOT)',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color.fromRGBO(243, 111, 33, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'เรียนรู้การใช้ IoT เพื่อประยุกต์ใช้ในเชิงลึกของภาคอุตสาหกรรม เพื่อให้เข้าใจหลักการทำงานของ IoT ร่วมกับอุปกรณ์อื่น',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'เนื้อหา : 20 บทเรียน',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 7,
                                            color: Color.fromARGB(
                                                255, 226, 226, 226),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'ผู้สอน : สมาคมสารสนเทศ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 7,
                                            color: Color.fromARGB(
                                                255, 226, 226, 226),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: 180,
                              height: 190,
                              color: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Image.asset('assets/images/Fullsatck.png'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Web Development (Full Stack)',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color.fromRGBO(243, 111, 33, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'การพัฒนาเว็ปไซต์ทั้งด้าน Frontend และ Backend ด้วย HTML,CSS และ Javascript ซึ่งคอร์สนี้จะพาคุณลงมือทำเว็ปไซต์แบบครบวงจร',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'เนื้อหา : 10 บทเรียน',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 7,
                                            color: Color.fromARGB(
                                                255, 226, 226, 226),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'ผู้สอน : สมาคมสารสนเทศ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 7,
                                            color: Color.fromARGB(
                                                255, 226, 226, 226),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: 180,
                              height: 190,
                              color: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Image.asset('assets/images/Iot.png'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Internet of thing (IOT)',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color.fromRGBO(243, 111, 33, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'เรียนรู้การใช้ IoT เพื่อประยุกต์ใช้ในเชิงลึกของภาคอุตสาหกรรม เพื่อให้เข้าใจหลักการทำงานของ IoT ร่วมกับอุปกรณ์อื่น',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'เนื้อหา : 20 บทเรียน',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 7,
                                            color: Color.fromARGB(
                                                255, 226, 226, 226),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'ผู้สอน : สมาคมสารสนเทศ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 7,
                                            color: Color.fromARGB(
                                                255, 226, 226, 226),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    ));
  }
}

class Listview__course2 extends StatelessWidget {
  const Listview__course2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(alignment: Alignment.center, children: [
            Container(
              width: double.infinity,
              child: Image.asset('assets/images/bg_course2.png'),
            ),
            Container(
              width: 300,
              child: Column(
                children: [
                  Text(
                    'TECHNOLOGY',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                  Text(
                    'WEB DEVELOPMENT',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(243, 111, 33, 1)),
                  ),
                  Text(
                    'การพัฒนาเว็ปไซต์ทั้งด้าน Frontend และ Backend ด้วย HTML,CSS และ Javascript ซึ่งคอร์สนี้จะพาคุณลงมือทำเว็ปไซต์แบบครบวงจร',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'เกณฑ์การจบหลักสูตร',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(243, 111, 33, 1)),
                      ),
                      Text(
                        '• เรียนเนื้อหาหลักสูตรครบถ้วนทั้งหมด\n• แบบทดสอบท้ายบท ผู้เรียนจะต้องทำคะแนนให้เกิน 80 % ทุกบทเรียน\n• แบบทดสอบท้ายหลักสูตร ผู้เรียนจะต้องทำคะแนนให้เกิน 80 % ขึ้นไปถึงจะได้รับใบประกาศนียบัตร(Certificate)',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            )
          ]),
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'รายละเอียด',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/Aj.png',
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ผู้สอน',
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              Text(
                                'ศาสตราจารย์ ดร.วาสนา สวยงาม',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(243, 111, 33, 1)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'บทเรียน',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                '4/10',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(
                                                        243, 111, 33, 1)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'บทเรียน',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                '4/10',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(
                                                        243, 111, 33, 1)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'บทเรียน',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                '4/10',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(
                                                        243, 111, 33, 1)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 170,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(243, 111, 33, 1)),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.assistant,
                                          color: Colors.white,
                                          size: 10.0,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'CERTIFICATE',
                                          style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_drop_down_sharp,
                                      color: Colors.white,
                                      size: 10.0,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'รายละเอียด',
                                      style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Listview_profile extends StatelessWidget {
  const Listview_profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Color.fromRGBO(243, 111, 33, 1),
            ),

            /* Head profile */

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/user.png',
                            width: 53,
                            height: 57,
                            fit: BoxFit.contain,
                            alignment: Alignment(0, 0),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ms.Michel Bernard',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.email_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'mizwwe.1122@gmail.com',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '+66963-785-9856',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.notifications,
                            size: 24,
                            color: Color.fromRGBO(243, 111, 33, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),

          /* profile box */
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 24,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'บัญชีผู้ใช้',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        size: 24,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 30,
                  thickness: 0.5,
                  indent: 60,
                  endIndent: 60,
                  color: const Color.fromARGB(255, 71, 71, 71),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.book_rounded,
                            size: 24,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'คอร์สเรียนของฉัน',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        size: 24,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 30,
                  thickness: 0.5,
                  indent: 60,
                  endIndent: 60,
                  color: const Color.fromARGB(255, 71, 71, 71),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.token,
                            size: 24,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'ใบประกาศนียบัตร',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        size: 24,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 30,
                  thickness: 0.5,
                  indent: 60,
                  endIndent: 60,
                  color: const Color.fromARGB(255, 71, 71, 71),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.settings,
                            size: 24,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'ตั้งค่า',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        size: 24,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 30,
                  thickness: 0.5,
                  indent: 60,
                  endIndent: 60,
                  color: const Color.fromARGB(255, 71, 71, 71),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.help,
                            size: 24,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'ช่วยเหลือ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        size: 24,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 30,
                  thickness: 0.5,
                  indent: 60,
                  endIndent: 60,
                  color: const Color.fromARGB(255, 71, 71, 71),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.logout,
                            size: 24,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'ออกจากระบบ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/*============= Form Create State =================*/

/*============= state header =================*/

class header extends StatelessWidget {
  const header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Color.fromRGBO(243, 111, 33, 1),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(0),
            topLeft: Radius.circular(0),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hey mizwwe,',
                        style: TextStyle(
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        'Find to your course interesting',
                        style: TextStyle(
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/user.png',
                          width: 53,
                          height: 57,
                          fit: BoxFit.contain,
                          alignment: Alignment(0, 0),
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                width: 340,
                child: TextField(
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(15),
                      hintText: 'ค้นหารายวิชาที่นี่',
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(243, 111, 33, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w800),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          width: 50,
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Color.fromRGBO(243, 111, 33, 1),
                                ),
                                VerticalDivider(
                                  color: Color.fromRGBO(243, 111, 33, 1),
                                  indent: 10,
                                  endIndent: 10,
                                  thickness: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*============= category =================*/

class category_mainbox extends StatelessWidget {
  const category_mainbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            SizedBox(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Color.fromRGBO(243, 111, 33, 1))),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.business_center,
                    size: 24,
                    color: Color.fromRGBO(243, 111, 33, 1),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'ธุรกิจ',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Color.fromRGBO(243, 111, 33, 1))),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.monetization_on,
                    size: 24,
                    color: Color.fromRGBO(243, 111, 33, 1),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'เศรษฐศาสตร์',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Color.fromRGBO(243, 111, 33, 1))),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.manage_accounts,
                    size: 24,
                    color: Color.fromRGBO(243, 111, 33, 1),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'การจัดการ',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Color.fromRGBO(243, 111, 33, 1))),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.computer,
                    size: 24,
                    color: Color.fromRGBO(243, 111, 33, 1),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'เทคดนโลยี',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Color.fromRGBO(243, 111, 33, 1))),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.language_sharp,
                    size: 24,
                    color: Color.fromRGBO(243, 111, 33, 1),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'ภาษา',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        )
      ],
    );
  }
}
