import 'package:flutter/material.dart';

class Escolha extends StatefulWidget {
  @override
  _EscolhaState createState() => _EscolhaState();
}

class _EscolhaState extends State<Escolha> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:Container(child: Center(child:Column(children: <Widget>[Text("Tela de escolha"),RaisedButton(onPressed: (){},child: Text("Sair"),),])),));
  }
}
