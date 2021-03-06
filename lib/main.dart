import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter/services.dart';
import 'package:involucrata/Escolha.dart';
import 'package:involucrata/Escolha2.dart';
import 'package:involucrata/Escolha3.dart';
import 'package:involucrata/Arvores.dart';
import 'MenuPrincipal.dart';
import 'cord.dart';
import 'package:involucrata/cord.dart';
import 'cord2.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:load/load.dart';
void printMessage(String msg) => print('[${DateTime.now()}] $msg');

void printPeriodic() => printMessage("Periodic!");
void printOneShot() => printMessage("One shot!");


void main() {




  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // SystemChrome.setEnabledSystemUIOverlays([]); tirar status bar

     runApp(
          LoadingProvider(
      child:
         MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Involucrata',
        theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'Ubuntu'),
        home: _getLandingPage());
  }

  Widget _getLandingPage() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
              builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (snapshot.hasData) {
                  return MenuPrincipal();
                } else {
                  return LoginScreen();
                }
              });
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.deepPurpleAccent,
            child: Center(
                child: Column(
              children: <Widget>[
                Expanded(child: Image.asset('assets/splash_icon.png')),
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.07),
                    child: GoogleSignInButton(
                      darkMode: true,
                      onPressed: () {
                        authService.googleSignIn();
                      },
                    ))
              ],
            ))));
  }
}
