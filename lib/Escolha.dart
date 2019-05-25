import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';

class FireMap extends StatefulWidget {
  @override
  State createState() => FireMapState();
}

class FireMapState extends State<FireMap> {
  PersistentBottomSheetController _controller;
  GoogleMapController mapController;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  Set<Marker> markers = Set();

  build(context) {
    markers.addAll([
      Marker(
          markerId: MarkerId('value'),
          position: LatLng(24.150, -110.32),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: "kkkkk"),
          onTap: () {
            _controller = _scaffoldkey.currentState
                .showBottomSheet<void>((BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Schizolobium Parayba"),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Icon(Icons.accessibility)),
                ],
              );
            });
          }),
      Marker(
          markerId: MarkerId('value2'),
          position: LatLng(37.416000, -122.077000)),
    ]);
    return Scaffold(
        drawer: Drawer(
          child: Text("oi"),
        ),
        key: _scaffoldkey,
        appBar: AppBar(
          title: Text("iu"),
        ),
        body: Stack(children: [
          GoogleMap(
            onTap: (teste) {
              if (_controller != null) {
                _controller.close();
                _controller = null;
              }
            },
            initialCameraPosition:
                CameraPosition(target: LatLng(24.150, -110.32), zoom: 10),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            // Add little blue dot for device location, requires permission from user
            //  mapType: MapType.hybrid,
            markers: markers,
          ),
          Positioned(
              bottom: 50,
              right: 10,
              child: FlatButton(
                  child: Icon(Icons.pin_drop),
                  color: Colors.green,
                  onPressed: () {
                    setState(() {});
                  }))
        ]));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
