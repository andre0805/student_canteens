import 'dart:async';

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

  Completer<GoogleMapController> _controller = Completer();
  LatLng canteenLocation;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      rotateGesturesEnabled: true,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      initialCameraPosition: CameraPosition(
        target: canteenLocation,
        zoom: 10,
      ),
      onMapCreated: (controller) {
        _controller.complete(controller);
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
