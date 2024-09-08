import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsCard extends StatefulWidget {
  const EventsCard({
    super.key,
    required this.eventId,
    required this.imgUrl,
    required this.eventName,
    required this.location,
    required this.startDate,
    required this.endtDate,
    required this.time,
    required this.countInterested,
    required this.countGoing,
    required this.status,
    required this.self,
    required this.isMember,
  });

  final int eventId;
  final String imgUrl;
  final String eventName;
  final String location;
  final String startDate;
  final String endtDate;
  final String time;
  final String countInterested;
  final String countGoing;
  final String status;
  final bool self;
  final bool isMember;

  @override
  State<EventsCard> createState() => _EventsCardState();
}

class _EventsCardState extends State<EventsCard> {
  final List<String> _dropdownValues = [
    "Interested",
    "Not Interested",
    "Going"
  ];
  String? _selectedValue;

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('EEE, dd MMM').format(parsedDate).toUpperCase();
  }

  void _updateSelectedValue() {
    if (widget.status == "1") {
      _selectedValue = "Interested";
    } else if (widget.status == "2") {
      _selectedValue = "Going";
    } else if (widget.status == "3") {
      _selectedValue = "Not Interested";
    }
  }

  @override
  void initState() {
    super.initState();
    _updateSelectedValue();
  }

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = _formatDate(widget.startDate);
    String formattedEndDate = _formatDate(widget.endtDate);
    String formattedTime = widget.time.substring(0, 5);

    return Card(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: widget.imgUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              "$formattedStartDate - $formattedEndDate at $formattedTime",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.eventName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              widget.location,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "${widget.countInterested} Interested . ${widget.countGoing} Going",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            !widget.self
                ? DropdownButton<String>(
                    value: _selectedValue,
                    hint: Center(
                      child: Text(
                        'Interested?',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    underline: SizedBox(),
                    items: _dropdownValues.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              value,
                              style: TextStyle(fontSize: 14),
                            ),
                            if (_selectedValue == value)
                              Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: widget.isMember
                        ? (String? newValue) {
                            setState(() {
                              _selectedValue = newValue;
                            });
                          }
                        : null,
                    selectedItemBuilder: (BuildContext context) {
                      return _dropdownValues.map<Widget>((String item) {
                        return Center(
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    // Apply a disabled style if not a member
                    style: TextStyle(
                        color: widget.isMember ? Colors.black : Colors.grey),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
