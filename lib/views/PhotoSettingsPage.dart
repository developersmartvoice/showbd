import 'dart:convert';
import 'dart:io';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

// ignore: must_be_immutable
class PhotoSettingsPage extends StatefulWidget {
  String id;
  String img;
  List<String> imgs;

  PhotoSettingsPage(this.id, this.img, this.imgs);

  @override
  State<PhotoSettingsPage> createState() => _PhotoSettingsPageState();
}

class _PhotoSettingsPageState extends State<PhotoSettingsPage> {
  File? _image;
  List<File?> _images = List<File?>.filled(4, null);
  List<String> imagesBox = List.generate(4, (index) => "");
  bool isUploadClicked = false;
  bool isImageChanged = false;
  bool isImagesChanged = false;
  bool isDeletePressed = false;

  // Future<void> _getImageFromGallery(int index) async {
  //   final pickedFile =
  //       await ImagePicker().getImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     switch (index) {
  //       case 0:
  //         setState(() {
  //           _images[0] = File(pickedFile.path);
  //           isImagesChanged = true;
  //         });
  //         break;
  //       case 1:
  //         setState(() {
  //           _images[1] = File(pickedFile.path);
  //           isImagesChanged = true;
  //         });
  //         break;
  //       case 2:
  //         setState(() {
  //           _images[2] = File(pickedFile.path);
  //           isImagesChanged = true;
  //         });
  //         break;
  //       case 3:
  //         setState(() {
  //           _images[3] = File(pickedFile.path);
  //           isImagesChanged = true;
  //         });
  //         break;
  //       default:
  //         setState(() {
  //           _image = File(pickedFile.path);
  //           isImageChanged = true;
  //         });
  //     }
  //   }
  // }

  // Future<void> _getImageFromCamera(int index) async {
  //   final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
  //   if (pickedFile != null) {
  //     switch (index) {
  //       case 0:
  //         setState(() {
  //           _images[0] = File(pickedFile.path);
  //           isImagesChanged = true;
  //         });
  //         break;
  //       case 1:
  //         setState(() {
  //           _images[1] = File(pickedFile.path);
  //           isImagesChanged = true;
  //         });
  //         break;
  //       case 2:
  //         setState(() {
  //           _images[2] = File(pickedFile.path);
  //           isImagesChanged = true;
  //         });
  //         break;
  //       case 3:
  //         setState(() {
  //           _images[3] = File(pickedFile.path);
  //           isImagesChanged = true;
  //         });
  //         break;
  //       default:
  //         setState(() {
  //           _image = File(pickedFile.path);
  //           isImageChanged = true;
  //         });
  //     }
  //   }
  // }

  Future<void> _getImageFromGallery(int index) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File? croppedFile = await _cropImage(pickedFile.path);

      if (croppedFile != null) {
        setState(() {
          switch (index) {
            case 0:
              _images[0] = croppedFile;
              isImagesChanged = true;
              break;
            case 1:
              _images[1] = croppedFile;
              isImagesChanged = true;
              break;
            case 2:
              _images[2] = croppedFile;
              isImagesChanged = true;
              break;
            case 3:
              _images[3] = croppedFile;
              isImagesChanged = true;
              break;
            default:
              _image = croppedFile;
              isImageChanged = true;
          }
        });
      }
    }
  }

  Future<void> _getImageFromCamera(int index) async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File? croppedFile = await _cropImage(pickedFile.path);

      if (croppedFile != null) {
        setState(() {
          switch (index) {
            case 0:
              _images[0] = croppedFile;
              isImagesChanged = true;
              break;
            case 1:
              _images[1] = croppedFile;
              isImagesChanged = true;
              break;
            case 2:
              _images[2] = croppedFile;
              isImagesChanged = true;
              break;
            case 3:
              _images[3] = croppedFile;
              isImagesChanged = true;
              break;
            default:
              _image = croppedFile;
              isImageChanged = true;
          }
        });
      }
    }
  }

  Future<File?> _cropImage(String imagePath) async {
    final imageCropper = ImageCropper();
    CroppedFile? croppedFile = await imageCropper.cropImage(
      sourcePath: imagePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        // CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return null;
    }
  }

  loadImagesBox() {
    for (int i = 0; i < widget.imgs.length; i++) {
      imagesBox[i] = widget.imgs[i];
    }
    print("Here are the images: $imagesBox");
  }

  @override
  void initState() {
    super.initState();
    loadImagesBox();
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
                if (isImageChanged && isImagesChanged) {
                  setState(() {
                    isUploadClicked = true;
                  });
                  _uploadImage();
                  _uploadImages();
                } else if (isImageChanged) {
                  setState(() {
                    isUploadClicked = true;
                  });
                  _uploadImage();
                } else if (isImagesChanged) {
                  setState(() {
                    isUploadClicked = true;
                  });
                  _uploadImages();
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
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ),
        body: isDeletePressed || isUploadClicked
            ? Container(
                alignment: Alignment.center,
                transformAlignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: const Color.fromARGB(255, 243, 103, 9),
                ),
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
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.025,
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
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.025,
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
                                                        CircularProgressIndicator(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 243, 103, 9),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            _showImagePickerDialog(-1);
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
                                      _images[0] != null ||
                                              imagesBox[0].isNotEmpty
                                          ? InkWell(
                                              onTap: () {
                                                _showImagesPreview(0);
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2, // 20% of screen width
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2, // 30% of screen width
                                                child: _images[0] != null
                                                    ? Image.file(_images[0]!,
                                                        fit: BoxFit.cover)
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            widget.imgs[0],
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 243, 103, 9),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                _showImagePickerDialog(0);
                                              },
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2, // 20% of screen width
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2, // 30% of screen width
                                                  color: Colors.grey[300],
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.camera_alt),
                                                      Text("Add Photo"),
                                                    ],
                                                  )),
                                            ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      _images[2] != null ||
                                              imagesBox[2].isNotEmpty
                                          ? InkWell(
                                              onTap: () {
                                                _showImagesPreview(2);
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2, // 20% of screen width
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2, // 30% of screen width
                                                child: _images[2] != null
                                                    ? Image.file(_images[2]!,
                                                        fit: BoxFit.cover)
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            widget.imgs[2],
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 243, 103, 9),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                _showImagePickerDialog(2);
                                              },
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2, // 20% of screen width
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2, // 30% of screen width
                                                  color: Colors.grey[300],
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.camera_alt),
                                                      Text("Add Photo"),
                                                    ],
                                                  )),
                                            ),
                                    ],
                                  ),
                                  SizedBox(width: 5), // Gap between columns

                                  // // Third row with two columns, each containing a square box
                                  Column(
                                    children: [
                                      _images[1] != null ||
                                              imagesBox[1].isNotEmpty
                                          ? InkWell(
                                              onTap: () {
                                                _showImagesPreview(1);
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2, // 20% of screen width
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2, // 30% of screen width
                                                child: _images[1] != null
                                                    ? Image.file(_images[1]!,
                                                        fit: BoxFit.cover)
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            widget.imgs[1],
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 243, 103, 9),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                _showImagePickerDialog(1);
                                              },
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2, // 20% of screen width
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2, // 30% of screen width
                                                  color: Colors.grey[300],
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.camera_alt),
                                                      Text("Add Photo"),
                                                    ],
                                                  )),
                                            ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      _images[3] != null ||
                                              imagesBox[3].isNotEmpty
                                          ? InkWell(
                                              onTap: () {
                                                _showImagesPreview(3);
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2, // 20% of screen width
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2, // 30% of screen width
                                                child: _images[3] != null
                                                    ? Image.file(_images[3]!,
                                                        fit: BoxFit.cover)
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            widget.imgs[3],
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 243, 103, 9),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                _showImagePickerDialog(3);
                                              },
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2, // 20% of screen width
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2, // 30% of screen width
                                                  color: Colors.grey[300],
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.camera_alt),
                                                      Text("Add Photo"),
                                                    ],
                                                  )),
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

  Future<void> _showImagePickerDialog(int index) async {
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
                    _getImageFromCamera(index);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImageFromGallery(index);
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
                    Navigator.of(context).pop(true);
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

  String imagesBody(int index) {
    Map<String, dynamic> requestBody = {
      'doctor_id': widget.id,
      'index': index,
    };

    return jsonEncode(requestBody);
  }

  deleteImages(int index) async {
    final response = await delete(Uri.parse("$SERVER_ADDRESS/api/deleteImages"),
        body: imagesBody(index), headers: {"Content-Type": "application/json"});
    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (jsonResponse['message'] == "Image deleted successfully") {
        setState(() {
          print("image deleted!");
          widget.imgs[index] = "";
          loadImagesBox();
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
                    Navigator.of(context).pop(true);
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
                  setState(() {
                    isDeletePressed = false;
                  });
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
                  Navigator.of(context).pop(true);
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
                  setState(() {
                    isUploadClicked = false;
                  });
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

  Future<void> _uploadImages() async {
    try {
      // Check if _images list is empty
      if (_images.isEmpty) {
        // Show error message if no images are selected
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Please select at least one image to upload'),
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
        return;
      }

      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$SERVER_ADDRESS/api/updateImages'),
      );

      // Add doctor_id to the request
      request.fields['doctor_id'] = widget.id; // Replace with actual doctor_id

      // Add images to the request
      for (int i = 0; i < _images.length; i++) {
        print(_images[i]);
        print(_images.length);
        if (_images[i] != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'images[]', // Match the API parameter name
            _images[i]!.path,
          ));
        }
      }

      // Send the request
      var response = await request.send();

      // Check the response status
      if (response.statusCode == 200) {
        setState(() {
          isUploadClicked = false;
        });
        // If successful, show success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Images uploaded successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          isUploadClicked = false;
        });
        // If not successful, show error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to upload images'),
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
    } catch (e) {
      // Handle exceptions
      print('Error uploading images: $e');
      setState(() {
        isUploadClicked = false;
      });
      // Show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Error uploading images. Please try again later.'),
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
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.width * 1,
              child: _image != null
                  ? Image.file(_image!, fit: BoxFit.contain)
                  : CachedNetworkImage(
                      imageUrl: widget.img,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => CircularProgressIndicator(
                        color: const Color.fromARGB(255, 243, 103, 9),
                      ),
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
                      // Navigator.of(context).pop(true);
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

  void _showImagesPreview(int index) {
    if (_images[index] != null || widget.imgs[index].isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.width * 1,
              child: _images[index] != null
                  ? Image.file(_images[index]!, fit: BoxFit.contain)
                  : CachedNetworkImage(
                      imageUrl: widget.imgs[index],
                      fit: BoxFit.contain,
                      placeholder: (context, url) => CircularProgressIndicator(
                        color: const Color.fromARGB(255, 243, 103, 9),
                      ),
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
                      if (_images[index] != null) {
                        setState(() {
                          _images[index] = null;
                          isImagesChanged = false;
                        });
                      } else {
                        setState(() {
                          isDeletePressed = true;
                        });
                        deleteImages(index);
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
