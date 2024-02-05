import 'package:appcode3/en.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final String id;
  final String guideName;

  BookingScreen(this.id, this.guideName);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? selectedDate;
  String selectedDuration = "";
  String selectedMeetingTime = "";
  String selectedNumberOfPeople = "";
  String specificInterest = "";

  @override
  Widget build(BuildContext context) {
    String hintText = 'Hello ${widget.guideName}, ';
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Booking ${widget.guideName}',
            //centerTitle: true,
            style: GoogleFonts.robotoCondensed(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.send_rounded),
              onPressed: () {
                // Implement send logic
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Date',
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.all(8.0), // Add padding here
                          child: Icon(Icons.calendar_today),
                        ),
                        selectedDate != null
                            ? Padding(
                                padding: const EdgeInsets.all(
                                    8.0), // Add padding here
                                child: Text(
                                  DateFormat('MMM d, y').format(selectedDate!),
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : Text('Select Date'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0), // Add padding here
                  child: Row(
                    children: [
                      Text(
                        'Tour Duration',
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                          height:
                              20), // Add spacing between text and DropdownSearch
                      Column(
                        children: [
                          Expanded(
                            child: DropdownSearch<String>(
                              items: ['1h', '2h', '3h'],
                              onChanged: (value) {
                                setState(() {
                                  selectedDuration = value!;
                                });
                              },
                              selectedItem: selectedDuration,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0), // Add padding here
                  child: Row(
                    children: [
                      Text('Preferred Meeting Time'),
                      SizedBox(
                          width:
                              8), // Add spacing between text and DropdownSearch
                      Expanded(
                        child: DropdownSearch<String>(
                          items: [
                            'Flexible',
                            'Earlier',
                            'Morning',
                            'Noon',
                            'Afternoon'
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedMeetingTime = value!;
                            });
                          },
                          selectedItem: selectedMeetingTime,
                        ),
                      ),
                    ],
                  ),
                ),
                // ... (similar changes for other widgets)
                SizedBox(height: 16),
                Text(WHAT_BRING_YOU_HERE),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      specificInterest = value;
                    });
                  },
                  decoration: InputDecoration(
                    prefixText: hintText,
                    // hintText: 'Type your message...',
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
