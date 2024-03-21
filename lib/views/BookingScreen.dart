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
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 243, 103, 9),
          actions: [
            // IconButton(
            //   icon: Icon(Icons.send_rounded),
            //   onPressed: () {
            //     // Implement send logic
            //   },
            // ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Select Date',
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: EdgeInsets.all(7),
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
                                    DateFormat('MM, dd, yyyy')
                                        .format(selectedDate!),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : Text('Select Date'),
                        ],
                      ),
                    ),
                  ),

                  // Divider(
                  //   height: 30,
                  //   color: Colors.grey,
                  // ),

                  //SizedBox(height: 10),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0), // Add padding here
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         'Tour Duration',
                  //         style: GoogleFonts.robotoCondensed(
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //       SizedBox(
                  //           width:
                  //               8), // Add spacing between text and DropdownSearch
                  //       Column(
                  //         children: [
                  //           Expanded(
                  //             child: DropdownSearch<String>(
                  //               items: ['1h', '2h', '3h'],
                  //               onChanged: (value) {
                  //                 setState(() {
                  //                   selectedDuration = value!;
                  //                 });
                  //               },
                  //               selectedItem: selectedDuration,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  SizedBox(
                    height: 100,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        // decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.grey),
                        //     borderRadius: BorderRadius.circular(8),
                        // ),
                        child: Container(
                          height:
                              50, // Set a fixed height or adjust according to your design
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Tour Duration',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: 50),
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
                        ),
                      ),
                    ),
                  ),

                  // Divider(
                  //   height: 20,
                  //   color: Colors.grey,
                  // ),

                  //SizedBox(height: 20),
                  SizedBox(
                    height: 100,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0), // Add padding here
                        child: Container(
                          height:
                              50, // Set a fixed height or adjust according to your design
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Preferred Meeting Time',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      50), // Add spacing between text and DropdownSearch
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
                      ),
                    ),
                  ),
                  // ... (similar changes for other widgets)

                  // Divider(
                  //   height: 20,
                  //   color: Colors.grey,
                  // ),

                  SizedBox(
                    height: 100,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0), // Add padding here
                        child: Container(
                          height:
                              50, // Set a fixed height or adjust according to your design
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Number of People',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      50), // Add spacing between text and DropdownSearch
                              Expanded(
                                child: DropdownSearch<String>(
                                  items: [
                                    'Just me',
                                    'Two people',
                                    'Three people',
                                    'More than three people',
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
                      ),
                    ),
                  ),

                  //SizedBox(height: 16),

                  // Divider(
                  //   height: 20,
                  //   color: Colors.grey,
                  // ),

                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text(
                          WHAT_BRING_YOU_HERE,
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              specificInterest = value;
                            });
                          },
                          decoration: InputDecoration(
                            prefixText: hintText,
                            hintStyle:
                                TextStyle(color: Colors.black38, fontSize: 15),
                          ),
                        ),
                        SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         BookingScreen(widget.id, widget.guideName),
                            //   ),
                            // );
                          },
                          child: Text('REQUEST TO BOOK'),
                          style: ElevatedButton.styleFrom(
                            textStyle: GoogleFonts.robotoCondensed(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                            padding: EdgeInsets.fromLTRB(112, 20, 114, 20),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 243, 103, 9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: Colors.white,
                              ), // Set border radius
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
