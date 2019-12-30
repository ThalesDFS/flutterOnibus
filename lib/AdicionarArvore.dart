import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'cord.dart';
import 'package:image/image.dart' as saveimage;
import 'package:image_picker_saver/image_picker_saver.dart' as parasalvar;
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
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
import 'package:path/path.dart' as path;
import 'MenuPrincipal.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_saver/image_picker_saver.dart' as blah;
import 'package:album_saver/album_saver.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;
import 'package:shared_preferences/shared_preferences.dart';
import 'MenuPrincipal.dart';
class AdicionarArvore extends StatefulWidget {
  @override
  _AdicionarArvoreState createState() => _AdicionarArvoreState();
}

File _image;
String randomicoteste;
String cardHolderName = '';
String informacaoExtra = '';
class _AdicionarArvoreState extends State<AdicionarArvore> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
    if(_image != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Confirmar()));
    }
  }

  Future getImageGaleria() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    if(_image != null){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Confirmar()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Foto"),
      ),
      body: SingleChildScrollView(
          child: Container(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
              child: Column(
                children: <Widget>[
                  Text(
                    "Primeiro, adicione uma foto de sua Àrvore:",
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.09),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                              onPressed: () {
                                getImageCamera();
                              },
                              child: Text("Camera")),
                          RaisedButton(
                              onPressed: () {
                                getImageGaleria();
                              },
                              child: Text("Galeria")),
                        ],
                      )))
                ],
              ))),
    );
  }
}

class Confirmar extends StatefulWidget {
  @override
  _ConfirmarState createState() => _ConfirmarState();
}

class _ConfirmarState extends State<Confirmar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirmar Imagem"),
      ),
      body: ListView(children: <Widget>[
        Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
            child: Column(
              children: <Widget>[
                Text(
                  "Ficou boa?",
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.09),
                    child: Center(
                        child: Container(
                      width: 300,
                      height: 150,
                      child: _image == null
                          ? Center(child: Text("sem imagem"))
                          : uploadArea(context),
                    )))
              ],
            )),
        Center(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _image = null;
                Navigator.of(context).pop();
              },
              child: Text("Tirar outra"),
            ),
            RaisedButton(
              onPressed: () async{
                print("aqui");
                Directory appDocDir = await getApplicationDocumentsDirectory();
                randomicoteste = randomAlphaNumeric(10);
                print(randomicoteste);
                String bgPath = appDocDir.uri.resolve("${randomicoteste}.jpg").path;
                File bgFile = await _image.copy(bgPath);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Dados()));
              },
              child: Text("Sim"),
            ),
          ],
        ))
      ]),
    );
  }
}

Widget uploadArea(context) {
  return Column(
    children: <Widget>[
      Image.file(
        _image,
        height: 150,
      ),
    ],
  );
}





class Dados extends StatefulWidget {
  @override
  _DadosState createState() => _DadosState();
}

class _DadosState extends State<Dados> {
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nome da Arvore"),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
            child: Column(
              children: <Widget>[
                Text(
                  "Por qual nome você conhecê esta arvore?",
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.09),
                    child: Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin:
                            const EdgeInsets.only(left: 16, top: 8, right: 16),
                        child: TextFormField(
                          controller: _cardHolderNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Card Holder',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Digite o seu nome  no cartao';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                        ),
                      ),

                    )),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.09),
              child:
              RaisedButton(onPressed:  (){
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => (teste())));},child:Text("Confirmar")))
              ],
            )),
      ),
    );
  }
}

class InformacaoExtra extends StatefulWidget {
  @override
  _InformacaoExtraState createState() => _InformacaoExtraState();
}

class _InformacaoExtraState extends State<InformacaoExtra> {
  final TextEditingController _cardHolderNameController =
  TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    _cardHolderNameController.addListener(() {
      setState(() {
        informacaoExtra = _cardHolderNameController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Algo mais?"),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
            child: Column(
              children: <Widget>[
                Text(
                  "Alguma informação que você queira dividir com a gente?",
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.09),
                    child: Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin:
                        const EdgeInsets.only(left: 16, top: 8, right: 16),
                        child: TextFormField(
                          controller: _cardHolderNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Card Holder',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Digite o seu nome  no cartao';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                        ),
                      ),

                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.09),
                    child:
                    RaisedButton(onPressed: (){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => teste(imagem: _image,Descricao: informacaoExtra,NomeDaArvore: cardHolderName,)));
                    },child:Text("Confirmar")))
              ],
            )),
      ),
    );
  }
}

class TestandoSave extends StatefulWidget {
  @override
  _TestandoSaveState createState() => _TestandoSaveState();
}

class _TestandoSaveState extends State<TestandoSave> {

  @override
  Widget build(BuildContext context) {

    return
      FutureBuilder(future: _getLocalFile('${randomicoteste}.jpg'),builder:  (BuildContext context, AsyncSnapshot<File> snapshot){
        if(snapshot.hasData){
_image = snapshot.data;
        return Center(child:Column(children: <Widget>[
          Image.file(_image),
          RaisedButton(onPressed: (){print(randomString(10));}) // You can use a provider from Random.})
        ],)

        );
      }else {
          return Text("fim");
        }
    });
    }



  }

Future<File> _read() async {
  File text;
  try {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory.path}/background.jpg');
    text = (await file.readAsString()) as File;
  } catch (e) {
    print(e);
  }
  return text;
}
Future<File> _getLocalFile(String filename) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  File f = new File('$dir/$filename');
  return f;
}




class teste extends StatefulWidget {
  @override
  _testeState createState() => _testeState();
  teste({Key key, this.NomeDaArvore, this.Descricao,this.imagem,}) : super(key: key);
  final String NomeDaArvore;
  final String Descricao;
  final File imagem;

}


class _testeState extends State<teste> {
  PersistentBottomSheetController _controller25;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  // String nomeMarca = _testeState().widget.NomeDaArvore;
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
      body:
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
                        child:

                        Image.file(
                          widget.imagem,

                        ),
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
                  title: widget.NomeDaArvore
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(

        onPressed: () async {
          setState(() {
            _showDialog();
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


  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: AlertDialog(
              title: new Text("Finalizar"),
              content: Column(children: <Widget>[

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
                    enviar();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => MenuPrincipal()));
                  },
                ),
              ],
            ));
      },
    );
  }

  void enviar() async{


    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    print(cardHolderName);
    Map<String,dynamic> datar = {
      "image": randomicoteste,
      "nome": cardHolderName,
      "sincronizado": false,
      "lat": latLngCamera.latitude,
      "long": latLngCamera.longitude
    };
    var pedidos2 = <Map>[];
    if (prefs.getStringList('arvores') != null) {
      //O cache é todo salvo em uma Lista de strings, Cada string é um json
      print("ja foi");
      for (int i = 0; i < prefs.getStringList('arvores').length; i++) {
        //Copia todos jsons salvos para "globals.pedidos2", convertendo para json
        //pega matriz com todos pedidos ja feitos
        pedidos2.add(jsonDecode(prefs.getStringList('arvores')[i]));
        print("passou");
      }
      // globals.pedidos2 = jsonDecode(prefs.getStringList('counter')[2]); //pega atual transforma em map
      print("hui${pedidos2}");
      print("vamos ver");
      pedidos2.add(datar);

      final List<String> conter = [];
      for (int i = 0; i < pedidos2.length; i++) {
        //converte esse json para uma lista de string novamente, e armazena em "conter"
        //salva
        conter.add(jsonEncode(pedidos2.elementAt(i)));
      }
      prefs.setStringList("arvores", conter); //salva em com o id que eu uso "counterfiiii"
    } else {
      //Caso seja a primeira ver que alguem vai adicionar um item (QR code com a compra), no cache
      final List<String> conter = [];
      print("aqueer");
      conter.add(jsonEncode(datar));
      prefs.setStringList("arvores", conter);
    }

  }


}
