import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? mapController;
  LatLng center = const LatLng(44.891630, 16.476338);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // app bar
        SliverAppBar(
          centerTitle: true,
          surfaceTintColor: Colors.grey[900],
        ),

        // map
        SliverFillRemaining(
          child: GoogleMap(
            mapType: MapType.normal,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            initialCameraPosition: CameraPosition(
              target: center,
              zoom: 6.5,
            ),
            onMapCreated: (controller) {
              mapController = controller;
            },
            markers: {},
            gestureRecognizers: {
              Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer())
            },
          ),
        ),
      ],
    );
  }
}
