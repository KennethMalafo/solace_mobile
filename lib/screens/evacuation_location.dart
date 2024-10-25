import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EvacuationLocation extends StatefulWidget {
  const EvacuationLocation({super.key});

  @override
  EvacuationLocationState createState() => EvacuationLocationState();
}

class EvacuationLocationState extends State<EvacuationLocation> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {}; // Store markers
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = position;
        // Add the user's current location marker (Blue color)
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'Your Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure, // Blue color for current location
            ),
          ),
        );
        // After getting user location, add other markers
        _addMarkers();
      });

      // Adjust camera position to show all markers
      _adjustCameraToFitMarkers();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Method to add multiple markers (Red color for other markers)
  void _addMarkers() {
    setState(() {
      _markers.addAll([
        Marker(
          markerId: const MarkerId('evacuation site 1'),
          position: const LatLng(15.978444, 120.473362), // Example marker
          infoWindow: const InfoWindow(title: 'Minien East/West', snippet: 'Minien National High School'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed, // Red color for other markers
          ),
        ),
        Marker(
          markerId: const MarkerId('evacuation site 2'),
          position: const LatLng(15.987080, 120.450732), // Example marker
          infoWindow: const InfoWindow(title: 'Maticmatic evacuation site', snippet: 'Maticmatic Elementary School'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed, // Red color for other markers
          ),
        ),
        Marker(
          markerId: const MarkerId('evacuation site 3'),
          position: const LatLng(15.980294, 120.468020), // Example marker
          infoWindow: const InfoWindow(title: 'Tebag East evacuation site', snippet: 'Tebag East Day Care Center'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed, // Red color for other markers
          ),
        ),
        Marker(
          markerId: const MarkerId('evacuation site 4'),
          position: const LatLng(16.00364, 120.45218), // Example marker
          infoWindow: const InfoWindow(title: 'erfe evacuation site', snippet: 'Daroy Elementary School'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed, // Red color for other markers
          ),
        ),
      ]);
    });
  }

  // Adjust the camera to fit all markers (including current location)
  Future<void> _adjustCameraToFitMarkers() async {
    if (_markers.isEmpty) return;

    LatLngBounds bounds;
    final List<LatLng> markerPositions = _markers.map((marker) => marker.position).toList();

    // Calculate bounds
    if (markerPositions.length == 1) {
      bounds = LatLngBounds(
        southwest: markerPositions.first,
        northeast: markerPositions.first,
      );
    } else {
      final southwestLat = markerPositions.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
      final southwestLng = markerPositions.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
      final northeastLat = markerPositions.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
      final northeastLng = markerPositions.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);
      bounds = LatLngBounds(
        southwest: LatLng(southwestLat, southwestLng),
        northeast: LatLng(northeastLat, northeastLng),
      );
    }

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50)); // Adjust padding (50) as necessary
  }

 @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent, // Make the AppBar transparent
      elevation: 0,  // Remove shadow
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Sol",
            style: TextStyle(
              fontSize: screenWidth * 0.08,
              color: Colors.blue[900],
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.07,
              maxHeight: screenHeight * 0.1,
            ),
            child: Image.asset(
              'images/a_logo.png',
              fit: BoxFit.contain,
            ),
          ),
          Text(
            'ce RiverWatch',
            style: TextStyle(
              fontSize: screenWidth * 0.08,
              color: Colors.blue[900],
            ),
          ),
        ],
      ),
    ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 14,
              ),
              markers: _markers,
              myLocationEnabled: true, // Show the user's current location
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
    );
  }
}