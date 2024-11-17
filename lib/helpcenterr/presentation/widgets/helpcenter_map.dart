import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:protectmee/utils/app_styles.dart';

class HelpCenterMap extends StatefulWidget {
  final ValueChanged<String> onLocationSelected;

  const HelpCenterMap({super.key, required this.onLocationSelected});

  @override
  State<HelpCenterMap> createState() => _HelpCenterMapState();
}

class _HelpCenterMapState extends State<HelpCenterMap> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(27.7172, 85.3240); 
  String searchQuery = '';
  List<HelpCenter> helpCenters = [
    HelpCenter(name: "Nepal Police Headquarters", location: const LatLng(27.7172, 85.324827)),
    HelpCenter(name: "Metropolitan Police Range, Kathmandu", location: const LatLng(27.695934, 85.308032)),
    HelpCenter(name: "Metropolitan Police Range, Lalitpur", location: const LatLng(27.672113, 85.319883)),
    HelpCenter(name: "Metropolitan Police Range, Bhaktapur", location: const LatLng(27.671175, 85.428839)),
    HelpCenter(name: "Metropolitan Police Circle, Boudha", location: const LatLng(27.721538, 85.361273)),
    HelpCenter(name: "Metropolitan Police Circle, Kalimati", location: const LatLng(27.693498, 85.303429)),
    HelpCenter(name: "Metropolitan Police Circle, Baneshwor", location: const LatLng(27.686788, 85.334063)),
  ];
  List<HelpCenter> filteredHelpCenters = [];
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    filteredHelpCenters = helpCenters;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _showMarkers(filteredHelpCenters);
  }

  void _showMarkers(List<HelpCenter> centers) {
    setState(() {
      _markers = centers.map((center) {
        return Marker(
          markerId: MarkerId(center.name),
          position: center.location,
          infoWindow: InfoWindow(
            title: center.name,
          ),
        );
      }).toList();
    });
  }

  void _filterHelpCenters(String query) {
    setState(() {
      searchQuery = query;
      filteredHelpCenters = query.isEmpty
          ? helpCenters
          : helpCenters
              .where((center) => center.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
      _showMarkers(filteredHelpCenters);
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
                  // Clear search query if needed
                  _filterHelpCenters('');
                },
              ),
            ),
            onChanged: _filterHelpCenters,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
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
              if (searchQuery.isNotEmpty)
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
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredHelpCenters.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filteredHelpCenters[index].name, style: bodyTextStyle),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.newLatLng(
                                filteredHelpCenters[index].location,
                              ),
                            );
                            _showMarkers([filteredHelpCenters[index]]);
                            widget.onLocationSelected(filteredHelpCenters[index].name); // Callback for location selected
                            setState(() {
                              searchQuery = '';
                            });
                          },
                        );
                      },
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
