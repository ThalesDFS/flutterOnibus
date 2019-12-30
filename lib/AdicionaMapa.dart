import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart';
class fazer extends StatefulWidget {
  @override
  _fazerState createState() => _fazerState();
}

class _fazerState extends State<fazer> {
  Map<String, double> currentLocation = Map();
  StreamSubscription<Map<String, double>> streamSubscription;
  Location location = Location();

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controllerAddress = TextEditingController();


  double zoomCamera;
  LatLng latLngCamera=new LatLng(0.0, 0.0);

  String cityText;
  String error;
  String addressLine = '';
  String countryCode = '';
  String countryName = '';
  String postalCode = '';
  String adminArea = '';
  String subLocality = '';
  String featureName = '';
  String locality = '';
  String latlng = '';
  String url = '';

  @override
  void initState() {
    super.initState();
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;



   /* streamSubscription = location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        currentLocation = result;
      });
    });*/
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          GoogleMap(

            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            markers: Set<Marker>.of(
              <Marker>[
                Marker(
                  onTap: (){
                    /* mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(, ))))*/
                  },
                  visible: true,
                  draggable: true,
                  markerId: MarkerId("1"),
                  position: latLngCamera,
                  icon: BitmapDescriptor.defaultMarker,
                  infoWindow: const InfoWindow(
                    title: 'My Marker',
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
          ),
          Positioned(
            top: 50.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              child: Form(
                key: formKey,
                child: Card(
                  color: Colors.white,
                  elevation: 3.0,
                  child: TextFormField(
                    controller: controllerAddress,
                    style: TextStyle(fontSize: 20.0),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintText: 'Serach',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon: IconButton(
                          tooltip: "Show Password",
                          icon: Icon(Icons.my_location, color: Colors.blue,),
                          onPressed: () {
                            getLatLong(controllerAddress.text);
                            print(controllerAddress.text);
                          }),
                    ),
                    onSaved: (val) {
                      controllerAddress.text = val;
                    },
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            _goToTheLake(latLngCamera.latitude, latLngCamera.longitude);
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.location_on),
      ),
    );
  }


  Future<void> _goToTheLake(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng),
      zoom: zoomCamera,)));

    setState(() {
      latlng = lat.toString() + ", " + lng.toString();
      url = "https://www.google.co.in/maps/@" + lat.toString() + "," + lng.toString() + ",19z";
      print(url);
    });

    final coordinates = Coordinates(latLngCamera.latitude, latLngCamera.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("Address Line: " + first.addressLine);
    print("Country Code: " + first.countryCode);
    print("Country Name: " + first.countryName);

    print("Postal Code: " + first.postalCode);
    print("Admin Area: " + first.adminArea);

    print("Feature Name: " + first.featureName);
    print("Locality: " + first.locality);
    print("Sub Locality: " + first.subLocality);
    setState(() {
      addressLine = first.addressLine;
      countryCode = first.countryCode;
      countryName = first.countryName;
      postalCode = first.postalCode;
      adminArea = first.adminArea;
      featureName = first.featureName;
      locality = first.locality;
      subLocality = first.subLocality;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            locationDialog(latLngCamera.latitude, latLngCamera.longitude));
  }

  void getLatLong(String address) async  {
    var addresses = await Geocoder.local.findAddressesFromQuery(address);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");
    _goToTheLake(first.coordinates.latitude, first.coordinates.longitude);
    LatLng latLng = new LatLng(first.coordinates.latitude, first.coordinates.longitude);
    //_addMyMarker(latLng);
  }

  Widget locationDialog(double lat, double long) {
    return CupertinoAlertDialog(
      title: new Text("Current Location"),
      content: Column(
        children: [
          Text('latitude : $lat'),
          Text('longitude : $long'),
          Text("address line:- $addressLine \n country code:- $countryCode \n countryName:- $countryName \n postalCode:- $postalCode \n adminArea:- $adminArea"
              "\n locality:- $locality \n featureName:- $featureName \n subLocality:- $subLocality", style: TextStyle(fontSize: 18.0),)
        ],
      ),
      actions: <Widget>[
        new CupertinoDialogAction(
            child: const Text('Discard'),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context, 'Discard');
            }),
        new CupertinoDialogAction(
            child: const Text('Cancel'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            }),
      ],
    );
  }
}

