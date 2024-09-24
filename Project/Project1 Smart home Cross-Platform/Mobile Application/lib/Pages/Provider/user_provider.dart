import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class UserProvider with ChangeNotifier {
  String _name = 'Mizwwe';
  String _email = 'supavit.mu@ku.th';
  String _location =
      'Location : 15/962 GambitTowm, Hamberg Road, PistonRog District, Roman, 10985 ';
  String _imagePath = '';

  String get name => _name;
  String get email => _email;
  String get location => _location;
  String get imagePath => _imagePath;

  UserProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? 'Mizwwe';
    _email = prefs.getString('email') ?? 'supavit.mu@ku.th';
    _location = prefs.getString('location') ??
        'Location : 15/962 GambitTowm, Hamberg Road, PistonRog District, Roman, 10985 ';
    _imagePath = prefs.getString('imagePath') ?? '';
    notifyListeners();
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _name);
    await prefs.setString('email', _email);
    await prefs.setString('location', _location);
    await prefs.setString('imagePath', _imagePath);
  }

  void updateUser(
      String name, String email, String location, String imagePath) {
    _name = name;
    _email = email;
    _location = location;
    _imagePath = imagePath;
    _saveUserData();
    notifyListeners();
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final fileName = pickedFile.name;
      final newPath = '$path/$fileName';
      final file = File(pickedFile.path);
      file.copy(newPath);

      _imagePath = newPath;
      _saveUserData();
      notifyListeners();
    }
  }
}
