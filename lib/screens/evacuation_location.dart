import 'dart:async';
import 'dart:math';
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
  final Set<Marker> _allMarkers = {};
  final Set<Marker> _currentMarkers = {};
  Position? _currentPosition;
  bool _showMap = false;
  bool _isLoading = true;

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
        _allMarkers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'Your Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        );
        _addEvacuationMarkers();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _addEvacuationMarkers() {
    _allMarkers.addAll([
      Marker(
        markerId: const MarkerId('evacuation site 1'),
        position: const LatLng(15.978444, 120.473362),
        infoWindow: const InfoWindow(
            title: 'Minien East/West', snippet: 'Minien National High School'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
      Marker(
        markerId: const MarkerId('evacuation site 2'),
        position: const LatLng(15.987080, 120.450732),
        infoWindow: const InfoWindow(
            title: 'Maticmatic evacuation site', snippet: 'Maticmatic Elementary School'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
      Marker(
        markerId: const MarkerId('evacuation site 3'),
        position: const LatLng(15.980294, 120.468020),
        infoWindow: const InfoWindow(
            title: 'Tebag East evacuation site', snippet: 'Tebag East Day Care Center'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
      Marker(
        markerId: const MarkerId('evacuation site 4'),
        position: const LatLng(16.00364, 120.45218),
        infoWindow: const InfoWindow(
            title: 'Erfe evacuation site', snippet: 'Daroy Elementary School'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    ]);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _onEvacuationSiteSelected(Marker marker) async {
    setState(() {
      _showMap = true;
      _currentMarkers.clear();
      _currentMarkers.add(marker);
      
      // Re-add the current location marker if available
      if (_currentPosition != null) {
        _currentMarkers.add(
          Marker(
            markerId: const MarkerId("current_location"),
            position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(title: "You are here"),
          ),
        );
      }
    });

    try {
      final GoogleMapController controller = await _controller.future;
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          min(marker.position.latitude, _currentPosition?.latitude ?? marker.position.latitude),
          min(marker.position.longitude, _currentPosition?.longitude ?? marker.position.longitude),
        ),
        northeast: LatLng(
          max(marker.position.latitude, _currentPosition?.latitude ?? marker.position.latitude),
          max(marker.position.longitude, _currentPosition?.longitude ?? marker.position.longitude),
        ),
      );
      await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    } catch (e) {
      debugPrint("Error animating camera: $e");
    }
  }

  void _onBackToList() {
    setState(() {
      _showMap = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        leading: _showMap
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _onBackToList,
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _showMap && _currentPosition != null
              ? GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    if (!_controller.isCompleted) {
                      _controller.complete(controller);
                    }
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    zoom: 11.0,
                  ),
                  markers: _currentMarkers,
                )
              : Container(
                  color: Colors.blue[100],
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.3,
                          child: Image.asset(
                            'images/mdrrmo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ListView(
                        children: _allMarkers
                            .where((marker) => marker.markerId.value != 'currentLocation')
                            .map((marker) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              onTap: () => _onEvacuationSiteSelected(marker),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              leading: const CircleAvatar(
                                backgroundImage: AssetImage('images/a_logo.png'),
                              ),
                              title: Text(marker.infoWindow.title!),
                              subtitle: Text(marker.infoWindow.snippet!),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
    );
  }
}