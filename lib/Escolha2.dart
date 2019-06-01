import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
void main() => runApp(MyApp3());

class MyApp3 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


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
  void initState() {
    super.initState();
    super.initState();
    setState(() {
      mapToggle = true;
      populateClients();
    });
    initPlatformState();
  }
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
        //teste();
      }
    });
  }
  bool oi = false;
  bool delay = false;


  bool mapToggle = false;
  bool sitiosToggle = false;
  bool resetToggle = false;
  Set<Marker> markers = Set();
  var currentLocation;

  var sitios = [];

  var sitioActual;
  var currentBearing;

  GoogleMapController mapController;

  populateClients() {
    sitios = [];
    Firestore.instance
        .collection('onibus')
        .document('d43')
        .collection('logs')
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        setState(() {
          sitiosToggle = true;
        });
        for (int i = 0; i < docs.documents.length; ++i) {
          sitios.add(docs.documents[i].data);
          initMarker(docs.documents[i].data);
        }
      }
    });
  }

  initMarker(sitio) {
    markers.addAll([
      Marker(
          markerId: MarkerId('value2'),
          position:
              LatLng(sitio['location'].latitude, sitio['location'].longitude)),
    ]);
  }

  Widget siteCard(sitio) {
    return Padding(
        padding: EdgeInsets.only(left: 2.0, top: 10.0),
        child: InkWell(
            onTap: () {
              setState(() {
                sitioActual = sitio;
                // currentBearing = 90.0;
              });
              zoomInMarker(sitio);
            },
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                  height: 100.0,
                  width: 125.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white),
                  child: Center(child: Text("oi"))), //sitio['nombreSitio']))),
            )));
  }

  zoomInMarker(sitio) {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target:
                LatLng(sitio['location'].latitude, sitio['location'].longitude),
            zoom: 17.0,
            bearing: 90.0,
            tilt: 45.0)))
        .then((val) {
      setState(() {
        resetToggle = true;
      });
    });
  }

  markerInicial() {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(51.0533076, 5.9260656), zoom: 5.0)))
        .then((val) {
      //Alemania, Berlin
      setState(() {
        resetToggle = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_startLocation != null) {
      print(_startLocation.latitude.toString());
    }
    if(_currentLocation != null) {
      print(_currentLocation.latitude.toString());
      print(_currentLocation.longitude.toString());
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Poa'),
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('onibus')
                .document('d43')
                .collection('logs')
                .snapshots(),
            builder: (context, snapshot) {
              try{
              if (snapshot.data == null) {
                return CircularProgressIndicator();
              } else {
                if (!snapshot.hasData) {
                  const Text('loading');
                } else {
                  DocumentSnapshot mypost;
                  markers.clear();
                  for (int i = 0; i < snapshot.data.documents.length; i++) {
                    mypost = snapshot.data.documents[i];
                    Timestamp teste = mypost['date'];
                    DateTime cloudDate = teste.toDate();
                   print("teste");
                      markers.add(
                        Marker(
                            markerId: MarkerId(mypost['user']),
                            position: LatLng(mypost['location'].latitude,
                                mypost['location'].longitude),
                            infoWindow: InfoWindow(title: "teste")),
                      );

                  }
                  return Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                              height: MediaQuery.of(context).size.height - 80.0,
                              width: double.infinity,
                              child: mapToggle
                                  ? GoogleMap(
                                      initialCameraPosition: _initialCamera,
                                      onMapCreated: onMapCreated,
                                      myLocationEnabled: true,
                                      mapType: MapType.normal,
                                      compassEnabled: true,
                                      markers: markers,
                                    )
                                  : Center(
                                      child: Text(
                                      'Revisa datos, gps, wifi..',
                                      style: TextStyle(fontSize: 20.0),
                                    ))),
                          //cajas markers segun numero de marcadores
                          Positioned(
                              top: MediaQuery.of(context).size.height - 150.0,
                              left: 10.0,
                              child: Container(
                                  height: 50.0,
                                  width: MediaQuery.of(context).size.width,
                                  child: sitiosToggle
                                      ? ListView(
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.all(8.0),
                                          children: sitios.map((element) {
                                            return siteCard(element);
                                          }).toList(),
                                        )
                                      : Container(height: 1.0, width: 1.0))),
                          //Fin container segun numero de marcadores
                          //creamos tres botones giro izquierda derecha i resetar camara
                          resetToggle
                              ? Positioned(
                                  top: MediaQuery.of(context).size.height -
                                      (MediaQuery.of(context).size.height -
                                          50.0),
                                  right: 15.0,
                                  child: FloatingActionButton(
                                    onPressed: markerInicial,
                                    mini: true,
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.refresh),
                                  ))
                              : Container(),
                        ],
                      )
                    ],
                  );
                }
              }
            }catch(e){
                return Center(child:CircularProgressIndicator());
              }
            }));
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
