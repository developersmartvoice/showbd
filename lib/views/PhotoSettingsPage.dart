import 'dart:convert';
import 'dart:io';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/views/Doctor/moreScreen/more_info_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class PhotoSettingsPage extends StatefulWidget {
  // const PhotoSettingsPage({super.key});
  String id;
  String img;
  List<String> imgs;

  PhotoSettingsPage(this.id, this.img, this.imgs);

  @override
  State<PhotoSettingsPage> createState() => _PhotoSettingsPageState();
}

class _PhotoSettingsPageState extends State<PhotoSettingsPage> {
  File? _image;
  bool isUploadClicked = false;
  bool isImageChanged = false;
  bool isDeletePressed = false;

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        isImageChanged = true;
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        isImageChanged = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Photos',
              style: Theme.of(context).textTheme.headline5!.apply(
                  color: Theme.of(context).backgroundColor,
                  fontWeightDelta: 5)),
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                if (isImageChanged) {
                  setState(() {
                    isUploadClicked = true;
                  });
                  _uploadImage();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('No Image Selected'),
                      content: Text('Please select an image before uploading.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text(
                'Save',
                style: GoogleFonts.robotoCondensed(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        body: isDeletePressed || isUploadClicked
            ? Container(
                alignment: Alignment.center,
                transformAlignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : Container(
                color: LIGHT_GREY_SCREEN_BACKGROUND,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Text(
                            PHOTOS_PAGE,
                            textAlign:
                                TextAlign.justify, // Align text to center
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            PHOTOS_PAGE_1,
                            textAlign:
                                TextAlign.justify, // Align text to center
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width *
                                  0.8, // 80% of screen width
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // First larger square box
                                  _image != null || widget.img.isNotEmpty
                                      ? InkWell(
                                          onTap: () {
                                            _showImagePreview();
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3, // 30% of screen width
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3, // 30% of screen width
                                            child: _image != null
                                                ? Image.file(_image!,
                                                    fit: BoxFit.cover)
                                                : CachedNetworkImage(
                                                    imageUrl: widget.img,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            _showImagePickerDialog();
                                          },
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3, // 30% of screen width
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3, // 30% of screen width
                                              color: Colors.grey[300],
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.camera_alt),
                                                  Text("Add Photo"),
                                                ],
                                              )),
                                        ),
                                  SizedBox(
                                      width:
                                          10), // Gap between first box and second row

                                  // Second row with two columns, each containing a square box
                                  Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2, // 20% of screen width
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.2, // 20% of screen width
                                        color: Colors.green,
                                        margin: EdgeInsets.only(
                                            bottom: 10), // Gap between boxes
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2, // 20% of screen width
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.2, // 20% of screen width
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 5), // Gap between columns

                                  // Third row with two columns, each containing a square box
                                  Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2, // 20% of screen width
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.2, // 20% of screen width
                                        color: Colors.yellow,
                                        margin: EdgeInsets.only(
                                            bottom: 10), // Gap between boxes
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2, // 20% of screen width
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.2, // 20% of screen width
                                        color: Colors.orange,
                                      ),
                                    ],
                                  ),
                                ],
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
    );
  }

  Future<void> _showImagePickerDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Photo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Take Photo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImageFromCamera();
                    // if (_image != null) {
                    //   setState(() {
                    //     isImageChanged = true;
                    //   });
                    // }
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImageFromGallery();
                    // if (_image != null) {
                    //   setState(() {
                    //     isImageChanged = true;
                    //   });
                    // }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  deleteImage() async {
    final response = await delete(
        Uri.parse("$SERVER_ADDRESS/api/deleteImage?doctor_id=${widget.id}"));
    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (jsonResponse['message'] == "Image deleted successfully") {
        setState(() {
          print("image deleted!");
          widget.img = "";
          isDeletePressed = false;
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(jsonResponse['message']),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                )
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Try Again Later"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                )
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(jsonResponse['error'] ?? "Unknown Error"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              )
            ],
          );
        },
      );
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    String fileName = _image!.path.split('/').last;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$SERVER_ADDRESS/api/updateImage'),
    );

    request.fields['doctor_id'] = widget.id;
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path,
        filename: fileName));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        setState(() {
          if (jsonResponse['data'] != null &&
              jsonResponse['data']['image'] != null) {
            widget.img = jsonResponse['data']['image'];
          }
          isUploadClicked = false;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text(jsonResponse['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: ((context) => MoreInfoScreen())));
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(jsonResponse['message'] ?? 'An error occurred'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to upload image'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _showImagePreview() {
    if (_image != null || widget.img.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.7,
              child: _image != null
                  ? Image.file(_image!, fit: BoxFit.contain)
                  : CachedNetworkImage(
                      imageUrl: widget.img,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // _showImagePickerDialog();
                      if (_image != null) {
                        setState(() {
                          _image = null;
                          isImageChanged = false;
                        });
                      } else {
                        setState(() {
                          isDeletePressed = true;
                        });
                        deleteImage();
                      }
                    },
                    child: Text("Delete Photo"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              )
            ],
          );
        },
      );
    }
  }
}
