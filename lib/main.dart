import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_bus_organizer/add_buses.dart';
import 'package:my_bus_organizer/home.dart';
import 'package:my_bus_organizer/start_bus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(0x00ffffff)));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Montserrat",
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/addbuses' : (context) => AddBuses(),
        '/home' : (context) => Home(),
        '/startbus' : (context) => StartBus(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget{
  @override
  SplashScreenState createState() => SplashScreenState();

}
class SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),
            () =>
            Navigator.of(context).pushNamed('/home')
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              Spacer(flex: 2),
              Expanded(flex:4,child: Image.asset("assets/images/bus_logo.jpg"),),
              Spacer(flex:1),
              Expanded(flex:3,child: Text("MY BUS" ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,fontStyle: FontStyle.italic,color: Color(0xff00466b)))),
            ],
          ),
        )
    );
  }

}

