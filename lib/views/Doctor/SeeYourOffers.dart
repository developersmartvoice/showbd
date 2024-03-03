import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/GetRecipientsClass.dart';
import 'package:appcode3/modals/OffersClass.dart';
import 'package:appcode3/modals/SendOfferClass.dart';
import 'package:appcode3/views/ChatScreen.dart';
import 'package:appcode3/views/Doctor/SeeYourOffers.dart';
import 'package:appcode3/views/Doctor/loginAsDoctor.dart';
import 'package:appcode3/views/SendOfferScreen.dart';
import 'package:appcode3/views/SendOffersScreen.dart';
import 'package:appcode3/views/loginAsUser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:appcode3/main.dart' as appcode3;

import 'package:shared_preferences/shared_preferences.dart';

const String SERVER_ADDRESS =
    "your_server_address_here"; // Update with your server address
const Color LIGHT_GREY_SCREEN_BACKGROUND = Colors.grey;
const Color BLACK = Colors.black;

class SeeYourOffers extends StatefulWidget {
  @override
  _SeeYourOffersState createState() => _SeeYourOffersState();
}

class _SeeYourOffersState extends State<SeeYourOffers> {
  String? id;
  bool isLoading = false;
  List<ChatData> chatDataList = [];

  @override
  void initState() {
    super.initState();
    fetchChatData();
  }

  Future<void> fetchChatData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse("$SERVER_ADDRESS/api/getSendOffers?id=$id"),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        ChatResponse chatResponse = ChatResponse.fromJson(jsonResponse);

        if (chatResponse.success == true) {
          List<ChatDataS>? chatDataS = chatResponse.dataForChat
              ?.map((data) => ChatDataS.fromJson(data))
              .toList();
          setState(() {
            chatDataList = chatDataS ?? [];
          });
        } else {
          // Handle failure case
        }
      } else {
        // Handle server errors
        print('Failed to fetch chat data. Status code: ${response.statusCode}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle general errors
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
      print('Chat data fetching process completed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  header(),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: chatDataList.length,
                      itemBuilder: (context, index) {
                        final chatData = chatDataList[index];
                        return ListTile(
                          title: Text(chatData.name ?? ''),
                          leading: CircleAvatar(
                            backgroundImage: chatData.senderImage != null
                                ? NetworkImage(chatData.senderImage!)
                                : AssetImage('assets/default_avatar.png')
                                    as ImageProvider<Object>?,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
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
            children: [
              SizedBox(width: 10),
              Title(
                color: BLACK,
                child: Text(
                  'See Your Offers',
                  style: Theme.of(context).textTheme.headline5!.apply(
                        color: Theme.of(context).backgroundColor,
                        fontWeightDelta: 5,
                      ),
                ),
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

abstract class ChatData {
  String? name;
  String? role;
  String? senderImage;
  String? recipientImage;
}

class ChatDataR extends ChatData {}

class ChatDataS extends ChatData {
  ChatDataS.fromJson(Map<String, dynamic> json) {
    // Parse JSON and initialize properties
  }
}

class ChatResponse {
  bool success;
  List<dynamic>? dataForChat;

  ChatResponse({required this.success, this.dataForChat});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      success: json['success'] ?? false,
      dataForChat: json['dataForChat'],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SeeYourOffers(),
  ));
}
