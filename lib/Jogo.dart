import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class Jogo extends StatefulWidget {
  @override
  _JogoState createState() => _JogoState();
}

class _JogoState extends State<Jogo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.black,child:Center(child: SizedBox(width: 250,child:TypewriterAnimatedTextKit(isRepeatingAnimation: false,duration: Duration(seconds: 20),
          onTap: () {
            print("Tap Event");
          },
          text: [
            "Seja bem vinda Suelen...",
            "Se você está preparada...",
            "Aperte o botão roxo"
          ],
          textStyle: TextStyle(
              fontSize: 25,
            color: Colors.white
          ),
          textAlign: TextAlign.start,
          alignment: AlignmentDirectional.topStart // or Alignment.topLeft
      )))),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: FloatingActionButton(onPressed: (){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Jogo2()));
    },backgroundColor: Colors.purple,),);
  }
}

class Jogo2 extends StatefulWidget {
  @override
  _Jogo2State createState() => _Jogo2State();
}

class _Jogo2State extends State<Jogo2> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:Scaffold(
        body: Container(color: Colors.black,child:Center(child: SizedBox(width: 250,child:TypewriterAnimatedTextKit(isRepeatingAnimation: true,duration: Duration(seconds: 30),
    onTap: () {
    print("Tap Event");
    },
    text: [
    "As regras deste jogo serão muito simples",
    "Basta ler a história com muita atenção...",
    "E quando for solicitado...",
      "Escolher um destino para sua vida...",
          "Aperte o botão roxo para continuar"
    ],
    textStyle: TextStyle(
    fontSize: 25,
    color: Colors.white
    ),
    textAlign: TextAlign.start,
    alignment: AlignmentDirectional.topStart // or Alignment.topLeft
    )))), floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => jogo3()));
      },backgroundColor: Colors.purple,),),onWillPop: (){_showDialog();},);
  }
  bool _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: Colors.purple,
              title: new Text("Você foi avisada",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              content:  Text("Uma vez no jogo, sempre no jogo... voltar não é uma opção",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Aceitarei meu destino",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15)),
                  onPressed: () {
                    return Navigator.of(context).pop();
                  },
                ),
              ],
            ));
      },
    );
  }
}

class jogo3 extends StatefulWidget {
  @override
  _jogo3State createState() => _jogo3State();
}

class _jogo3State extends State<jogo3> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:SafeArea(child: Scaffold(
      body: Container(color: Colors.black,child:Center(child: Column(children: <Widget>[
        Image.asset('assets/bau.png'),
        SizedBox(width: 250,child:TypewriterAnimatedTextKit(isRepeatingAnimation: true,duration: Duration(seconds: 30),
            onTap: () {
              print("Tap Event");
            },
            text: [
              "Você recebeu uma caixa de Thales\n\n",
            ],
            textStyle: TextStyle(
                fontSize: 25,
                color: Colors.white
            ),
            textAlign: TextAlign.start,
            alignment: AlignmentDirectional.topStart // or Alignment.topLeft
        ))],))), floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Jogo2()));
      },backgroundColor: Colors.purple,),)),onWillPop: (){_showDialog();},);
  }
  bool _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: Colors.purple,
              title: new Text("Você foi avisada",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              content:  Text("Uma vez no jogo, sempre no jogo... voltar não é uma opção",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Aceitarei meu destino",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15)),
                  onPressed: () {
                    return Navigator.of(context).pop();
                  },
                ),
              ],
            ));
      },
    );
  }
}

class Jogo5 extends StatefulWidget {
  @override
  _Jogo5State createState() => _Jogo5State();
}

class _Jogo5State extends State<Jogo5> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:Scaffold(
      body: Container(color: Colors.black,child:Center(child: SizedBox(width: 250,child:TypewriterAnimatedTextKit(isRepeatingAnimation: true,duration: Duration(seconds: 30),
          onTap: () {
            print("Tap Event");
          },
          text: [
            "Seu final nesse jogo mudará conforme suas escolhas",
            "Atenção: Voltar atrás não é uma opção",
            

          ],
          textStyle: TextStyle(
              fontSize: 25,
              color: Colors.white
          ),
          textAlign: TextAlign.start,
          alignment: AlignmentDirectional.topStart // or Alignment.topLeft
      )))), floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => jogo3()));
      },backgroundColor: Colors.purple,),),onWillPop: (){_showDialog();},);
  }
  bool _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: Colors.purple,
              title: new Text("Você foi avisada",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              content:  Text("Uma vez no jogo, sempre no jogo... voltar não é uma opção",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Aceitarei meu destino",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15)),
                  onPressed: () {
                    return Navigator.of(context).pop();
                  },
                ),
              ],
            ));
      },
    );
  }
}

