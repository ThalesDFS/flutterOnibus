import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui';
import 'package:involucrata/auth.dart';
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
import 'main.dart';
import 'package:flushbar/flushbar.dart';
//import 'package:bar2/atualizaBar.dart';

//import 'config.dart'

class MyApp2 extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp2> {
  bool futuro= false;
  bool _autovalidate = false;
  GlobalKey<FormState> _key = new GlobalKey();
  LocationData _startLocation;
  LocationData _currentLocation;
  String onibus = null;
  String onibusCompartilha;
  StreamSubscription<LocationData> _locationSubscription;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Location _locationService = new Location();
  bool _permission = false;
  String error;

  bool currentWidget = true;

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(-30.0333496, -51.2299755),
    zoom: 11.50,
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
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);

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

          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            _currentCameraPosition = CameraPosition(
                target: LatLng(result.latitude, result.longitude), zoom: 16);

            final GoogleMapController controller = await _controller.future;
            /* controller.animateCamera(
                CameraUpdate.newCameraPosition(_currentCameraPosition));*/
            if (mounted) {
              setState(() {
                _currentLocation = result;
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
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
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.BALANCED, interval: 10000);
    _locationSubscription =
        _locationService.onLocationChanged().listen((LocationData result) {
      if (mounted) {
        setState(() {
          _currentLocation = result;
        });
        teste();
      }
    });
  }

  bool oi = false;
  bool delay = false;
  Set<Marker> markers = Set();
  String descricao;

  void showInSnackBar3(String value) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(value),
        action: SnackBarAction(
            label: "Parar Compartilhamento para ${onibus}", onPressed: () {}),
      ),
    );
  }

  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: AlertDialog(
          title: new Text("Adicione uma descrição"),
          content: Form(
            key: _key,
            autovalidate: _autovalidate,
            child: Column(
              children: <Widget>[
                TextFormField(
                  //validator: validateName,
                  decoration:
                      InputDecoration(hintText: 'Descrição...sentido...'),
                  maxLength: 12,
                  onSaved: (val) {
                    descricao = val;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Aceitar"),
              onPressed: () {
                if (_key.currentState.validate()) {
                  if (onibus != null) {
                    print("oi");
                    teste();
                    oi = !oi;
                  }
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    _autovalidate = true;
                  });
                }
              },
            ),
          ],
        ));
      },
    );
  }

  void _showDialog2(contexto, String novalinha) {
    print("aqui2");
    // flutter defined function
    showDialog(
      context: contexto,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: AlertDialog(
          title: new Text("Trocar de linha?"),
          content: Text(
              "Você esta compartilhando sua localização em ${onibus}, deseja trocar de linha?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
                child: new Text("Sim"),
                onPressed: () {
                  setState(() {
                    oi = false;
                    onibus = novalinha;
                  });
                  Navigator.of(context).pop();
                }),
          ],
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets;
    if (oi == true) {
      if (delay == false) {
        delay = true;
        Future.delayed(const Duration(seconds: 4), () {
          atualizaPosicao();
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
      markers: markers,
    );

    widgets = [
      //child: SizedBox(height: 300.0, child: googleMap),
      googleMap
    ];

    /* widgets.add(new Center(
        child: new Text(_startLocation != null
            ? 'Localização inicial: ${_startLocation
            .latitude} & ${_startLocation.longitude}\n'
            : 'Error: $error\n')));

    widgets.add(new Center(
        child: new Text(
            _currentLocation != null
                ? 'Localizacao indo: \nlat: ${_currentLocation
                .latitude} & long: ${_currentLocation
                .longitude} \nalt: ${_currentLocation.altitude}m\n'
                : 'Error: $error\n',
            textAlign: TextAlign.center)));*/

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

    return new Scaffold(
      drawer: FractionallySizedBox(
          widthFactor: 0.8,
          child: new Drawer(
              elevation: 2,
              child: StreamBuilder(
                  stream: Firestore.instance.collection('onibus').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        initialCameraPosition: _initialCamera,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        markers: markers,
                      );
                    } else {
                      if (!snapshot.hasData) {
                        return GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          initialCameraPosition: _initialCamera,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          markers: markers,
                        );
                      } else {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            FutureBuilder(
                                future:  FirebaseAuth.instance.currentUser(),
                                builder: (context,
                                    AsyncSnapshot<FirebaseUser> snapshot) {
                                    return Column(children: <Widget>[
                                      new UserAccountsDrawerHeader(
                                        accountName: new Text(
                                            snapshot.data.displayName,
                                            style: TextStyle(
                                                color: Colors.grey[50],
                                                fontWeight: FontWeight.bold)),
                                        accountEmail: new Text(
                                          snapshot.data.email,
                                          style:
                                              TextStyle(color: Colors.grey[50]),
                                        ),
                                        currentAccountPicture: new CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              snapshot.data.photoUrl),
                                          // backgroundColor: Colors.black26,
                                        ),
                                        decoration: new BoxDecoration(
                                            color: Colors.orange[800]),
                                        otherAccountsPictures: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              authService.signOut();
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyApp()),
                                                  ModalRoute.withName("/Home"));
                                            },
                                            child:
                                                // Image(image: NetworkImage("https://www.materialui.co/materialIcons/action/exit_to_app_black_192x192.png"),),
                                                Icon(
                                              Icons.exit_to_app,
                                              color: Colors.white,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                            ),
                                          )
                                        ],
                                      ),
                                    ]);
                                }),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot mypost =
                                      snapshot.data.documents[index];
                                  return Column(
                                    children: <Widget>[
                                      GestureDetector(
                                          onTap: () {
                                            //  if((oi == true)&&(onibus != mypost['title'])){

                                            setState(() {
                                              onibus = mypost['title'];
                                            });

                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                              /*  color:
                            (index % 2 == 0) ? Colors.white10 : Colors.grey[50],*/
                                              child: Text(mypost['title']))),
                                    ],
                                  );
                                }),
                          ],
                        );
                      }
                    }
                  }))),
      appBar: new AppBar(
        title: (onibus == null) ? Text('Selecione um onibus') : Text(onibus),
      ),
      body: (onibus != null)
          ? StreamBuilder(
              stream: Firestore.instance
                  .collection('onibus')
                  .document(onibus)
                  .collection('logs')
                  .snapshots(),
              builder: (context, snapshot) {
                try {
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
                        if (cloudDate.isBefore(DateTime.now())) {
                          // print("vencido");
                        } else {
                          markers.add(
                            Marker(
                                markerId: MarkerId(mypost['user']),
                                position: LatLng(mypost['location'].latitude,
                                    mypost['location'].longitude),
                                infoWindow: InfoWindow(title: "teste")),
                          );
                        }
                      }
                      return GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        initialCameraPosition: _initialCamera,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        markers: markers,
                      );
                    }
                  }
                } catch (e) {
                  print(e);
                  return Center(child: CircularProgressIndicator());
                }
              })
          : GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: _initialCamera,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: markers,
            ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          if (onibus != null) {
            print("oi");
            if (oi == true) {
              delete();
              oi = !oi;
            } else {
              _showDialog(context);
            }
          }
        },
        tooltip: 'Stop Track Location',
        child: (oi == true)
            ? Text(
                onibusCompartilha,
                style: TextStyle(color: Colors.white),
              )
            : Icon(Icons.directions_bus),
        backgroundColor: (oi == true) ? Colors.green : Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  teste() async {
    onibusCompartilha = onibus;
    print("envia");

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    print(user.uid);
    var data = {
      "image":
          "https://st.depositphotos.com/3538103/5175/i/950/depositphotos_51751599-stock-photo-bus-icon.jpg",
      "coords": GeoPoint(_currentLocation.latitude, _currentLocation.longitude),
    };

    var dataBus = {
      "user": user.uid,
      "location":
          GeoPoint(_currentLocation.latitude, _currentLocation.longitude),
      "date": Timestamp.fromDate(DateTime.now().add(Duration(hours: 1))),
      "report": 0
    };

    _firestore
        .collection('onibus')
        .document(onibusCompartilha)
        .collection('logs')
        .document(user.uid)
        .setData(dataBus);
    _firestore
        .collection('users')
        .document(user.uid)
        .setData({"atual": onibusCompartilha












    }, merge: true);
    _firestore
        .collection('users')
        .document(user.uid)
        .collection('coord')
        .document('coord')
        .setData(data, merge: true);
  }

  delete() async {
    print("envia");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    print(user.uid);
    _firestore
        .collection('onibus')
        .document(onibus)
        .collection('logs')
        .document(user.uid)
        .delete();
  }

  expira() async {
    print("envia");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    print(user.uid);
    _firestore
        .collection('onibus')
        .document(onibus)
        .collection('logs')
        .document(user.uid)
        .get()
        .then((valor) {});
  }

  atualizaPosicao() async {
    print("envia");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    print(user.uid);
    var data = {
      "image":
          "https://st.depositphotos.com/3538103/5175/i/950/depositphotos_51751599-stock-photo-bus-icon.jpg",
      "coords": GeoPoint(_currentLocation.latitude, _currentLocation.longitude),
    };

    var dataBus = {
      "user": user.uid,
      "location":
          GeoPoint(_currentLocation.latitude, _currentLocation.longitude),
    };

    _firestore
        .collection('onibus')
        .document(onibusCompartilha)
        .collection('logs')
        .document(user.uid)
        .get()
        .then((valor) {
      print(valor['date']);
    });

    _firestore
        .collection('onibus')
        .document(onibusCompartilha)
        .collection('logs')
        .document(user.uid)
        .updateData(dataBus);
    _firestore
        .collection('users')
        .document(user.uid)
        .setData({"atual": onibusCompartilha}, merge: true);
    _firestore
        .collection('users')
        .document(user.uid)
        .collection('coord')
        .document('coord')
        .setData(data, merge: true);
  }

  Widget loadMap() {
    return StreamBuilder(
        stream: Firestore.instance.collection('markers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Load');
          for (int i = 0; i < snapshot.data.documents.lenght; i++) {}
        });
  }
}
