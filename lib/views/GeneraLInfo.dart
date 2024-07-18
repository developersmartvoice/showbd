import 'package:appcode3/views/AboutMeDetailsPage.dart';
import 'package:appcode3/views/LocationSearchPageInfo.dart';
import 'package:appcode3/views/NameSettingsPage.dart';
import 'package:appcode3/views/PhotoSettingsPage.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class GeneraLInfo extends StatefulWidget {
  final String doctorId;
  const GeneraLInfo(this.doctorId, {super.key});

  // GeneraLInfo(this.doctorId);

  @override
  State<GeneraLInfo> createState() => _GeneraLInfoState();
}

class _GeneraLInfoState extends State<GeneraLInfo> {
  String name = '';
  String about_me = '';
  String location = '';
  String photos = '';
  String imageUrl1 = '';
  List<String>? imageUrls;

  bool isNameFetched = false;
  bool isAboutMeFetched = false;
  bool isLocationFetched = false;
  bool isPhotosFetched = false;

  getName() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getName?id=${widget.doctorId}"));
    print("$SERVER_ADDRESS/api/getName?id=${widget.doctorId}");
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          name = jsonResponse['name'].toString();
          print(name);
          isNameFetched = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getAboutMe() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getAboutUs?id=${widget.doctorId}"));
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          about_me = jsonResponse['aboutus'].toString();
          print(about_me);
          isAboutMeFetched = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getCity() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getCity?id=${widget.doctorId}"));
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          location = jsonResponse['city'].toString();
          print(location);
          isLocationFetched = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getImage() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getImage?doctor_id=${widget.doctorId}"));

    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          imageUrl1 = jsonResponse['image_url'] ?? "";

          print("Only Image downloaded and assigned: $imageUrl1");
        });
      } else {
        print("Failed to fetch image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching image: $e");
    }
  }

  Future<void> getImages() async {
    final Uri uri =
        Uri.parse("$SERVER_ADDRESS/api/getImages?doctor_id=${widget.doctorId}");
    final response = await get(uri);

    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        imageUrls = List<String>.from(jsonResponse['image_urls'] ?? "");
        setState(() {
          if (imageUrls == null) {
            imageUrls = [];
            isPhotosFetched = true;
          } else {
            isPhotosFetched = true;
            imageUrls!.forEach((imageUrl) {
              print("Image downloaded and assigned: $imageUrl");
              // Here you can do whatever you want with the downloaded images
            });
          }
        });
      } else {
        print("Failed to fetch images. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchedData();
  }

  fetchedData() {
    getName();
    getAboutMe();
    getCity();
    getImage();
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Pop the dialog if it's open
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
          return false; // Prevent default back button behavior
        }
        return true; // Allow default back button behavior
      },
      child: Scaffold(
        backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          centerTitle: true,
          title: Text(
            'General information',
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.headlineSmall!.apply(
                  color: Theme.of(context).primaryColorDark,
                  fontWeightDelta: 1,
                  fontSizeFactor: .8),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white, // Back button color
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ),
        body: isNameFetched &&
                isPhotosFetched &&
                isLocationFetched &&
                isAboutMeFetched
            ? ContainerPage(widget.doctorId, name, about_me, location,
                imageUrl1, imageUrls!, _handleDataReload)
            : Container(
                alignment: Alignment.center,
                transformAlignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: const Color.fromARGB(255, 243, 103, 9),
                )),
      ),
    );
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
  final String name;
  final String aboutMe;
  final String city;
  final String imageUrl1;
  // final String imageUrls;
  final List<String> imageUrls;
  final Function(bool) handleDataReload; // Add this field

  ContainerPage(this.id, this.name, this.aboutMe, this.city, this.imageUrl1,
      this.imageUrls, this.handleDataReload);
  @override
  _ContainerPageState createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  bool isNameStored = false;
  bool isAboutMeStored = false;
  bool isLocationStored = false;
  bool isPhotoStored = false;
  bool isImageStored = false;

  @override
  void initState() {
    super.initState();
    if (widget.name.isNotEmpty) {
      setState(() {
        isNameStored = true;
      });
    }

    if (widget.aboutMe != "null") {
      print("This is about me: ${widget.aboutMe}");
      setState(() {
        isAboutMeStored = true;
      });
    }

    if (widget.city != "null") {
      setState(() {
        isLocationStored = true;
      });
    }
    if (widget.imageUrl1.isNotEmpty) {
      setState(() {
        isPhotoStored = true;
      });
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
                            NameSettingsPage(widget.id, widget.name),
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
                              color: widget.name.isNotEmpty
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
                          NAME,
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold,
                            // color: Color.fromARGB(255, 243, 103, 9),
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
                          widget.name,
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
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
                            AboutMeDetailsPage(widget.id, widget.aboutMe),
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
                              // color: widget.aboutMe.isNotEmpty
                              color: widget.aboutMe != "null"
                                  ? Colors.green
                                  : Colors.grey,
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
                            ABOUT,
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
                          widget.aboutMe != 'null'
                              ? widget.aboutMe
                              : "Add About me",
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
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
                        builder: (context) => PhotoSettingsPage(
                            widget.id, widget.imageUrl1, widget.imageUrls),
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
                              color: isPhotoStored ? Colors.green : Colors.grey,
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
                      // SizedBox(
                      //   width: MediaQuery.sizeOf(context).width * .01,
                      // ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.sizeOf(context).width * .25,
                        child: Text(
                          'Photos',
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
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
                        child: Text(""),
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
                            LocationSearchPageInfo(widget.id, widget.city),
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
                              color: widget.city != "null"
                                  ? Colors.green
                                  : Colors.grey,
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
                            LOCATION,
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
                          widget.city != 'null' ? widget.city : "Add your city",
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
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
