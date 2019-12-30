import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'cord.dart';
import 'package:image/image.dart' as saveimage;
import 'package:image_picker_saver/image_picker_saver.dart' as parasalvar;
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:load/load.dart';
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
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker_saver/image_picker_saver.dart' as blah;
import 'package:album_saver/album_saver.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;
import 'package:shared_preferences/shared_preferences.dart';
import 'MenuPrincipal.dart';

class qrcodes extends StatefulWidget {
  @override
  qrcodes({Key key, this.title}) : super(key: key);
  int title;

  _qrcodesState createState() => _qrcodesState();
}

File _image;

class _qrcodesState extends State<qrcodes> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _counter;
  var pedidos3 = [];

  Future<int> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    // final int counter = (prefs.getInt('counter') ?? 0) + 1;
    setState(() {
      if (prefs.getStringList('arvores') != null) {
        for (int i = 0; i < prefs.getStringList('arvores').length; i++) {
          pedidos3.add(jsonDecode(prefs.getStringList('arvores')[i]));
        }
        return pedidos3.length;
      } else {
        pedidos3 = [];
      }
    });
  }

  Future<void> deleteAll() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    preferences.remove("arvores".toString());
    _incrementCounter();
  }

  void initState() {
    super.initState();
    _incrementCounter();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    // _incrementCounter();
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.orange[800],
          title:
              Text("Meu Catálogo", style: TextStyle(color: Colors.grey[50])),
          iconTheme: IconThemeData(color: Colors.grey[50]),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                deleteAll();
              },
              icon: Icon(Icons.delete_forever),
            )
          ],
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: pedidos3.length,
            itemBuilder: (context, index) {
              if (pedidos3 == null) {
                return CircularProgressIndicator();
              } else {
                return Container(
                    margin: const EdgeInsets.only(top:15.0),
                    child: Column(
                      children: <Widget>[
                       /*Container(
                            // margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("Nome:" +
                                    pedidos3[index]['nome'].toString()),
                                Text(
                                    "${pedidos3[index]['image'].toString()}.jpg"),
                                Text(
                                    "${pedidos3[index]['sincronizado'].toString()}"),
                                //   Text("cartao "+globals.pedidos3[index]['Cartao'].toString()),
                              ],
                            )),*/
                        // Text(globals.coisaslocal[index].toString().replaceAll("[", "").replaceAll("]", ""), style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),
                        // ),
                        // Text(jsonEncode(globals.pedidos3[index])), //Mostra o qr code
                        FutureBuilder(
                            future: _getLocalFile(
                                '${pedidos3[index]['image'].toString()}.jpg'),
                            builder: (BuildContext context,
                                AsyncSnapshot<File> snapshot) {
                              if (snapshot.hasData) {
                                _image = snapshot.data;
                                return Center(
                                    child: Column(
                                  children: <Widget>[
                                 /*   Image.file(_image),
                                    RaisedButton(
                                        onPressed: () {
                                          _delete(index);
                                        },
                                        child: Text("deletar")),
                                    RaisedButton(
                                        onPressed: () async {

                                        },
                                        child: Text("enviar")),*/
                                    ListTile(
                                        title: Text("Nome: ${pedidos3[index]['nome'].toString()}"),
                                        subtitle: (pedidos3[index]['sincronizado'] == true)?Text("Status: Já enviado",style: TextStyle(color: Colors.greenAccent),):Text("Status: Pronto Para enviar",style: TextStyle(color: Colors.redAccent),),
                                        leading: Image.file(_image),
                                        trailing: Wrap(direction: Axis.vertical,children: <Widget>[IconButton(icon: Icon(Icons.delete), onPressed: (){_delete(index);}),Visibility(visible: (pedidos3[index]['sincronizado'] == true)?false:true,child: RaisedButton(color: Colors.lightGreenAccent,splashColor: Colors.green,onPressed: ()async{_Enviar(index);},child: Text("Enviar"),))],),
                                        onTap: () {
                                        }),
                                    // You can use a provider from Random.})
                                  ],
                                ));
                              } else {
                                return Text("fim");
                              }
                            })
                      ],
                    ));
              }
            }));


  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: AlertDialog(
              title: new Text("Sucesso!"),
              content: Column(children: <Widget>[

                Text("Sua arvore foi enviada para o sistema, e, se tudo estiver ok, em até 24hrs ela já vai estar no mapa global!"),

              ],),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Ok"),
                  onPressed: () {
Navigator.of(context).pop();
                  },
                ),
              ],
            ));
      },
    );
  }
_Enviar(index) async{
  showLoadingDialog();
  try{
    File imagem = await _getLocalFile("${pedidos3[index]['image'].toString()}.jpg").then((file){
      return file;
    });
    print(imagem.toString());
    print(pedidos3[index]['lat']);
    StorageReference ref = FirebaseStorage.instance.ref().child(path.basename(imagem.path));
    StorageUploadTask uploadTask = ref.putFile(imagem);
    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();
    print("Download URL : $url");
//IMAGE
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    DateTime test = DateTime(2019, 4, 24, 23);
    var data = {
      "aprovado": false,
      "Nativa": false,
      "Mata": false,
      "Identificada": false,
      "image": url,
      "nomeDaArvore": pedidos3[index]['nome'].toString(),
      "descricao": "padrao",
      "coord": GeoPoint(pedidos3[index]['lat'], pedidos3[index]['long']),
      "userUid": user.uid,
      'email': user.email,
      'nome': user.displayName,
      'data': Timestamp.fromDate(
          DateTime.now())
    };
    Firestore.instance.runTransaction(
            (Transaction transaction) async {
          _firestore.collection('Aguardando').add(data);
          _AtualizaStatus(index);
        });}catch(e){

  }
  hideLoadingDialog();
  _showDialog();
}
  _delete(index) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      pedidos3.removeAt(index);
      final List<String> conter = [];
      for (int i = 0; i < pedidos3.length; i++) {
        conter.add(jsonEncode(pedidos3.elementAt(i)));
      }
      prefs.setStringList("arvores", conter);
    });
  }
  _AtualizaStatus(index) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      pedidos3[index]['sincronizado'] = true;
      final List<String> conter = [];
      for (int i = 0; i < pedidos3.length; i++) {
        conter.add(jsonEncode(pedidos3.elementAt(i)));
      }
      prefs.setStringList("arvores", conter);
    });
  }
}

Future<File> _getLocalFile(String filename) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  File f = new File('$dir/$filename');
  return f;
}
 var loading = LoadingProvider(
   themeData: LoadingThemeData(),
   loadingWidgetBuilder: (ctx, data) {
     return Center(
       child: SizedBox(
         width: 30,
         height: 30,
         child: Container(
           child: CupertinoActivityIndicator(),
           color: Colors.blue,
         ),
       ),
     );
   },
 );