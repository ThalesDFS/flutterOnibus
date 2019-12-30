import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
//import 'package:bar2/atualizaBar.dart';
class Arvores extends StatefulWidget {
  @override
  _ArvoresState createState() => _ArvoresState();
}

class _ArvoresState extends State<Arvores> {
  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(-30.0731802, -51.1227653),
    zoom: 15.73,
  );

  void _showModalSheet(context) {
    showModalBottomSheet(context: context, builder: (builder) {
      return Column(children: <Widget>[
        Center(child: Text("Adicione uma foto de sua arvore")),
        
      ],);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Arvores"),actions: <Widget>[
        IconButton(icon: Icon(Icons.add), onPressed: (){
          _showModalSheet(context);

        })
      ],),
      body: GoogleMap(initialCameraPosition: _initialCamera),
    );
  }
}
