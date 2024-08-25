import 'dart:convert';
import 'package:appcode3/main.dart';
import 'package:appcode3/views/Doctor/DoctorTabScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class CreateEvent extends StatefulWidget {
  final Map<String, dynamic>?
      eventData; // Accept event data as an optional parameter

  const CreateEvent({super.key, this.eventData});

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
  int? eventId;
  String? userId;
  bool isLoading = false;
  bool isValidateCall = false;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((pref) {
      setState(() {
        userId = pref.getString("userId");
        print(userId);
      });
    });

    if (widget.eventData != null) {
      // Populate fields with existing event data if available
      eventId = widget.eventData!['id'] ?? null;
      _eventNameController.text = widget.eventData!['eventName'] ?? '';
      _eventDescriptionController.text =
          widget.eventData!['eventDescription'] ?? '';
      _locationController.text = widget.eventData!['location'] ?? '';
      _startDateController.text = widget.eventData!['start_date'] ?? '';
      _endDateController.text = widget.eventData!['end_date'] ?? '';
      _timingController.text = widget.eventData!['start_date_time'] != null
          ? widget.eventData!['start_date_time'].substring(0, 5) // HH:mm
          : '';
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    // Determine the initial time to be used in the time picker
    String initialTimeString =
        widget.eventData != null && _timingController.text.isNotEmpty
            ? _timingController.text
            : TimeOfDay.now().format(context);

    // Ensure the time string is in the correct format (HH:mm)
    TimeOfDay initialTime = TimeOfDay.now();
    try {
      if (initialTimeString.isNotEmpty) {
        List<String> timeParts = initialTimeString.split(":");
        if (timeParts.length == 2) {
          int hour = int.parse(timeParts[0]);
          int minute = int.parse(timeParts[1]);
          initialTime = TimeOfDay(hour: hour, minute: minute);
        }
      }
    } catch (e) {
      print('Error parsing time: $e');
      // Fall back to current time if parsing fails
      initialTime = TimeOfDay.now();
    }

    // Show the time picker
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final selectedTime =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        String formattedTime = DateFormat('HH:mm').format(selectedTime);
        controller.text = formattedTime;
      });
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime initialDate =
        widget.eventData != null && controller.text.isNotEmpty
            ? DateTime.parse(controller.text)
            : DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _submitEvent() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        isValidateCall = true;
      });
      return;
    }

    setState(() {
      isLoading = true;
      isValidateCall = false;
    });

    final uri = widget.eventData != null
        ? Uri.parse('$SERVER_ADDRESS/api/update_event')
        : Uri.parse('$SERVER_ADDRESS/api/store_event');

    final request = http.MultipartRequest('POST', uri);

    if (_eventImage != null || widget.eventData != null) {
      if (_eventImage != null) {
        // Add new image if selected
        request.files
            .add(await http.MultipartFile.fromPath('image', _eventImage!.path));
      } else if (widget.eventData != null) {
        // Keep existing image if no new image is selected
        request.fields['existing_image'] = widget.eventData!['imgUrl'] ?? '';
      }
    }

    request.fields['user_id'] = userId!;
    request.fields['name'] = _eventNameController.text;
    request.fields['description'] = _eventDescriptionController.text;
    request.fields['start_date'] = _startDateController.text;
    request.fields['start_date_time'] = _timingController.text;
    request.fields['end_date'] = _endDateController.text;
    request.fields['location'] = _locationController.text;

    if (widget.eventData != null) {
      request.fields['id'] = widget.eventData!['id'].toString();
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final data = jsonDecode(responseBody);
    print(data);

    setState(() {
      isLoading = false;
      _eventImage = null;
      _eventNameController.text = '';
      _eventDescriptionController.text = '';
      _startDateController.text = '';
      _timingController.text = '';
      _endDateController.text = '';
      _locationController.text = '';
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.eventData != null
              ? 'Event updated successfully!'
              : 'Event created successfully!'),
        ),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorTabsScreen(
              index: 2,
            ),
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Failed to ${widget.eventData != null ? 'update' : 'create'} event'),
        ),
      );
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
          widget.eventData != null ? 'Edit Event' : 'Create Event',
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter event description';
                          }
                          return null;
                        },
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _startDateController,
                        onTap: () => _selectDate(_startDateController),
                        decoration: _inputDecoration(
                          hintText: 'Start Date',
                          // suffixIcon: IconButton(
                          //   icon: Icon(Icons.calendar_today_outlined),
                          //   onPressed: () => _selectDate(_startDateController),
                          // ),
                          prefixIconData: Icons.date_range,
                        ),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a start date';
                          }
                          return null;
                        },
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _timingController,
                        onTap: () => _selectTime(_timingController),
                        decoration: _inputDecoration(
                          hintText: 'Start Time',
                          // suffixIcon: IconButton(
                          //   icon: Icon(Icons.access_time),
                          //   onPressed: () => _selectTime(_timingController),
                          // ),
                          prefixIconData: Icons.access_time,
                        ),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a start time';
                          }
                          return null;
                        },
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _endDateController,
                        onTap: () => _selectDate(_endDateController),
                        decoration: _inputDecoration(
                          hintText: 'End Date',
                          // suffixIcon: IconButton(
                          //   icon: Icon(Icons.calendar_today_outlined),
                          //   onPressed: () => _selectDate(_endDateController),
                          // ),
                          prefixIconData: Icons.date_range,
                        ),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an end date';
                          }
                          return null;
                        },
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: _inputDecoration(
                          hintText: 'Location',
                          prefixIconData: Icons.location_on_outlined,
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
                      const SizedBox(height: 16),
                      if (_eventImage != null || widget.eventData != null) ...[
                        Text(
                          'Selected Image:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        _eventImage != null
                            ? Image.file(
                                _eventImage!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : widget.eventData != null &&
                                    widget.eventData!['imgUrl'] != null
                                ? CachedNetworkImage(
                                    imageUrl: widget.eventData!['imgUrl'],
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox.shrink(),
                        const SizedBox(height: 16),
                      ],
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.photo_camera),
                        label: Text('Select Event Image'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitEvent,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Color.fromARGB(255, 255, 84, 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          widget.eventData != null
                              ? 'Update Event'
                              : 'Create Event',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _eventImage = File(image.path);
      });
    }
  }
}
