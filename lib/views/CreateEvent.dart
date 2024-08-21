import 'dart:convert';

import 'package:appcode3/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _timingController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  File? _eventImage;
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? userId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pref) {
      setState(() {
        userId = pref.getString("userId");
        print(userId);
      });
    });
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _eventImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        // Format the time as HH:mm
        final now = DateTime.now();
        final selectedTime =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        String formattedTime = DateFormat('HH:mm').format(selectedTime);
        controller.text = formattedTime;
        _selectedTime = picked;
      });
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _submitEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      setState(() {
        isLoading = true;
      });
    }

    print('Event Name: ${_eventNameController.text}');
    print('Start Date: ${_startDateController.text}');
    print('End Date: ${_endDateController.text}');
    print('Location: ${_locationController.text}');
    print('Timing: ${_timingController.text}');

    final uri = Uri.parse('$SERVER_ADDRESS/api/store_event');
    final request = http.MultipartRequest('POST', uri);

    if (_eventImage != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', _eventImage!.path));
    }

    request.fields['user_id'] =
        userId!; // Example user_id; replace with actual value
    request.fields['name'] = _eventNameController.text;
    request.fields['description'] = _eventDescriptionController.text;
    request.fields['start_date'] = _startDateController.text;
    request.fields['start_date_time'] = _timingController.text;
    request.fields['end_date'] = _endDateController.text;
    request.fields['location'] = _locationController.text;
    // request.fields['slider_view'] =
    //     '0'; // Optional, set default if not provided

    final response = await request.send();
    print(response.statusCode);

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      setState(() {
        print(data);
        isLoading = false;
        _eventImage = null;
        _eventNameController.text = '';
        _eventDescriptionController.text = '';
        _startDateController.text = '';
        _timingController.text = '';
        _endDateController.text = '';
        _locationController.text = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event created successfully!'),
        ),
      );
      // Handle successful response
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create event'),
        ),
      );
      // Handle error response
    }
  }

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? suffixIcon,
    IconData? prefixIconData,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey[600],
        fontSize: 16,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Color.fromARGB(255, 255, 84, 5),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
      prefixIcon: prefixIconData != null
          ? Icon(
              prefixIconData,
              color: Color.fromARGB(255, 255, 84, 5),
            )
          : null,
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Create Event',
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: Colors.white, fontWeightDelta: 1),
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/moreScreenImages/header_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: !isLoading
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _eventNameController,
                        decoration: _inputDecoration(
                          hintText: 'Event Name',
                          prefixIconData: Icons.event,
                        ),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter event name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _eventDescriptionController,
                        decoration: _inputDecoration(
                          hintText: 'Event Description',
                          prefixIconData: Icons.description,
                        ),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        maxLines: 5,
                        // maxLength: 500,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter event description';
                          } else if (value.split(' ').length > 200) {
                            return 'Description cannot exceed 200 words';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _selectImage,
                        child: _eventImage != null
                            ? Image.file(_eventImage!,
                                height: 200, fit: BoxFit.cover)
                            : Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text('Tap to select event image'),
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _startDateController,
                        decoration: _inputDecoration(
                          hintText: 'Start Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(_startDateController),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select start date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _endDateController,
                        decoration: _inputDecoration(
                          hintText: 'End Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(_endDateController),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select end date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _timingController,
                        decoration: _inputDecoration(
                          hintText: 'Select Time',
                          suffixIcon: Icon(Icons.timer),
                        ),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        readOnly: true,
                        onTap: () => _selectTime(_timingController),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select end date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: _inputDecoration(
                          hintText: 'Event Location',
                          prefixIconData: Icons.location_on,
                        ),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter event location';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        // onPressed: () {
                        //   if (_formKey.currentState!.validate()) {
                        //     // Handle form submission here
                        //     print('Event Name: ${_eventNameController.text}');
                        //     print('Start Date: ${_startDateController.text}');
                        //     print('End Date: ${_endDateController.text}');
                        //     print('Location: ${_locationController.text}');
                        //     print('Timing: ${_timingController.text}');
                        //     // You can also handle the event image (_eventImage) here
                        //   }
                        // },
                        onPressed: _submitEvent,
                        child: Text('Create Event'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Color.fromARGB(255, 255, 84, 5),
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 255, 84, 5),
              ),
            ),
    );
  }
}
