import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:monkey_management/controller/directions_controller.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/directions.dart';
import 'package:monkey_management/model/option.dart';
import 'package:monkey_management/model/store.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:monkey_management/view/client_view/add_update_appointment_screen.dart';
import 'package:monkey_management/view/common_view/mydialog.dart';

class StoreInfoScreen extends StatefulWidget {
  static const routeName = '/storeInfoScreen';

  @override
  State<StatefulWidget> createState() {
    return StoreInfoState();
  }
}

class StoreInfoState extends State<StoreInfoScreen> {
  Controller? con;
  Store? selctedStore;
  late GoogleMapController? googleMapController;

  late LatLng usersLocation;
  late Marker origin;
  late Marker storesLocation;
  late Directions info;

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  @override
  void dispose() {
    print("in dispose method");
    googleMapController!.dispose();
    googleMapController = null;
    super.dispose();
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    selctedStore = args['store'];
    info = args["info"];
    usersLocation = args["usersLocation"];
    origin = Marker(
        markerId: const MarkerId("UsersLocation"),
        infoWindow: const InfoWindow(title: "Your Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: usersLocation);
    storesLocation = Marker(
        markerId: const MarkerId('StoresLocation'),
        infoWindow: InfoWindow(title: "${selctedStore!.name} Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(selctedStore!.lat, selctedStore!.lng));

    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 90, right: 20),
          child: Text(
            'StoreInfo',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.5,
            child: Stack(alignment: Alignment.center, children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: usersLocation,
                  zoom: 13.5,
                ),
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
                myLocationEnabled: false,
                zoomGesturesEnabled: false,
                buildingsEnabled: false,
                onMapCreated: (controller) => {
                  googleMapController = controller,
                  googleMapController!.animateCamera(CameraUpdate.newLatLngBounds(info.bounds, 100)),
                      /*?

                        info != null
                      : CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: usersLocation,
                            zoom: 13.5,
                          ),
                        )),*/
                },
                markers: {origin, storesLocation},
                polylines: {

                    Polyline(
                      polylineId: const PolylineId('overview'),
                      color: Colors.red,
                      width: 5,
                      points: info.polylinePoints!
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList(),
                    )
                },
              ),
              Positioned(
                top: 20.0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      )
                    ],
                  ),
                  child: Text(
                    '${info.totalDistance}, ${info.totalDuration}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ]),
          ),
          Center(
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(Icons.store),
                    title: Text(selctedStore!.name),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text(selctedStore!.phone),
                  ),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text(selctedStore!.email),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on_outlined),
                    title: Text(selctedStore!.address),
                  ),
                  ElevatedButton(
                      onPressed: () => con!.handelOptions(),
                      child: Text('View Options')),
                  ElevatedButton(
                      onPressed: () => con!.openMaps(selctedStore!.address),
                      child: Text('Directions')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Controller {
  StoreInfoState state;

  Controller(this.state);

  Future<bool?> openMaps(value) async {
    await MapsLauncher.launchQuery(value);
  }

  Future<void> handelOptions() async {
    List<Option>? options;
    try {
      options = await FirebaseController.getOptions(state.selctedStore!.id);
    } catch (e) {
      MyDialog.info(
          context: state.context,
          title: 'handel options failed',
          content: e.toString());
    }

    await Navigator.pushNamed(
        state.context, AddUpdateAppointmentScreen.routeName, arguments: {
      'storeOptions': options,
      'selctedStore': state.selctedStore
    });
  }
}
