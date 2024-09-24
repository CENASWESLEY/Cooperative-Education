import 'package:flutter/material.dart';

class Theme_Colors {
  static const Color black = Color(0xFF000000);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color orange = Color(0xFFFE5000);

  //General

  static const LinearGradient general_gradient_mainborder = LinearGradient(
    colors: [Color(0xFFFE5000), Color(0xFFFFFFFF)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient general_gradient_subborder_left = LinearGradient(
    colors: [Color(0xFFFE5000), Color(0xFFFFAF8B)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient general_gradient_subborder_right = LinearGradient(
    colors: [Color(0xFFFE5000), Color(0xFFFFAF8B)],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  );

  static const LinearGradient general_gradient_maintext = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFFF9260), Color(0xFFFE5000)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  //Status

  static const LinearGradient status_gradient_available = LinearGradient(
    colors: [Color(0xFF001405), Color(0xFF1AE74E)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  static const Color status_available = Color(0xFF1AE74E);

  static const LinearGradient status_gradient_labelavailable = LinearGradient(
    colors: [Color(0xFF0F812C), Color(0xFF1AE74E)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient status_gradient_charging = LinearGradient(
    colors: [Color(0xFFFE5000), Color(0xFFFFAF8B)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  static const Color status_charging = Color(0xFFFF6C28);

  static const LinearGradient status_gradient_unavailable = LinearGradient(
    colors: [Color(0xFF150000), Color(0xFFFF0000)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  static const Color status_unavailable = Color(0xFFFF0000);

  static const LinearGradient status_gradient_labelunavailable = LinearGradient(
    colors: [Color(0xFF990000), Color(0xFFFF0000)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  //Element

  static const LinearGradient station_gradient_orange = LinearGradient(
    colors: [
      Color.fromARGB(255, 0, 0, 0),
      Color(0xFFFE5000),
      Color.fromARGB(255, 0, 0, 0)
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  );

  static const LinearGradient element_gradient_green = LinearGradient(
    colors: [Color(0xFF2AA04D), Color(0xFF80BF2A), Color(0xFFD8FFA3)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  );
  static const Color element_green = Color(0xFF8AC628);

  static const LinearGradient element_gradient_yellow = LinearGradient(
    colors: [Color(0xFFFFEEBB), Color(0xFFFFDC75), Color(0xFFFFA951)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const Color element_yellow = Color(0xFFEFCF6D);

  // TLM

  static const LinearGradient tlm_gradient_orange = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFFE5000)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient tlm_gradient_orange_value = LinearGradient(
    colors: [Color(0xFFFFAF8B), Color(0xFFFE5000)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const Color tlm_gradient_orange_text = Color(0xFFFFAC86);

  // Information

  static const LinearGradient information_gradient_orange = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFFE5000)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient information_gradient_orange_text = LinearGradient(
    colors: [Color(0xFFFFAF8B), Color(0xFFFE5000)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  //Grap

  static const LinearGradient grap1_gradient = LinearGradient(
    colors: [Color(0xFF1AE74E), Color.fromARGB(0, 0, 41, 11)],
    stops: [0.0, 1],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color grap1_text = Color(0xFF1AE74E);

  static const LinearGradient grap2_gradient = LinearGradient(
    colors: [Color(0xFFFFBB00), Color.fromARGB(0, 41, 35, 0)],
    stops: [0.0, 1],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Color grap2_text = Color(0xFFFFBB00);

  static const LinearGradient grap3_gradient = LinearGradient(
    colors: [Color(0xFFFF0000), Color.fromARGB(0, 75, 0, 0)],
    stops: [0.0, 1],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Color grap3_text = Color(0xFFFF0000);

  static const LinearGradient grap4_gradient = LinearGradient(
    colors: [Color(0xFFFE5000), Color.fromARGB(0, 46, 15, 0)],
    stops: [0.0, 1],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Color grap4_text = Color(0xFFFE5000);

  //Usage

  static const Color usage_text_orange = Color(0xFFFFAF8B);

  static const LinearGradient usage_gradient_orange_border = LinearGradient(
    colors: [Color(0xFFFFAF8B), Color(0xFFFE5000)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient usage_gradient_orange = LinearGradient(
    colors: [Color(0xFFFE5000), Color(0xFFFFAF8B)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient usage_gradient_orange_text = LinearGradient(
    colors: [Color(0xFFFFAF8B), Color(0xFFFE5000)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
