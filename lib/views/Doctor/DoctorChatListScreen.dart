import 'dart:convert';
import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/SendOfferClass.dart';
import 'package:appcode3/views/ChatScreen.dart';
import 'package:appcode3/views/SeeAllOffersScreen.dart';
import 'package:appcode3/views/SendOffersScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  var ds;
  SendOfferClass? _sendOfferClass;
  List<NotifiedGuides>? notifyGds;

  bool? isSenderSelected = true;
  // ChatData? chatData;
  // String? message;
  // DataForChat? dataForChat;
  // DataForShow? dataForShow;
  String? myUid;
  String? id;
  int tripCount = 0;
  // List<ChatData> chatDataList = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) {
      myUid = value.getString("userIdWithAscii");
      id = value.getString("userId");

      setState(() {
        print(id);
      });

      print('myUid ---> ${myUid}');
      getTripCount();
      getChatListData();
      getSendOfferData();
    });
  }

  List<ChatListDetails> chatListDetails = [];
  List<ChatListDetails> chatListDetailsPA = [];

  getSendOfferData() {
    FirebaseDatabase.instance
        .ref()
        .child(myUid!)
        .child('sendOffers')
        .onValue
        .listen((event) {
      print('print send offer value :- ${event.snapshot.value}');
    });
  }

  getTripCount() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/notifyGuidesAboutTrip?id=$id"));

    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        setState(() {
          _sendOfferClass = SendOfferClass.fromJson(jsonResponse);
          tripCount = _sendOfferClass!.tripCount!.toInt();
          notifyGds = _sendOfferClass!.notifiedGuides;
          print(tripCount);
        });
      }
    } catch (e) {
      print("Getting Error: $e");
    }
  }

  getChatListData() {
    ds = FirebaseDatabase.instance.ref().child(myUid!).onValue.listen((event) {
      // print(
      //     'print chat list value :- ${event.snapshot.value['chatlist'].toString()}');
      setState(() {
        chatListDetailsPA.clear();
      });

      final dynamic snapshotValue = event.snapshot.value;
      if (snapshotValue != null && snapshotValue['chatlist'] != null) {
        final Map<dynamic, dynamic> chatListMap =
            Map<dynamic, dynamic>.from(snapshotValue['chatlist']);

        chatListMap.forEach((key, values) {
          setState(() {
            if (values['last_msg'] != null) {
              chatListDetailsPA.add(ChatListDetails(
                channelId: values['channelId'],
                message: values['last_msg'],
                messageCount: values['messageCount'],
                time: DateTime.parse(values['time'].toString())
                    .add(DateTime.now().timeZoneOffset)
                    .toString(),
                type: int.parse(values['type'].toString()),
                userUid: key,
              ));
            }
          });
        });
      }
      if (chatListDetailsPA.length > 1) {
        chatListDetailsPA.sort((a, b) => b.time.compareTo(a.time));
      }
      setState(() {
        chatListDetails.clear();
        chatListDetails.addAll(chatListDetailsPA);
      });

      for (int i = 0; i < chatListDetails.length; i++) {
        print('chat index $i -- ${chatListDetails[i].message}');
        print('chat index $i -- ${chatListDetails[i].channelId}');
        print('chat index $i -- ${chatListDetails[i].messageCount}');
        print('chat index $i -- ${chatListDetails[i].time}');
        print('chat index $i -- ${chatListDetails[i].type}');
        print('chat index $i -- ${chatListDetails[i].userUid}');
      }
      setState(() {
        st = true;
      });
    });
  }

  bool st = false;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: const Color.fromARGB(255, 243, 103, 9),
            ))
          : SafeArea(
              child: Column(
                children: [
                  header(),
                  Container(
                      child: Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SendOffersScreen(
                                  notifyGuides:
                                      _sendOfferClass!.notifiedGuides!,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  // Add your avatar properties, e.g., backgroundImage, radius, etc.
                                  radius: 35,
                                  backgroundImage:
                                      AssetImage('assets/people 6.png'),
                                  backgroundColor: Colors
                                      .blue, // Example color, you can customize
                                  // Add any other properties for the avatar
                                ),
                                // Your card content goes here
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      // Add your card content here, e.g., Text, Image, etc.
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'MeetLocal',
                                          style: GoogleFonts.robotoCondensed(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        tripCount > 1
                                            ? Text(
                                                '$tripCount persons are looking for a local',
                                                style:
                                                    GoogleFonts.robotoCondensed(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            : Text(
                                                '$tripCount person is looking for a local',
                                                style:
                                                    GoogleFonts.robotoCondensed(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                        Text(
                                          'in your place.',
                                          style: GoogleFonts.robotoCondensed(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios_sharp),
                                  onPressed: () {
                                    tripCount > 0
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SendOffersScreen(
                                                notifyGuides: notifyGds,
                                              ),
                                            ),
                                          )
                                        : showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('No person found!'),
                                                content: Text(
                                                    'No person is looking for a local in your place!'),
                                                actions: [
                                                  TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll<
                                                                  Color>(
                                                              Colors.red),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'Close',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SeeAllOffers(
                                        id: id!,
                                      ),
                                    ),
                                  );
                                });
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons
                                          .touch_app, // You can choose a different icon here
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Click to View Your Sent and Received Offers!",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: st
                          ? chatListDetails.length == 0
                              ? Container(
                                  alignment: Alignment.center,
                                  child: Text("No recent chats",
                                      style: GoogleFonts.poppins(
                                        fontSize: 22,
                                      )),
                                )
                              : MediaQuery.removePadding(
                                  removeTop: true,
                                  context: context,
                                  child: ListView.builder(
                                    itemCount: chatListDetails.length,
                                    itemBuilder: (context, index) {
                                      return StreamBuilder(
                                        stream: FirebaseDatabase.instance
                                            .reference()
                                            .child(
                                                chatListDetails[index].userUid)
                                            .onValue,
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
                                          if (snapshot.hasData) {
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Container(
                                                margin: EdgeInsets.all(1),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  gradient: chatListDetails[
                                                                  index]
                                                              .messageCount >
                                                          0
                                                      ? LinearGradient(
                                                          colors: [
                                                              Colors
                                                                  .lightBlueAccent
                                                                  .withOpacity(
                                                                      0.2),
                                                              Colors
                                                                  .lightBlueAccent
                                                                  .withOpacity(
                                                                      0.05)
                                                            ],
                                                          stops: [
                                                              0.1,
                                                              0.6
                                                            ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight)
                                                      : null,
                                                ),
                                                child: ListTile(
                                                  title: Text(
                                                    snapshot.data!.snapshot
                                                        .value['name'],
                                                    style: GoogleFonts.poppins(
                                                        fontWeight: chatListDetails[
                                                                        index]
                                                                    .messageCount >
                                                                0
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                        fontSize: 20),
                                                  ),
                                                  leading: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: InkWell(
                                                      onTap: () {
                                                        // Navigator.push(context,
                                                        // MaterialPageRoute(
                                                        //   builder: (context) => MyPhotoViewer(SERVER_ADDRESS + '/public/upload/profile/'+snapshot.data.snapshot.value['profile']),
                                                        // )
                                                        // );
                                                      },
                                                      child: Container(
                                                        height: 55,
                                                        width: 55,
                                                        color: Colors
                                                            .grey.shade300,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: snapshot
                                                                          .data!
                                                                          .snapshot
                                                                          .value[
                                                                      'profile'] ==
                                                                  null
                                                              ? " "
                                                              : SERVER_ADDRESS +
                                                                  '/public/upload/profile/' +
                                                                  snapshot
                                                                          .data!
                                                                          .snapshot
                                                                          .value[
                                                                      'profile'],
                                                          //imageUrl: snapshot.data.get('profile'),
                                                          fit: BoxFit.cover,
                                                          placeholder: (context,
                                                                  string) =>
                                                              Container(
                                                            height: 55,
                                                            width: 55,
                                                          ),
                                                          errorWidget: (context,
                                                                  err, f) =>
                                                              Icon(
                                                            Icons
                                                                .account_circle,
                                                            size: 50,
                                                            color: Colors
                                                                .grey.shade400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  trailing: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      chatListDetails[index]
                                                                  .messageCount ==
                                                              0
                                                          ? SizedBox()
                                                          : Container(
                                                              child: Center(
                                                                child: Text(
                                                                  chatListDetails[
                                                                          index]
                                                                      .messageCount
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient: LinearGradient(
                                                                    colors: [
                                                                      Colors
                                                                          .greenAccent
                                                                          .withOpacity(
                                                                              0.6),
                                                                      Colors
                                                                          .lightBlueAccent
                                                                    ],
                                                                    stops: [
                                                                      0.3,
                                                                      1
                                                                    ],
                                                                    begin: Alignment
                                                                        .topCenter,
                                                                    end: Alignment
                                                                        .bottomCenter),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                              height: 23,
                                                              width: 23,
                                                            ),
                                                      Text(
                                                        messageTiming(DateTime.parse(
                                                                chatListDetails[
                                                                        index]
                                                                    .time)
                                                            .toLocal()),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                  subtitle: typeToWidget(
                                                      chatListDetails[index]
                                                          .type,
                                                      chatListDetails[index]
                                                          .message,
                                                      chatListDetails[index]
                                                          .messageCount),
                                                  tileColor: Colors.transparent,
                                                  //tileColor: chatListDetails[index].messageCount > 0 ? Colors.grey.withOpacity(0.2) : Colors.white,
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatScreen(
                                                                snapshot
                                                                        .data!
                                                                        .snapshot
                                                                        .value[
                                                                    'name'],
                                                                chatListDetails[
                                                                        index]
                                                                    .userUid,
                                                                2165201,
                                                                true,
                                                                null,
                                                                "",
                                                                ""),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      );
                                    },
                                  ),
                                )
                          : Center(
                              child: CircularProgressIndicator(
                              color: const Color.fromARGB(255, 243, 103, 9),
                            )),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String messageTiming(DateTime dateTime) {
    if (DateTime.now().difference(dateTime).inDays == 0) {
      return "${dateTime.hour} : ${dateTime.minute < 10 ? "0" + dateTime.minute.toString() : dateTime.minute}";
    } else if (DateTime.now().difference(dateTime).inDays == 1) {
      return "yesterday";
    } else {
      return DateTime.now().difference(dateTime).inDays.toString() +
          " days ago";
    }
  }

  typeToWidget(int type, String msg, int count) {
    if (type == 1) {
      return Row(
        children: [
          Icon(
            Icons.photo,
            size: 15,
            color: Colors.grey.shade700,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Photo",
            style: TextStyle(
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    } else if (type == 2) {
      return Row(
        children: [
          Icon(
            Icons.videocam,
            size: 15,
            color: Colors.grey.shade700,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Video",
            style: TextStyle(
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    } else {
      return Text(
        msg,
        style: GoogleFonts.poppins(
          fontWeight: count > 0 ? FontWeight.bold : FontWeight.w400,
          color: count > 0 ? Colors.green : Colors.grey.shade600,
        ),
        overflow: TextOverflow.ellipsis,
      );
    }
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
                child: Text(INBOX,
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

class ChatListDetails {
  String message;
  String time;
  int type;
  String channelId;
  int messageCount;
  String userUid;

  ChatListDetails(
      {required this.message,
      required this.time,
      required this.type,
      required this.channelId,
      required this.messageCount,
      required this.userUid});
}
