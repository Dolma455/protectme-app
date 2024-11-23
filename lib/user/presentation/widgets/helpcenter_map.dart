import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:protectmee/utils/app_styles.dart';
import 'dart:math' as math;

class HelpCenterWidget extends StatefulWidget {
  final ValueChanged<String> onLocationSelected;

  const HelpCenterWidget({super.key, required this.onLocationSelected});

  @override
  State<HelpCenterWidget> createState() => _HelpCenterWidgetState();
}

class _HelpCenterWidgetState extends State<HelpCenterWidget> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(27.7172, 85.3240); 
  String nearestHelpCenterName = '';
  double nearestHelpCenterDistance = 0;
  List<HelpCenter> helpCenters = [
    HelpCenter(name: "Nepal Police Headquarters", location: const LatLng(27.7172, 85.324827)),
    HelpCenter(name: "Metropolitan Police Range, Kathmandu", location: const LatLng(27.695934, 85.308032)),
    HelpCenter(name: "Metropolitan Police Range, Lalitpur", location: const LatLng(27.672113, 85.319883)),
    HelpCenter(name: "Metropolitan Police Range, Bhaktapur", location: const LatLng(27.671175, 85.428839)),
    HelpCenter(name: "Metropolitan Police Circle, Boudha", location: const LatLng(27.721538, 85.361273)),
    HelpCenter(name: "Metropolitan Police Circle, Kalimati", location: const LatLng(27.693498, 85.303429)),
    HelpCenter(name: "Metropolitan Police Circle, Baneshwor", location: const LatLng(27.686788, 85.334063)),
  ];
  List<Marker> _markers = [];
  List<HelpCenter> searchResults = [];

  @override
  void initState() {
    super.initState();
    _findNearestHelpCenter();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _showMarkers(helpCenters);
  }

  void _showMarkers(List<HelpCenter> centers) {
    setState(() {
      _markers = centers.map((center) {
        return Marker(
          markerId: MarkerId(center.name),
          position: center.location,
          icon: center.name == nearestHelpCenterName
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue) // Highlight nearest help center
              : BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: center.name,
            snippet: '${_calculateDistance(_center, center.location).toStringAsFixed(2)} km away',
          ),
        );
      }).toList();
    });
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const earthRadius = 6371; // Earth's radius in kilometers
    final dLat = _degreesToRadians(end.latitude - start.latitude);
    final dLon = _degreesToRadians(end.longitude - start.longitude);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(start.latitude)) * math.cos(_degreesToRadians(end.latitude)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  void _findNearestHelpCenter() {
    if (helpCenters.isEmpty) return;

    final nearestHelpCenter = helpCenters.reduce((a, b) {
      final distanceA = _calculateDistance(_center, a.location);
      final distanceB = _calculateDistance(_center, b.location);
      return distanceA < distanceB ? a : b;
    });

    final distance = _calculateDistance(_center, nearestHelpCenter.location);

    setState(() {
      nearestHelpCenterName = nearestHelpCenter.name;
      nearestHelpCenterDistance = distance;
      widget.onLocationSelected(nearestHelpCenter.name); // Callback for location selected
    });
  }

  void _searchHelpCenters(String query) {
    setState(() {
      searchResults = helpCenters
          .where((center) => center.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Search Help Centers...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: blueColor, width: 1.5),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                 
                  setState(() {
                    searchResults.clear();
                    nearestHelpCenterName = '';
                  });
                },
              ),
            ),
            onChanged: (query) {
              _searchHelpCenters(query);
            },
            controller: TextEditingController(text: nearestHelpCenterName),
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        if (searchResults.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final center = searchResults[index];
                return ListTile(
                  title: Text(center.name),
                  onTap: () {
                    setState(() {
                      nearestHelpCenterName = center.name;
                      searchResults.clear();
                    });
                    widget.onLocationSelected(center.name);
                  },
                );
              },
            ),
          )
        else
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  markers: Set<Marker>.of(_markers),
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                ),
                if (nearestHelpCenterName.isNotEmpty)
                  Positioned(
                    top: 80,
                    left: 15,
                    right: 15,
                    child: Container(
                      decoration: BoxDecoration(
                        color: darkBlueColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Nearest Help Center: $nearestHelpCenterName (${nearestHelpCenterDistance.toStringAsFixed(2)} km away)',
                            style: bodyTextStyle,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Tap another location to see details and distance.',
                            style: bodyTextStyle.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class HelpCenter {
  final String name;
  final LatLng location;

  HelpCenter({required this.name, required this.location});
}