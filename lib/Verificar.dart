import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
class Verificar extends StatefulWidget {
  @override
  _VerificarState createState() => _VerificarState();
}

class _VerificarState extends State<Verificar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Verificando"),),
      body: StreamBuilder(
          stream: Firestore.instance.collection('Aguardando').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData) {
                const Text('loading');
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot mypost =
                    snapshot.data.documents[index];
print(mypost['image']);
                    // print(DateTime.now().microsecondsSinceEpoch);
                    //var date = DateTime.fromMillisecondsSinceEpoch(mypost['validade']);
                    return  GestureDetector(
                        onTap: () {
                          _showDialog(mypost.documentID);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03, left: MediaQuery.of(context).size.width * 0.03),
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                  padding:
                                  EdgeInsets.only(top: 8, bottom: 8),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(40.0),
                                    child: Material(
                                      color: Colors.grey[200],
                                      elevation: 14,
                                      shadowColor: Color(0x802196f3),
                                      child: Center(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              width:
                                              MediaQuery.of(context).size.width, height: 200,
                                              child: CachedNetworkImage(
                                                imageUrl: "${mypost['image']}",
                                                placeholder: (context, url) => new CircularProgressIndicator(),
                                                errorWidget: (context, url, error) => new Icon(Icons.error),
                                                fadeOutDuration: new Duration(seconds: 1),
                                                fadeInDuration: new Duration(seconds: 3),
                                              ),

                                              /* Image.network(
                                        '${mypost['image']}',
                                        fit: BoxFit.fill,
                                      ),*/
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(
                                                  MediaQuery.of(context).size.width * 0.03),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        '${mypost['nomeDaArvore']}',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                          '${mypost['descricao']}')
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .end,
                                                    children: <Widget>[
                                                      Text('Enviado Por: ',
                                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
                                                      ),
                                                      Text(
                                                        '${mypost['email']}',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: Colors
                                                                .green),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Icon(Icons.add)
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        ),

                    );
                  },
                );
              }
            }
          }),
    );
  }
  void _showDialog(id) {
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
                    _Aceitar(id);
                  },
                ),
              ],
            ));
      },
    );
  }
}
_Aceitar(id){
  final Firestore _firestore = Firestore.instance;
  DateTime test = DateTime(2019, 4, 24, 23);
  Firestore.instance.runTransaction(
          (Transaction transaction) async {
        _firestore.collection('Aguardando').document(id).updateData({"aprovado": true});
      });

}

