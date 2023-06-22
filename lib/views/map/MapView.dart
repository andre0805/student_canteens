import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/views/canteen/CanteenView.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final GCF gcf = GCF.sharedInstance;

  GoogleMapController? mapController;
  LatLng center = const LatLng(44.891630, 16.476338);
  bool isLoading = false;

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();

    updateWidget(() {
      isLoading = true;
    });

    Future.wait([
      gcf.getCanteens(),
    ]).then((values) {
      updateWidget(() {
        markers = values[0].map((canteen) {
          return Marker(
            markerId: MarkerId(canteen.id.toString()),
            position: LatLng(
              double.parse(canteen.latitude),
              double.parse(canteen.longitude),
            ),
            infoWindow: InfoWindow(
              title: canteen.name,
              snippet: canteen.address,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CanteenView(
                      canteen: canteen,
                      parentRefreshWidget: () {},
                    ),
                  ),
                );
              },
            ),
          );
        }).toSet();
        isLoading = false;
      });
    });
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

        // loading indicator
        SliverVisibility(
          visible: isLoading,
          sliver: const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),

        // map
        SliverVisibility(
          visible: !isLoading,
          sliver: SliverFillRemaining(
            child: GoogleMap(
              mapType: MapType.normal,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              padding: const EdgeInsets.all(20),
              initialCameraPosition: CameraPosition(
                target: center,
                zoom: 6.5,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              markers: markers,
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer())
              },
            ),
          ),
        )
      ],
    );
  }

  void updateWidget(VoidCallback callback) {
    if (mounted) setState(callback);
  }
}
