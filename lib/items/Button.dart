import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_app/Pages/Login/Login.dart';
import 'package:mqtt_app/Pages/home/home.dart';
import 'package:mqtt_app/Pages/superpages.dart';

class Mybutton extends StatefulWidget {
  const Mybutton({super.key});

  @override
  State<Mybutton> createState() => _MybuttonState();
}

class _MybuttonState extends State<Mybutton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(270, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyLogin()),
        );
      },
      child: Text(
        'GET STARTED',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color.fromARGB(255, 0, 0, 0),
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }
}

class MyButtonLogin extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const MyButtonLogin(
      {super.key,
      required this.emailController,
      required this.passwordController});

  @override
  State<MyButtonLogin> createState() => _MyButtonLoginState();
}

class _MyButtonLoginState extends State<MyButtonLogin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async {
    final String email = widget.emailController.text;
    final String password = widget.passwordController.text;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Mysuperpages()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Login Your Account')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(300, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: _login,
      child: Text(
        'LOGIN',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color.fromARGB(255, 0, 0, 0),
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }
}

class MyButtonRegister extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const MyButtonRegister(
      {super.key,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController});

  @override
  State<MyButtonRegister> createState() => _MyButtonRegisterState();
}

class _MyButtonRegisterState extends State<MyButtonRegister> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _register() async {
    final String email = widget.emailController.text;
    final String password = widget.passwordController.text;
    final String confirmPassword = widget.confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyLogin()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Registration Your Account')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(300, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )),
      onPressed: _register,
      child: Text(
        'REGISTER',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color.fromARGB(255, 0, 0, 0),
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }
}
