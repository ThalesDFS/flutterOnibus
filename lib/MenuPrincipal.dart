import 'package:flutter/material.dart';
import 'AdicionarArvore.dart';
import 'Escolha.dart';
import 'package:flutter_google_pay/flutter_google_pay.dart';
import 'zero.dart';
import 'package:involucrata/zero.dart';
import 'AdicionarArvore.dart';
import 'package:involucrata/AdicionaMapa.dart';
import 'package:involucrata/Arvores/Mapa.dart' as teste;
import 'package:involucrata/examplo.dart';
import 'saves.dart';
import 'package:involucrata/Verificar.dart';
import 'package:involucrata/Jogo.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class MenuPrincipal extends StatefulWidget {
  @override
  _MenuPrincipalState createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {

  @override
  void initState() {
    logIn();
    // TODO: implement initState
    super.initState();
  }
  void _showToast(BuildContext context, String key) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('O item $key foi removido, tente novamente'),
        action: SnackBarAction(
            label: 'Fechar', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdicionarArvore()));
          },child: Text("Adicionar Arvores")),
          RaisedButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => teste.MyApp2()));
          },child: Text("Mapa das arvores")),
          RaisedButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => qrcodes()));
          },child: Text("saves"),),
          RaisedButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Verificar()));
          },child: Text("Verificar"),),
          RaisedButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyApp2()));
          },child: Text("onibus"),),
          RaisedButton(onPressed: () async{
            print("iniciou");
            await logIn();
            print("passou");
          },child: Text("API"),),
         /* RaisedButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Verificar()));
          },child:Text("verificar")),
          RaisedButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Jogo()));
          },child:Text("verificar")),*/
      ],)),
    );
  }
}

void logIn() async {
 // var url = "https://en.wikipedia.org/w/api.php?action=opensearch&search=Platanus_×_hispanica&limit=1&format=json";
 // var url = "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=Craig%20Noone&format=json";
  //var url = "http://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&format=json&titles=Eugenia involucrata&rvsection=0";
 // var url = "http://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&format=json&titles=Eugenia%20involucrata&rvsection=0";
 var url = "https://pt.wikipedia.org/w/api.php?action=query&list=categorymembers&cmtitle=Categoria:Famílias_botânicas&cmlimit=1000&format=json";

  // Await the http get response, then decode the json-formatted response.

  var response = await http.get(url);
  print(response.toString());
  if (true) {
    var jsonResponse = convert.jsonDecode(response.body);
   // var itemCount = jsonResponse['totalItems'];
    //print("http: ${jsonResponse["query"]["categorymembers"][49]} acabou");
    print("tamanho:");

    print(jsonResponse["query"]["categorymembers"].length);
    for (var n in jsonResponse["query"]["categorymembers"]){
      print(n["title"]);
      print("teste");
    }
  } else {
    print("Request failed with status: ${response.statusCode}.");
  }
  //return teste;
}
