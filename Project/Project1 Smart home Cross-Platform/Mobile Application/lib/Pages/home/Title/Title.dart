import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mqtt_app/Pages/Provider/user_provider.dart';
import 'package:provider/provider.dart';

class Mytitle extends StatelessWidget {
  const Mytitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 44),
        child: Container(
          width: 330,
          height: 63,
          decoration: BoxDecoration(
              color: Color(0xff1A1A1A),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Color(0xff000000), blurRadius: 10),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Application Smart Home',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 10),
                    ),
                    Text(
                      'Hey , ${userProvider.name}',
                      style: TextStyle(color: Color(0xffF5B553), fontSize: 10),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      radius: 21,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: userProvider.imagePath.isNotEmpty
                            ? FileImage(File(userProvider.imagePath))
                            : AssetImage('assets/images/Avatar.png')
                                as ImageProvider,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
