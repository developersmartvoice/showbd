import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/OffersClassReceiver.dart';
import 'package:appcode3/modals/OffersClassSender.dart';
import 'package:appcode3/views/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SeeAllOffers extends StatefulWidget {
  // const SeeAllOffers({super.key});
  final String id;

  SeeAllOffers({required this.id});

  @override
  State<SeeAllOffers> createState() => _SeeAllOffersState();
}

class _SeeAllOffersState extends State<SeeAllOffers> {
  OffersClassSender? offersClassSender;
  OffersClassReceiver? offersClassReceiver;
  List<ChatDataSender>? chatDataSender;
  List<ChatShowDataSender>? chatShowDataSender;
  List<ChatData>? chatDataReceiver;
  List<ChatShowData>? chatShowDataReceiver;
  bool isSenderSelected = true;
  bool isDataFetch = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      getSenderOffers();
      getReceiverOffers();
    });
  }

  getSenderOffers() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getSendOffers?id=${widget.id}"));
    print("$SERVER_ADDRESS/api/getSendOffers?id=${widget.id}");
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      setState(() {
        offersClassSender = OffersClassSender.fromJson(jsonResponse);
        chatDataSender = offersClassSender!.dataForChat;
        chatShowDataSender = offersClassSender!.dataForShow;
        if (chatShowDataSender != null) {
          isDataFetch = true;
        } else {
          isDataFetch = false;
        }
      });
    }
  }

  getReceiverOffers() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getRecipients?id=${widget.id}"));
    print("$SERVER_ADDRESS/api/getRecipients?id=${widget.id}");

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      setState(() {
        offersClassReceiver = OffersClassReceiver.fromJson(jsonResponse);
        chatDataReceiver = offersClassReceiver!.dataForChat;
        chatShowDataReceiver = offersClassReceiver!.dataForShow;
        if (chatShowDataReceiver != null) {
          isDataFetch = true;
        } else {
          isDataFetch = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
        body: SafeArea(
          child: Column(
            children: [
              header(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isSenderSelected = true;
                              getSenderOffers();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            // padding: EdgeInsets.all(16.0),
                            backgroundColor: isSenderSelected
                                ? Colors.orange
                                : Color.fromARGB(255, 242, 235, 235),
                          ),
                          child: Text(
                            'Sent',
                            style: TextStyle(
                                color: isSenderSelected
                                    ? Colors.white
                                    : Colors.orange),
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.5,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0), // Adjust the spacing between buttons
                    Expanded(
                      child: Container(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isSenderSelected = false;
                              getReceiverOffers();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            // padding: EdgeInsets.all(16.0),
                            backgroundColor: isSenderSelected
                                ? Color.fromARGB(255, 242, 235, 235)
                                : Colors.orange,
                          ),
                          child: Text(
                            'Received',
                            style: TextStyle(
                                color: !isSenderSelected
                                    ? Colors.white
                                    : Colors.orange),
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.5,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isDataFetch && isSenderSelected && chatShowDataSender != null
                  ? Expanded(
                      child: ListView.builder(
                      itemCount: chatShowDataSender!.length,
                      itemBuilder: (context, index) {
                        final item = chatShowDataSender![index];
                        return Card(
                          elevation: 10.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          color: getColorForTiming(
                              chatShowDataSender![index].timing),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(25),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Title(
                                  color: Colors.black,
                                  child: Text(
                                    item.recipientName,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 20,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ), // Adding some space between the title and details
                                Container(
                                  width: MediaQuery.of(context).size.width - 32,
                                  height: 110, // Adjust the height as needed
                                  child: SingleChildScrollView(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Date: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .black, // Adjust color as needed
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${chatShowDataSender![index].date},\n',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 15,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          // Bold text for Duration
                                          TextSpan(
                                            text: 'Duration: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .black, // Adjust color as needed
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${chatShowDataSender![index].duration},\n',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 15,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          // Bold text for Timing
                                          TextSpan(
                                            text: 'Timing: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .black, // Adjust color as needed
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${chatShowDataSender![index].timing},\n',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 15,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          // Bold text for Message
                                          TextSpan(
                                            text: 'Message: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .black, // Adjust color as needed
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${chatShowDataSender![index].message},\n',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 15,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          // Bold text for Destination
                                          TextSpan(
                                            text: 'Destination: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .black, // Adjust color as needed
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${chatShowDataSender![index].Destination}\n',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 15,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      chatDataSender![index].name,
                                      "100" +
                                          chatDataSender![index].uid.toString(),
                                      chatDataSender![index].connectycubeUserId,
                                      false,
                                      chatDataSender![index].deviceToken,
                                      chatDataSender![index].recipientImage,
                                      chatDataSender![index].senderImage,
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        );
                      },
                    ))
                  : // Container(
                  // child: Text("No Data Found!"),
                  //),
                  isDataFetch &&
                          !isSenderSelected &&
                          chatShowDataReceiver != null
                      ? Expanded(
                          child: ListView.builder(
                          itemCount: chatShowDataReceiver!.length,
                          itemBuilder: (context, index) {
                            final item = chatShowDataReceiver![index];
                            return Card(
                              elevation: 10.0,
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              color: getColorForTiming(
                                  chatShowDataReceiver![index].timing),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(25),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Title(
                                      color: Colors.black,
                                      child: Text(
                                        item.senderName,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 20,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ), // Adding some space between the title and details
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          32,
                                      height:
                                          110, // Adjust the height as needed
                                      child: SingleChildScrollView(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Date: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors
                                                      .black, // Adjust color as needed
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${chatShowDataReceiver![index].date},\n',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 15,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              // Bold text for Duration
                                              TextSpan(
                                                text: 'Duration: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors
                                                      .black, // Adjust color as needed
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${chatShowDataReceiver![index].duration},\n',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 15,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              // Bold text for Timing
                                              TextSpan(
                                                text: 'Timing: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors
                                                      .black, // Adjust color as needed
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${chatShowDataReceiver![index].timing},\n',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 15,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              // Bold text for Message
                                              TextSpan(
                                                text: 'Message: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors
                                                      .black, // Adjust color as needed
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${chatShowDataReceiver![index].message},\n',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 15,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              // Bold text for Destination
                                              TextSpan(
                                                text: 'Destination: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors
                                                      .black, // Adjust color as needed
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${chatShowDataReceiver![index].destination}\n',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 15,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                                chatDataReceiver![index].name,
                                                "117" +
                                                    chatDataReceiver![index]
                                                        .uid
                                                        .toString(),
                                                chatDataReceiver![index]
                                                    .connectycubeUserId,
                                                true,
                                                chatDataReceiver![index]
                                                    .deviceToken,
                                                chatDataReceiver![index]
                                                    .recipientImage,
                                                chatDataReceiver![index]
                                                    .senderImage)));
                                  });
                                },
                              ),
                            );
                          },
                        ))
                      : Container(
                          child: Text("No Data Found!"),
                        ),
            ],
          ),
        ));
  }

  Widget header() {
    return Stack(
      children: [
        Image.asset(
          "assets/moreScreenImages/header_bg.png",
          height: 60,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
              Title(
                color: BLACK,
                child: Text(ALL_OFFERS,
                    style: Theme.of(context).textTheme.headline5!.apply(
                        color: Theme.of(context).backgroundColor,
                        fontWeightDelta: 5)),
              ),
              SizedBox(width: 48), // Adjust the space for the back button
            ],
          ),
        ),
      ],
    );
  }
}

Color getColorForTiming(String timing) {
  switch (timing) {
    case "Flexible":
      return Color.fromARGB(
          255, 247, 161, 112); // Or any color you want for Flexible timing
    case "Earlier":
      return Color.fromARGB(
          255, 243, 184, 180); // Or any color you want for Earlier timing
    case "Morning":
      return Color.fromARGB(
          255, 246, 209, 136); // Or any color you want for Morning timing
    case "Noon":
      return Color.fromARGB(
          255, 248, 242, 122); // Or any color you want for Noon timing
    case "Afternoon":
      return Color.fromARGB(
          255, 217, 97, 33); // Or any color you want for Afternoon timing
    default:
      return const Color.fromARGB(255, 255, 255, 255); // Default color
  }
}
