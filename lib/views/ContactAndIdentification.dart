import 'package:appcode3/views/EmailDetailsPage.dart';
import 'package:appcode3/views/PhoneNumberPage.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class ContactAndIdentification extends StatefulWidget {
  // const ContactAndIdentification({super.key});
  late final String id;

  ContactAndIdentification(this.id);

  @override
  State<ContactAndIdentification> createState() => _GeneraLInfoState();
}

class _GeneraLInfoState extends State<ContactAndIdentification> {
  String? email;
  String? phone;

  getEmail() async {
    final response =
        await get(Uri.parse("$SERVER_ADDRESS/api/getEmail?id=${widget.id}"));
    print("$SERVER_ADDRESS/api/getEmail?id=${widget.id}");
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          email = jsonResponse['email'].toString();
          print(email);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getPhone() async {
    final response =
        await get(Uri.parse("$SERVER_ADDRESS/api/getPhoneNo?id=${widget.id}"));
    print("$SERVER_ADDRESS/api/getPhone?id=${widget.id}");
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          phone = jsonResponse['phoneno'].toString();
          print(phone);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  fetchedData() {
    getEmail();
    getPhone();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchedData();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      print("This is form Contact page: ${widget.id}");
    });
    return Scaffold(
        backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          centerTitle: true,
          title: Text(
            'Contact & Identification',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.045,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: WHITE, // Back button color
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: email != null && phone != null
            ? ContainerPage(widget.id, email!, phone!, _handleDataReload)
            : Container(
                alignment: Alignment.center,
                transformAlignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: const Color.fromARGB(255, 243, 103, 9),
                ),
              ));
  }

  // Add this method to handle the data reload
  void _handleDataReload(bool dataUpdated) {
    if (dataUpdated) {
      fetchedData();
    }
  }
}

class ContainerPage extends StatefulWidget {
  final String id;
  final String email;
  final String phone;
  final Function(bool) handleDataReload; // Add this field
  @override
  _ContainerPageState createState() => _ContainerPageState();

  ContainerPage(this.id, this.email, this.phone, this.handleDataReload);
}

class _ContainerPageState extends State<ContainerPage> {
  bool isEmailStored = false;
  bool isPhoneStored = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.email.isEmpty) {
      isEmailStored = false;
    } else {
      print("email is not empty");
      isEmailStored = true;
    }

    if (widget.phone.isEmpty) {
      isPhoneStored = false;
    } else {
      print("phone is not empty");
      isPhoneStored = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                height: 60,
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) =>
                            EmailDetailsPage(widget.id, widget.email),
                      ),
                    )
                        .then((dataUpdated) {
                      widget.handleDataReload(dataUpdated ?? false);
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * .1,
                            height: 25,
                            decoration: BoxDecoration(
                              color: widget.email.isNotEmpty
                                  ? Colors.green
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey, // Color of the border
                                width: 0.5, // Width of the border
                              ), // Circular shape
                            ),
                            child: Icon(
                              Icons.check,
                              //color: _isSelected ? Colors.green : Colors.white,
                              color: Colors.white, // Color of the icon
                              size: 20.0, // Size of the icon
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.sizeOf(context).width * .25,
                        child: Text(
                          "Email",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .1,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.sizeOf(context).width * .4,
                        child: Text(
                          widget.email,
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .01,
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * .1,
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.arrow_forward_ios, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.white10,
              ),
              Container(
                height: 60,
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) =>
                            PhoneNumberPage(widget.id, widget.phone),
                      ),
                    )
                        .then((dataUpdated) {
                      widget.handleDataReload(dataUpdated ?? false);
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * .1,
                            height: 25,
                            decoration: BoxDecoration(
                              //color: _boxColor, // Color of the button
                              color: widget.phone.isNotEmpty
                                  ? Colors.green
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey, // Color of the border
                                width: 0.5, // Width of the border
                              ), // Circular shape
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20.0, // Size of the icon
                            ),
                          )
                        ],
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.sizeOf(context).width * .25,
                          child: Text(
                            PHONE,
                            style: GoogleFonts.poppins(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.bold,
                              // color: Color.fromARGB(255, 243, 103, 9),
                            ),
                            overflow: TextOverflow.ellipsis,
                          )),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .1,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.sizeOf(context).width * .4,
                        child: Text(
                          widget.phone,
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .01,
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * .1,
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.arrow_forward_ios, size: 20),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 2,
                color: Colors.white10,
              ),
            ],
          ),
        )
      ],
    );
  }
}
