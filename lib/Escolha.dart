import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';
//import 'package:bar2/atualizaBar.dart';

//import 'config.dart'

class MyApp2 extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp2> {
  LocationData _startLocation;
  LocationData _currentLocation;

  StreamSubscription<LocationData> _locationSubscription;

  Location _locationService  = new Location();
  bool _permission = false;
  String error;

  bool currentWidget = true;

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(0, 0),
    zoom: 4,
  );

  CameraPosition _currentCameraPosition;

  GoogleMap googleMap;

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    await _locationService.changeSettings(accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          location = await _locationService.getLocation();

          _locationSubscription = _locationService.onLocationChanged().listen((LocationData result) async {
            _currentCameraPosition = CameraPosition(
                target: LatLng(result.latitude, result.longitude),
                zoom: 16
            );

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));
            if(mounted){
              setState(() {
                _currentLocation = result;
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if(serviceStatusResult){
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }

    setState(() {
      _startLocation = location;
    });

  }

  slowRefresh() async {
    _locationSubscription.cancel();
    await _locationService.changeSettings(accuracy: LocationAccuracy.BALANCED, interval: 10000);
    _locationSubscription = _locationService.onLocationChanged().listen((LocationData result) {
      if(mounted){
        setState(() {
          _currentLocation = result;
        });
        teste();
      }
    });
  }
 bool oi = false;
  bool delay = false;
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets;
    if(oi == true){
      if(delay == false) {
        delay = true;
        Future.delayed(const Duration(seconds: 5), () {
            teste();
            delay = false;
        });
      }


    }
    googleMap = GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      initialCameraPosition: _initialCamera,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },

    );

    widgets = [
      Center(
        child: SizedBox(
            height: 300.0,
            child: googleMap
        ),
      ),
    ];


    widgets.add(new Center(
        child: new Text(_startLocation != null
            ? 'Start location: ${_startLocation.latitude} & ${_startLocation.longitude}\n'
            : 'Error: $error\n')));

    widgets.add(new Center(
        child: new Text(_currentLocation != null
            ? 'Continuous location: \nlat: ${_currentLocation.latitude} & long: ${_currentLocation.longitude} \nalt: ${_currentLocation.altitude}m\n'
            : 'Error: $error\n', textAlign: TextAlign.center)));

   /* widgets.add(new Center(
        child: new Text(_permission
            ? 'Has permission : Yes'
            : "Has permission : No")));*/

   /* widgets.add(new Center(
        child: new RaisedButton(
            child: new Text("Slow refresh rate and accuracy"),
            onPressed: () => slowRefresh()
        )
    ));*/

    return
       new Scaffold(
          appBar: new AppBar(
            title: new Text('Location plugin example app'),
          ),
          body: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: widgets,
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: (){
              oi = !oi;
            },
            tooltip: 'Stop Track Location',
            child: Icon(Icons.stop),
          ),

        );
  }
  teste()async{
   print("envia");

    final FirebaseAuth _auth =  FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    print(user.uid);
    var data = {
      "image": "https://st.depositphotos.com/3538103/5175/i/950/depositphotos_51751599-stock-photo-bus-icon.jpg",
      "coords": GeoPoint(_currentLocation.latitude, _currentLocation.longitude)
    };

    _firestore.collection('onibus').document('d43').collection('logs').document(user.uid).setData({"user":user.uid,"location": GeoPoint(_currentLocation.latitude, _currentLocation.longitude)});
   _firestore.collection('users').document(user.uid).setData({"atual":"d43"},merge:true);
    _firestore.collection('users').document(user.uid).collection('coord').document('coord').setData(data,merge:true);
  }
  atualizaPosicao()async{

  }

  Widget loadMap(){
    return StreamBuilder(
      stream: Firestore.instance.collection('markers').snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData)return Text('Load');
        for(int i =0;i<snapshot.data.documents.lenght;i++){

        }
      }
    );
  }
}
