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
        isDataFetch = true;
        offersClassSender = OffersClassSender.fromJson(jsonResponse);
        chatDataSender = offersClassSender!.dataForChat;
        chatShowDataSender = offersClassSender!.dataForShow;
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
        isDataFetch = true;
        offersClassReceiver = OffersClassReceiver.fromJson(jsonResponse);
        chatDataReceiver = offersClassReceiver!.dataForChat;
        chatShowDataReceiver = offersClassReceiver!.dataForShow;
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
              !isDataFetch
                  ? Container(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isSenderSelected = true;
                                  getSenderOffers();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSenderSelected
                                    ? Colors.orange
                                    : Color.fromARGB(255, 242, 235,
                                        235), // Change the colors as needed
                              ),
                              child: Text(
                                'Sender',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.5,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isSenderSelected = false;
                                  getReceiverOffers();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSenderSelected
                                    ? Color.fromARGB(255, 242, 235, 235)
                                    : Colors
                                        .orange, // Change the colors as needed
                              ),
                              child: Text(
                                'Recipient',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.5,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              isSenderSelected && chatShowDataSender!.length > 0
                  ? Expanded(
                      child: ListView.builder(
                      itemCount: chatShowDataSender!.length,
                      itemBuilder: (context, index) {
                        final item = chatShowDataSender![index];
                        return Card(
                          elevation: 2.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            // title: tripsTitle(),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Title(
                                    color: Colors.black,
                                    child: Text(item.recipientName))
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
                                                chatDataSender![index]
                                                    .uid
                                                    .toString(),
                                            chatDataSender![index]
                                                .connectycubeUserId,
                                            false,
                                            chatDataSender![index].deviceToken,
                                            chatDataSender![index]
                                                .recipientImage,
                                            chatDataSender![index]
                                                .senderImage)));
                              });
                            },
                          ),
                        );
                      },
                    ))
                  : Container(),
              !isSenderSelected && chatShowDataReceiver!.length > 0
                  ? Expanded(
                      child: ListView.builder(
                      itemCount: chatShowDataReceiver!.length,
                      itemBuilder: (context, index) {
                        final item = chatShowDataReceiver![index];
                        return Card(
                          elevation: 2.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            // title: tripsTitle(),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Title(
                                    color: Colors.black,
                                    child: Text(item.senderName))
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
                  : Container()
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
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              Title(
                color: BLACK,
                child: Text(ALL_OFFERS,
                    style: Theme.of(context).textTheme.headline5!.apply(
                        color: Theme.of(context).backgroundColor,
                        fontWeightDelta: 5)),
              ),
            ],
          ),
        ),
        Container(
          height: 60,
        )
      ],
    );
  }
}
