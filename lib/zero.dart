import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Zero extends StatefulWidget {
  @override
  _ZeroState createState() => _ZeroState();
}

class _ZeroState extends State<Zero> {
  PersistentBottomSheetController _controller25;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  //String nomeMarca = _testeState().widget.NomeDaArvore;
  Map<String, double> currentLocation = Map();
  StreamSubscription<Map<String, double>> streamSubscription;
  Location location = Location();

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controllerAddress = TextEditingController();
  double zoomCamera;
  LatLng latLngCamera=new LatLng(-17.55135, -54.1800302);
  @override
  void initState() {
    super.initState();
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-17.55135, -54.1800302),
    zoom: 2.93,
  );
  @override
  Widget build(BuildContext context) {
    print("okokokokok");
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(title: Text("Onde está a Arvore?"),),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            markers: Set<Marker>.of(
              <Marker>[
                Marker(
                  onTap: (){
                    /* mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(, ))))*/
                    _controller25 = _scaffoldkey.currentState
                        .showBottomSheet<void>((BuildContext context) {
                      return GestureDetector(onTap: (){

                      },child:Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            // width: MediaQuery.of(context).size.width * 0.4,
                            child: Text("kaka"),
                          ),
                        ],
                      ));
                    });
                  },

                  visible: true,
                  draggable: true,
                  markerId: MarkerId("1"),
                  position: latLngCamera,
                  icon: BitmapDescriptor.defaultMarker,
                  infoWindow:  InfoWindow(
                      title: "nome"
                  ),
                )
              ],
            ),
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController=controller;
            },
            onCameraMove: (value){
              print("Camere Move: ${value.zoom}");
              setState(() {
                zoomCamera=value.zoom;
                latLngCamera=value.target;
              });
            },
            onTap: (teste) {
              if (_controller25 != null) {
                _controller25.close();
                _controller25 = null;
              }
            },
          ),


        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(

        onPressed: () async {
          setState(() {
            //_showDialog();
            // _goToTheLake(latLngCamera.latitude, latLngCamera.longitude);
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.send),
      ),
    );
  }

  /* Future<String> uploadImage() async {
    //IMAGE
        StorageReference ref = FirebaseStorage.instance.ref().child(filename);
        StorageUploadTask uploadTask = ref.putFile(image);

        var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
        var url = downUrl.toString();
        print("Download URL : $url");
//IMAGE
        final FirebaseAuth _auth = FirebaseAuth.instance;
        final Firestore _firestore = Firestore.instance;
        FirebaseUser user = await _auth.currentUser();
        DateTime test = DateTime(2019, 4, 24, 23);

        var data = {
          "image": url,
          "preco": int.parse(preco),
          "subtitle": descricao,
          "validade": Timestamp.fromDate(date),
          "title": name,
          'promocional': (promocional=="Sim")?true:false
        };
        Firestore.instance.runTransaction((Transaction transaction) async {
          _firestore.collection('Bares').document(user.uid)
              .collection('Comidas')
              .add(
              data);
        });
        _key.currentState.reset();
        showInSnackBar("Pedido adicionado com Sucesso!");
  }*/


 /* void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: AlertDialog(
              title: new Text("Finalizar"),
              content: Column(children: <Widget>[
                Text("Nome: ${widget.NomeDaArvore}"),
                Text("Descricao: ${widget.Descricao}"),
                Text("Detalhes",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                Image.file(
                  widget.imagem,
                  height: 150,
                ),
                Text("Caso você não tenha internet agora, sua àrvore sera enviada assim que você se conectar, basta não fechar o app."),

              ],),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Cancelar"),
                  onPressed: () {
                    return Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Enviar"),
                  onPressed: () {

                  },
                ),
              ],
            ));
      },
    );
  }*/

/*void enviar() async{
    StorageReference ref = FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask = ref.putFile(image);

    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();
    print("Download URL : $url");
//IMAGE

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    DateTime test = DateTime(2019, 4, 24, 23);

    var data = {
      "image": url,
      "nomeDaArvore": nomeDaArvore,
      "descricao": descricao,
      "coord": GeoPoint(latLngCamera.latitude, latLngCamera.longitude),
      "userUid": user.uid,
      'email': user.email,
      'nome': user.displayName,
    };
    Firestore.instance.runTransaction((Transaction transaction) async {
      _firestore.collection('Aguardando').document(user.uid)
          .collection('Comidas')
          .add(
          data);
    });
  }*/

}
