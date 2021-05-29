import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StartBus extends StatefulWidget{
  @override
  StartBusState createState() => StartBusState();

}
class StartBusState extends State<StartBus> {
  TextEditingController _fromController = new TextEditingController();
  TextEditingController _toController = new TextEditingController();
  final fb = FirebaseDatabase.instance;
  bool flag=false;
  bool buttonStop =true;
  String start = "Start";
  String busNo="";
  String busRouteNo="";
  var geo=Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high,distanceFilter: 10);
  var posStream;
  bool reverse=false;
  var busStops;
  int stopCount=0;
  bool previous=false,next=true;
  CarouselController _controller = CarouselController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getData(String busrouteno) async {
    final ref = fb.reference();
    await ref.child("BusRoutes").child(busrouteno).once().then((value) {
      setState(() {
        _fromController.text=value.value["Stops"][0];
        busStops=value.value["Stops"];
        stopCount = value.value["StopsCount"];
        _toController.text=value.value["Stops"][stopCount-1];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    if(!flag){
      busRouteNo=args["BusRouteNo"];
      getData(args["BusRouteNo"]);
      busNo=args["BusNo"];
      flag=true;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(busNo, style: TextStyle(color: Color(0xff00466b),
            fontSize: 30,
            fontWeight: FontWeight.w600)),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            buttonStop?getTextView():getQR(),
            getStart(),
          ],
        ),
      )
    );
  }
  Widget getTextView(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TextField(
            enableInteractiveSelection: false,
            // will disable paste operation
            focusNode: FocusNode(),
            enabled: false,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "From",
            ),
            controller: _fromController,
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Center(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      String s=_fromController.text;
                      _fromController.text=_toController.text;
                      _toController.text=s;
                      reverse=!reverse;
                    });
                  },
                  icon: Icon(Icons.swap_vert_outlined, size: 30,),
                  color:Color(0xff00466b)
              ),
            )
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TextField(
            enableInteractiveSelection: false,
            // will disable paste operation
            focusNode: FocusNode(),
            enabled: false,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "To",
            ),
            controller: _toController,
          ),
        ),
      ],
    );
  }

  Widget getStart() {
    return Container(
      width: 135,
      height: 135,
      margin: EdgeInsets.all(90),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xff00466b),
      ),
      child: InkWell(
        onTap: () async {final ref = fb.reference();
        if(buttonStop){
          setState(() {
            buttonStop=false;
            start="Stop";
          });
          posStream=geo.listen((Position position) async {
            await ref.child("Location").child(busRouteNo).child(busNo).set(<String,double>{
              "Latitude":position.latitude,
              "Longitude":position.longitude
            });
            print(position == null ? 'Unknown' : position.latitude.toString() + ', ' +
                position.longitude.toString());
          });
        }else{
          setState(() {
            start="Start";
            buttonStop=true;
          });
          posStream.cancel();
          await ref.child("Location").child(busRouteNo).child(busNo).set(null);
        }
        },
        child: Center(child:Text("$start",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w600),),),
      ),
    );
  }
  Widget getQR(){
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: stopCount-1,
          itemBuilder: (context,index,key){
            String busStop=reverse ? busStops[stopCount-index-1] : busStops[index];
            int busStopNo=reverse ? stopCount-index-1 : index;
            return Column(
                children: [
                  Center(
                    child:Text(busStop, style: TextStyle(color: Color(0xff00466b),
                        fontSize: 30,
                        fontWeight: FontWeight.w500)),),
                  Container(width:250,height:250,
                    child: QrImage(data:"My Bus:\nBusNo:$busNo\nBusRouteNo:$busRouteNo\nBusStop:$busStop\nBusStopNo:$busStopNo\nReverse:$reverse\nBusStops:$busStops",),
                  )
                ]
            );
          },
          carouselController: _controller,
          options: CarouselOptions(
            viewportFraction: 1.0,
            height: 300,
            enableInfiniteScroll: false,
            onPageChanged:(index,reason){
              setState(() {
                if(index==0){
                  previous=false;
                  next=true;
                }else if(index == stopCount-2){
                  previous=true;
                  next=false;
                }else{
                  previous=true;
                  next=true;
                }
              });
            } ,
          ),
        ),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 2,
                child: Visibility(
                  visible: previous,
                  child: FlatButton(
                      onPressed: () {_controller.previousPage();},
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: Color(0xff00466b),
                      child: Text(
                        "Previous",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      )
                  ),
                )
            ),
            Spacer(),
            Expanded(
              flex: 2,
                child: Visibility(
                  visible: next,
                  child: FlatButton(
                      onPressed: () {_controller.nextPage();},
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: Color(0xff00466b),
                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      )
                  ),
                )
            ),
            Spacer(),
          ],
        )

      ],
    );
  }
}
