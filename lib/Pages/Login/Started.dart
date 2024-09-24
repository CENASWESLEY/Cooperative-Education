import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mqtt_app/items/Button.dart';
import 'package:mqtt_app/pages/Login/Login.dart';

class Mystart extends StatelessWidget {
  const Mystart({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildMainScreen(context);
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
                child: Text('Error initializing Firebase: ${snapshot.error}')),
          );
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildMainScreen(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                child: Image.asset(
                  'assets/images/Screen.png',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset('assets/Icons/Logo.png'),
                    width: 164,
                    height: 182,
                  ),
                  SizedBox(
                    height: 120,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          'Welcome To Application',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(0, 5),
                                  blurRadius: 10,
                                )
                              ]),
                        ),
                        Text(
                          'Smart Home',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(0, 5),
                                  blurRadius: 10,
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 250,
                          child: Text(
                            'Control your home with just a touch. Create the perfect smart home experience with us.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    offset: Offset(0, 5),
                                    blurRadius: 5,
                                  )
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 120,
                        ),
                        Mybutton(),
                      ],
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
