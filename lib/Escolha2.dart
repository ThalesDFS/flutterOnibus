import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool mapToggle = false;
  bool sitiosToggle = false;
  bool resetToggle = false;
  Set<Marker> markers = Set();
  var currentLocation;

  var sitios = [];

  var sitioActual;
  var currentBearing;

  GoogleMapController mapController;

  void initState() {
    super.initState();
    setState(() {
      mapToggle = true;
      populateClients();
    });
  }

  populateClients() {
    sitios = [];
    Firestore.instance.collection('onibus').document('d43').collection('logs').getDocuments().then((docs) {
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
          position: LatLng(sitio['location'].latitude, sitio['location'].longitude)
      ),
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
                  child: Center(child: Text("oi"))),//sitio['nombreSitio']))),
            )));
  }

  zoomInMarker(sitio) {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            sitio['location'].latitude, sitio['location'].longitude),
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
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(51.0533076, 5.9260656), zoom: 5.0))).then((val) {//Alemania, Berlin
      setState(() {
        resetToggle = false;
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Poa'),
        ),
        body:
        StreamBuilder(
        stream: Firestore.instance.collection('onibus').document('d43').collection('logs').snapshots(),
            builder: (context, snapshot) {
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
                     markers.add(Marker(
                         markerId: MarkerId(mypost['user']),
                         position: LatLng(mypost['location'].latitude, mypost['location'].longitude),
                         infoWindow: InfoWindow(title: "teste")
                     ),);
                  }
                  return
        Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height - 80.0,
                    width: double.infinity,
                    child: mapToggle
                        ? GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(-29.9739628, -51.1948838),//Paris
                          zoom: 15
                      ),
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
            }

    ));
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}