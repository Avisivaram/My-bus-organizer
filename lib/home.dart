import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_bus_organizer/start_bus.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Color> cardColor = [
    Color(0xffff8474),
    Color(0xffc67ace),
    Color(0xfff7a440),
    Color(0xff77acf1),
    Color(0xfff65c65),
    Color(0xffa7d0cd),
    Color(0xffffc996),
    Color(0xff845460),
    Color(0xff91c788),
    Color(0xffc64756)
  ];
  List bus = [];
  int _itemcount = 0;
  final fb = FirebaseDatabase.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Home", style: TextStyle(color: Color(0xff00466b),
            fontSize: 30,
            fontWeight: FontWeight.w600)),
      ),
      body: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10),
            itemCount: _itemcount,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () => Navigator.of(context).pushNamed("/startbus",arguments:bus[index]),
                child: Card(
                  color: cardColor[index%10],
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(bus[index]["BusNo"], style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 5,
                          fontSize: 40.0),)
                  ),
                ),
              );
            },

          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/addbuses'),
        child: Icon(Icons.add),
        backgroundColor: Color(0xff00466b),
      ),
    );
  }

  Future<void> getData() async {
    final ref = fb.reference();
    await ref.child("Buses").once().then((value) {
      setState(() {
        value.value.forEach((u,v)=>bus.add(v));
        _itemcount=bus.length;
      });
    });
  }
}
