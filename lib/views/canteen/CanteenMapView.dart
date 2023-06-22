import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:student_canteens/models/Canteen.dart';

class CanteenMapView extends StatefulWidget {
  final Canteen canteen;

  const CanteenMapView({Key? key, required this.canteen}) : super(key: key);

  @override
  _CanteenMapViewState createState() => _CanteenMapViewState(canteen: canteen);
}

class _CanteenMapViewState extends State<CanteenMapView> {
  final Canteen canteen;

  _CanteenMapViewState({required this.canteen})
      : canteenLocation = LatLng(
          double.parse(canteen.latitude),
          double.parse(canteen.longitude),
        ),
        super();

  GoogleMapController? mapController;
  LatLng canteenLocation;

  @override
  void initState() {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: canteenLocation,
          zoom: 13.0,
        ),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: canteenLocation,
        zoom: 13.0,
      ),
      onMapCreated: (controller) {
        mapController = controller;
      },
      markers: {
        Marker(
          markerId: MarkerId(canteen.id.toString()),
          position: canteenLocation,
          infoWindow: InfoWindow(
            title: canteen.name,
            snippet: canteen.address,
          ),
        ),
      },
      gestureRecognizers: {
        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
      },
    );
  }
}
