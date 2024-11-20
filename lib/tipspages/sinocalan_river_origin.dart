import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RiverOriginMap extends StatelessWidget {
  const RiverOriginMap({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // The coordinates of the river origin
    const LatLng originLocation = LatLng(16.242024, 120.596356); 

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
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: originLocation,
          zoom: 14.0,
        ),
        markers: {
          const Marker(
            markerId: MarkerId('riverOrigin'),
            position: originLocation,
            infoWindow: InfoWindow(
              title: 'Sinocalan River Origin',
              snippet: 'This is where the river originates.',
            ),
          ),
        },
      ),
    );
  }
}
