import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:protectmee/user/controller/report_form_controller.dart';
import 'package:protectmee/user/data/models/report_form_model.dart';
import '../../../utils/app_styles.dart';
import 'dart:math' as math;

class ReportFormModal extends ConsumerStatefulWidget {
  const ReportFormModal({super.key});

  @override
  ConsumerState<ReportFormModal> createState() => _ReportFormModalState();
}

class _ReportFormModalState extends ConsumerState<ReportFormModal> {
  final List<String> incidentTypes = [
    'Theft',
    'Assault',
    'Accident',
    'Harassment',
    'Vandalism',
    'Burglary',
    'Domestic Violence',
    'Fraud',
    'Cyber Crime',
    'Drug Offense'
  ];
  String selectedIncidentType = 'Theft';
  DateTime selectedDate = DateTime.now();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  List<File> evidence = [];
  String nearestHelpCenterName = 'Unknown';
  double nearestHelpCenterDistance = 0;
  int userId = 0;
  String fullName = 'Dolma Lama';
  String mobileNumber = '9878787656';

  final LatLng _center = const LatLng(27.7172, 85.3240); // Assume this is user’s location
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
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _findNearestHelpCenter();
  }

  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? 'Dolma Lama';
      mobileNumber = prefs.getString('phoneNumber') ?? '9878787656';
      userId = prefs.getInt('userId') ?? 0;
    });
  }

  Future<void> _pickEvidence() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    setState(() {
      evidence = pickedFiles.map((file) => File(file.path)).toList();
    });
  }

  void _submitReport() async {
    // Logic for submitting the form data
    if (descriptionController.text.isEmpty || addressController.text.isEmpty) {
      _showSnackbar('Please fill in all required fields.', Colors.red);
      return;
    }

    final reportModel = ReportFormModel(
      id: 0,
      userId: userId,
      fullName: fullName,
      mobileNumber: mobileNumber,
      incidentType: selectedIncidentType,
      dateTime: selectedDate,
      description: descriptionController.text,
      address: addressController.text,
      policeStation: nearestHelpCenterName,
      evidenceFilePath: evidence,
      status: 'In Progress', // Set initial status
    );

    // Print all fields
    print('Report Model:');
    print('ID: ${reportModel.id}');
    print('User ID: ${reportModel.userId}');
    print('Full Name: ${reportModel.fullName}');
    print('Mobile Number: ${reportModel.mobileNumber}');
    print('Incident Type: ${reportModel.incidentType}');
    print('Date & Time: ${reportModel.dateTime}');
    print('Description: ${reportModel.description}');
    print('Address: ${reportModel.address}');
    print('Police Station: ${reportModel.policeStation}');
    print('Evidence File Paths: ${reportModel.evidenceFilePath}');
    print('Status: ${reportModel.status}');

    try {
      final message = await ref.read(reportFormControllerProvider.notifier).postReport(reportModel);
      _showSnackbar(message, Colors.green);
      Navigator.pop(context); // Close the modal after submission
    } catch (e) {
      print('Error submitting report: $e');
      _showSnackbar('Error submitting report: $e', Colors.red);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onLocationSelected(String helpCenterName) {
    setState(() {
      nearestHelpCenterName = helpCenterName;
      nearestHelpCenterDistance = _calculateDistance(_center, helpCenters.firstWhere((center) => center.name == helpCenterName).location);
    });
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
          onTap: () {
            _onLocationSelected(center.name);
          },
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
      _onLocationSelected(nearestHelpCenter.name); // Callback for location selected
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report an Incident', style: titleTextStyle),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text("Select Incident Type"),
            const SizedBox(height: 8),
            _buildDropdownField(
              label: 'Incident Type',
              value: selectedIncidentType,
              items: incidentTypes,
              onChanged: (value) {
                setState(() {
                  selectedIncidentType = value as String;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDateField(
              label: 'Date & Time',
              selectedDate: selectedDate,
              onDateSelected: (pickedDate) {
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Incident Description',
              controller: descriptionController,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Incident Address',
              controller: addressController,
              maxLines: 1,
            ),
            const SizedBox(height: 16),
            const Text("Select Police Station Location:"),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                markers: Set<Marker>.of(_markers),
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickEvidence,
              style: ElevatedButton.styleFrom(
                backgroundColor: purpleColor,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              ),
              child: Text('Attach Evidence (Photos/Videos)', style: bodyTextStyle),
            ),
            if (evidence.isNotEmpty)
              Wrap(
                children: evidence
                    .map((file) => Image.file(file, width: 80, height: 80, fit: BoxFit.cover))
                    .toList(),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8D50F5),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text('Submit Report', style: bodyTextStyle),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField(
      value: value,
      decoration: inputDecoration(label),
      dropdownColor: darkBlueColor, // Set the dropdown background color
      style: const TextStyle(color: Colors.grey), // Set the text color to grey
      items: items.map((type) => DropdownMenuItem(value: type, child: Text(type, style: const TextStyle(color: Colors.grey)))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime selectedDate,
    required ValueChanged<DateTime?> onDateSelected,
  }) {
    return TextField(
      controller: TextEditingController(text: "${selectedDate.toLocal()}".split(' ')[0]),
      readOnly: true,
      decoration: inputDecoration(label).copyWith(
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2021),
          lastDate: DateTime(2101),
        );
        onDateSelected(pickedDate);
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      decoration: inputDecoration(label),
      maxLines: maxLines,
      style: inputTextStyle,
    );
  }
}

class HelpCenter {
  final String name;
  final LatLng location;

  HelpCenter({required this.name, required this.location});
}