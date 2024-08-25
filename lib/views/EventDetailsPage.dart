import 'package:appcode3/main.dart';
import 'package:appcode3/views/CreateEvent.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({
    super.key,
    required this.eventId,
    required this.imgUrl,
    required this.eventName,
    required this.eventDescription,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.time,
    required this.countInterested,
    required this.countGoing,
    required this.status,
    required this.self,
  });
  final int eventId;
  final String imgUrl;
  final String eventName;
  final String eventDescription;
  final String location;
  final String startDate;
  final String endDate;
  final String time;
  final String countInterested;
  final String countGoing;
  final String status;
  final bool self;
  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('EEE, dd MMM').format(parsedDate).toUpperCase();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = _formatDate(widget.startDate);
    String formattedEndDate = _formatDate(widget.endDate);
    String formattedTime = widget.time.substring(0, 5);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Event Details",
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: WHITE, fontWeightDelta: 1),
          ),
        ),
        centerTitle: true,
        foregroundColor: WHITE,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/moreScreenImages/header_bg.png"), // Add your background image path
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          widget.self
              ? IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CreateEvent(
                          eventData: {
                            'id': widget.eventId,
                            'imgUrl': widget.imgUrl,
                            'eventName': widget.eventName,
                            'eventDescription': widget.eventDescription,
                            'location': widget.location,
                            'start_date': widget.startDate,
                            'end_date': widget.endDate, // Corrected field name
                            'start_date_time': widget.time,
                            // 'countInterested': widget,
                            // 'countGoing': "75",
                            // 'status': "upcoming",
                            // self: true,
                          },
                        );
                      },
                    ));
                  },
                  icon: Icon(Icons.edit))
              : Container()
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            Container(
              height: 400,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: widget.imgUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Event Name and Creator
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.eventName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'by Event Creator',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Timing and Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$formattedStartDate - $formattedEndDate at $formattedTime',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.location,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Interested and Going Buttons
            !widget.self
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Interested'),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text('Going'),
                        ),
                      ],
                    ),
                  )
                : Container(),
            // Going and Interested Quantity
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.countInterested} Interested',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${widget.countGoing} Going',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            // Event Description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.eventDescription,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
