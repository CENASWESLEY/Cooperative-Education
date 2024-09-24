import 'package:dashboard_ems/Component/Theme.dart';
import 'package:dashboard_ems/Section/Section1/Connector_Status.dart';
import 'package:dashboard_ems/Section/Section2/Main_Information.dart';
import 'package:dashboard_ems/Section/Section3/TLM_MDB.dart';
import 'package:dashboard_ems/Section/Section4/Charging_Information.dart';
import 'package:dashboard_ems/Section/Section5/Charging_Profile.dart';
import 'package:dashboard_ems/Section/Section6/Charging_Usage.dart';
import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme_Colors.black,
      body: Container(
        /*
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        */
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Connector_Status(),
                Main_Information(),
                TLM_MDB(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Charging_Information(),
                Charging_Profile(),
                Charging_Usage(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
