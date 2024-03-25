import 'dart:convert';

import 'package:appcode3/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MemberShipDetails extends StatefulWidget {
  String? id;
  // const MemberShipDetails({super.key});
  MemberShipDetails(this.id);

  @override
  State<MemberShipDetails> createState() => _MemberShipDetails();
}

class _MemberShipDetails extends State<MemberShipDetails> {
  String? formattedEndDate;
  bool isEndDateFetched = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEndSubscription();
  }

  String getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  getEndSubscription() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/end_subscription?id=${widget.id}"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final endDateString = jsonResponse["ending_subscription"].toString();
      final endDate = DateTime.parse(endDateString);
      final formatter = DateFormat('dd');
      final day = formatter.format(endDate);
      final suffix = getOrdinalSuffix(int.parse(day));
      final formattedDate = DateFormat('MMMM yyyy').format(endDate);
      setState(() {
        formattedEndDate = '$day$suffix $formattedDate';
        isEndDateFetched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Membership Details",
            style: Theme.of(context).textTheme.headline5!.apply(
                color: Theme.of(context).backgroundColor, fontWeightDelta: 5),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: isEndDateFetched
                ? Center(
                    child: Container(
                      alignment: Alignment.center,
                      transformAlignment: Alignment.center,
                      padding: EdgeInsets.all(
                          20), // Adding padding for better appearance
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Centering vertically
                        children: [
                          Text(
                            "You subscribed for 1 month.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Making text bold
                              fontSize: 18, // Adjusting font size
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Your subscription will end on :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Making text bold
                              fontSize: 18, // Adjusting font size
                            ),
                          ),
                          Text(
                            formattedEndDate!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Making text bold
                              fontSize: 18, // Adjusting font size
                              color: Colors.blue, // Changing text color to blue
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    transformAlignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: const Color.fromARGB(255, 243, 103, 9),
                    ),
                  )),
      ),
    );
  }
}
