import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddBuses extends StatefulWidget {
  @override
  AddBusesState createState() => AddBusesState();
}

class AddBusesState extends State<AddBuses> {
  var _formKey = GlobalKey<FormState>();
  int count = 1;
  String busNo;
  String busRouteNo;
  String fromStop;
  String toStop;
  List<String> interStop=[''];

  final fb = FirebaseDatabase.instance;


  void _add_buses(){
    setState(() {
      interStop.add('');
      count++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("Add Buses", style: TextStyle(color: Color(0xff00466b),fontSize: 30,fontWeight: FontWeight.w600)),
        ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child:TextFormField(
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Bus No",
                  ),
                  onSaved: (value){
                    busNo=value;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child:TextFormField(
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Bus Route Number",
                  ),
                  onSaved: (value){
                    busRouteNo=value;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child:TextFormField(
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "From",
                  ),
                  onSaved: (value){
                    fromStop=value;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child:TextFormField(
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "To",
                  ),
                  onSaved: (value){
                    toStop=value;
                  },
                ),
              ),
              for(int i=1 ; i<=count;i++)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  child: TextFormField(
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: (){
                          _add_buses();
                        },
                        color: Color(0xff00466b),
                      ),
                      labelText: "Intermidiate Stop $i",
                    ),
                    onSaved: (value){
                      interStop[i-1]=value;
                    },
                  ),
                ),
              Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 40, 30, 40),
                  child: FlatButton(
                      onPressed: () async {
                        final ref = fb.reference();
                        _formKey.currentState.save();
                        await ref.child("Buses").child(busNo)
                            .set(<String,Object>{
                              "BusNo": busNo,
                              "BusRouteNo":busRouteNo,
                        });
                        if(fromStop!=""){
                          await ref.child("BusRoutes").child(busRouteNo)
                              .set(<String,Object>{
                            "BusRouteNo":busRouteNo,
                            "StopsCount":count+2,
                            "Stops":<String,String>{
                              "0":fromStop,
                              for(int i=0;i<count;i++)
                                (i+1).toString():interStop[i],
                              (count+1).toString():toStop,
                            }
                          });
                        }
                        Navigator.of(context).pushNamed('/home');
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: Color(0xff00466b),
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      )
                  )
              ),

            ],
          ),
        )
      )
    );
  }
}
