import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  Set<Marker> _markers = {};

  GoogleMapController? _controller;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps"),
        actions: [
          IconButton(
            onPressed: () async {
              Position currentPosition = await _determinePosition();
              _markers.add(
                Marker(
                  markerId: MarkerId("${_markers.length + 1}"),
                  position: LatLng(
                      currentPosition.latitude, currentPosition.longitude),
                ),
              );

              setState(() {});
              _controller!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(
                        currentPosition.latitude, currentPosition.longitude),
                    zoom: 20,
                  ),
                ),
              );
            },
            icon: Icon(Icons.location_pin),
          ),
          IconButton(
            onPressed: () async {
              await _controller!.animateCamera(
                CameraUpdate.zoomTo(10),
              );
              await Future.delayed(Duration(seconds: 1));
              await _controller!.animateCamera(
                CameraUpdate.newCameraPosition(
                  const CameraPosition(
                    target: LatLng(25.0684873, 34.8429024),
                    zoom: 10,
                  ),
                ),
              );
              await Future.delayed(Duration(seconds: 1));

              await _controller!.animateCamera(
                CameraUpdate.zoomTo(14),
              );
            },
            icon: const Icon(Icons.location_city),
          ),
          IconButton(
            onPressed: () {
              _controller!.animateCamera(CameraUpdate.zoomOut());
            },
            icon: Icon(Icons.minimize),
          ),
          IconButton(
            onPressed: () {
              _controller!.animateCamera(CameraUpdate.zoomIn());
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _controller = controller;
        },
        onTap: (argument) {
          _markers.add(
            Marker(
              markerId: MarkerId("${_markers.length + 1}"),
              position: argument,
            ),
          );

          setState(() {});
        },
        markers: _markers,
        polylines: {
          Polyline(
            color: Colors.blue,
            width: 2,
            polylineId: PolylineId('1'),
            points: [
              LatLng(30.0596112, 31.1758908),
              LatLng(30.057, 31.178),
            ],
          ),
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(30.0596112, 31.1758908),
          zoom: 14,
        ),
      ),
    );
  }
}
