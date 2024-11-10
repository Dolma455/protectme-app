import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/app_styles.dart';
import '../helpcenter_map.dart';

class ReportFormModal extends StatefulWidget {
  const ReportFormModal({super.key});

  @override
  State<ReportFormModal> createState() => _ReportFormModalState();
}

class _ReportFormModalState extends State<ReportFormModal> {
  final List<String> incidentTypes = ['Theft', 'Assault', 'Accident', 'Harassment'];
  String selectedIncidentType = 'Theft';
  DateTime selectedDate = DateTime.now();
  final TextEditingController descriptionController = TextEditingController();
  LatLng? incidentLocation;
  LatLng? policeStationLocation;
  List<File> evidence = [];

  final LatLng initialMapLocation = const LatLng(27.7172, 85.3240);

  Future<void> _pickEvidence() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    setState(() {
      evidence = pickedFiles.map((file) => File(file.path)).toList();
    });
  }

  void _submitReport() {
    // Logic for submitting the form data
    print('Incident Type: $selectedIncidentType');
    print('Date: $selectedDate');
    print('Description: ${descriptionController.text}');
    print('Incident Location: $incidentLocation');
    print('Police Station Location: $policeStationLocation');
    print('Evidence: ${evidence.length} files attached.');
    Navigator.pop(context); // Close the modal after submission
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Report an Incident', style: titleTextStyle),
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
            spacing1,
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
            Text("Select Incident Location:", style: bodyTextStyle),
            SizedBox(
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: initialMapLocation,
                  zoom: 14.0,
                ),
                onTap: (LatLng location) {
                  setState(() {
                    incidentLocation = location;
                  });
                },
                markers: incidentLocation != null
                    ? {
                        Marker(
                          markerId: const MarkerId('incidentLocation'),
                          position: incidentLocation!,
                        ),
                      }
                    : {},
              ),
            ),
            const SizedBox(height: 16),
            Text("Select Police Station Location:", style: bodyTextStyle),
            SizedBox(
              height: 200,
              child: HelpCenterWidget(
                onLocationSelected: (location) {
                  setState(() {
                   // policeStationLocation = location;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickEvidence,
              style: ElevatedButton.styleFrom(
                backgroundColor: purpleColor,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              ),
              child:  Text('Attach Evidence (Photos/Videos)', style: bodyTextStyle),
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
              child:  Text('Submit Report', style: bodyTextStyle),
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
      items: items.map((type) => DropdownMenuItem(value: type, child: Text(type, style: inputTextStyle))).toList(),
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