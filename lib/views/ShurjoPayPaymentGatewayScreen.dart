import 'dart:convert';

import 'package:appcode3/main.dart';
import 'package:appcode3/views/Doctor/DoctorTabScreen.dart';
// import 'package:appcode3/views/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shurjopay/models/config.dart';
import 'package:shurjopay/models/payment_verification_model.dart';
import 'package:shurjopay/models/shurjopay_request_model.dart';
import 'package:shurjopay/models/shurjopay_response_model.dart';
import 'package:shurjopay/shurjopay.dart';

// ignore: must_be_immutable
class ShurjoPayPayment extends StatefulWidget {
  // const ShurjoPayPayment({Key? key}) : super(key: key);

  double amount;
  ShurjoPayPayment(this.amount);
  @override
  State<ShurjoPayPayment> createState() => _ShurjoPayPaymentState();
}

class _ShurjoPayPaymentState extends State<ShurjoPayPayment> {
  ShurjoPay shurjoPay = ShurjoPay();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  // TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  String? name, city, phoneNo;
  String address = "Bangladesh";
  int? postalCode;
  String? userId;
  String? orderId;
  String? referredId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) {
      userId = value.getString("userId");
      setState(() {
        // print(widget.amount);
        // print("Guide Id is: ${widget.id}");
        userId = value.getString("userId");
        getName();
        getPhoneNo();
        getCity();
        getReferredId();
        orderId = randomAlphaNumeric(8).toLowerCase();
        print("Order Id is: $orderId");
      });
    });
  }

  getReferredId() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/get_id_by_user_id?user_id=$userId"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        referredId = jsonResponse['referred_id'].toString();
      });
    } else {
      setState(() {
        referredId = "";
      });
    }
  }

  setMembershipStatus() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/set_membership?id=$userId"));
    if (response.statusCode == 200) {
      print("Membership successfully");
    }
  }

  getName() async {
    final response =
        await get(Uri.parse("$SERVER_ADDRESS/api/getName?id=${userId}"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        print("Name is: ${jsonResponse['name']}");
        name = jsonResponse['name'];
        _nameController.text = name ?? '';
      });
    } else {
      print("Name can not feteched!");
    }
  }

  getPhoneNo() async {
    final response =
        await get(Uri.parse("$SERVER_ADDRESS/api/getPhoneNo?id=${userId}"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        phoneNo = jsonResponse['phoneno'];
        _phoneNumberController.text = phoneNo ?? "";
      });
    }
  }

  getCity() async {
    final response =
        await get(Uri.parse("$SERVER_ADDRESS/api/getCity?id=${userId}"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        city = jsonResponse['city'];
        _cityController.text = city ?? '';
      });
    }
  }

  storeOrderId(String givenOrderId) async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/store_order_id"), body: {
      'order_id': givenOrderId,
      'guide_id': userId,
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['message'] == "Order ID Info created successfully") {
        print("OrderId Stored Successfully");
      } else {
        print(jsonResponse['message']);
      }
    } else {
      print("Api is not called properly");
    }
  }

  storeMembershipDetails() async {
    final response = await post(
        Uri.parse("$SERVER_ADDRESS/api/store_member_details"),
        body: {
          'guide_id': userId,
          'month': 1.toString(),
          'amount': widget.amount.toString(),
        });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['message'] == "Membership detail created successfully") {
        print("Member Details stored successfully!");
      } else {
        print("Something went wrong!");
      }
    } else {
      print("Api did not call properly!");
    }
  }

  storeReferreredBalance() async {
    final response = await post(
        Uri.parse("$SERVER_ADDRESS/api/set_referrered_balance"),
        body: {
          "referred_id": referredId,
          "user_id": userId,
          "currency": "BDT",
        });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse['success']);
    } else {
      print("Api did not call properly!");
    }
  }

  ShurjopayConfigs shurjopayConfigs = ShurjopayConfigs(
    prefix: "MT",
    userName: "smartlab",
    password: "smarsnfev#&#tjtw",
    clientIP: "127.0.0.1",
    // prefix: "NOK",
    // userName: "sp_sandbox",
    // password: "pyyk97hu&6u6",
    // clientIP: "127.0.0.1",
  );

  ShurjopayResponseModel shurjopayResponseModel = ShurjopayResponseModel();
  ShurjopayVerificationModel shurjopayVerificationModel =
      ShurjopayVerificationModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: WHITE,
        title: Text(
          "Payment",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue, // Change app bar color
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/moreScreenImages/header_bg.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      "MEET LOCAL SUBSCRIPTION",
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "for one month",
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      // initialValue: name ?? "",
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        } else {
                          setState(() {
                            name = value.toString();
                          });
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length != 11) {
                          return 'Please enter your phone number and length must be 11';
                        } else {
                          setState(() {
                            phoneNo = value;
                          });
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _addressController,
                    //   decoration: InputDecoration(
                    //     labelText: 'Address',
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter your address';
                    //     } else {
                    //       setState(() {
                    //         address = value.toString();
                    //       });
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // SizedBox(height: 20),
                    TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your city';
                        } else {
                          setState(() {
                            city = value.toString();
                          });
                        }
                        return null;
                      },
                    ),
                    // SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _postalCodeController,
                    //   decoration: InputDecoration(
                    //     labelText: 'Postal Code',
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   validator: (value) {
                    //     if (value == null ||
                    //         value.isEmpty ||
                    //         (value.length != 4 && int.parse(value) < 0)) {
                    //       return 'Please enter your postal code and length must be 4';
                    //     } else {
                    //       setState(() {
                    //         postalCode = int.parse(value);
                    //       });
                    //     }
                    //     return null;
                    //   },
                    // ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Form is valid, proceed with submission
                          // Add your logic here to handle form submission
                          setState(() {
                            print(
                                "Name: $name, Address: $address, Phone No: $phoneNo, City: $city, Postal Code: $postalCode");
                          });
                          print(shurjopayConfigs.clientIP);
                          ShurjopayRequestModel shurjopayRequestModel =
                              ShurjopayRequestModel(
                            configs: shurjopayConfigs,
                            currency: "BDT",
                            amount: widget.amount,
                            orderID: orderId!,
                            discountAmount: 0,
                            discountPercentage: 0,
                            customerName: name!,
                            // customerName: "Hello",
                            customerPhoneNumber: phoneNo.toString(),
                            // customerPhoneNumber: "01628734916",
                            customerAddress: address,
                            // customerAddress: "customer address",
                            customerCity: city!,
                            // customerCity: "customer city",
                            // customerPostcode: postalCode.toString(),
                            customerPostcode: "1212",
                            // Live: https://www.engine.shurjopayment.com/return_url
                            returnURL:
                                "https://www.engine.shurjopayment.com/return_url",
                            // "https://www.sandbox.shurjopayment.com/return_url",
                            // Live: https://www.engine.shurjopayment.com/cancel_url
                            cancelURL:
                                "https://www.engine.shurjopayment.com/cancel_url",
                            // "https://www.sandbox.shurjopayment.com/cancel_url",
                          );

                          shurjopayResponseModel = await shurjoPay.makePayment(
                            context: context,
                            shurjopayRequestModel: shurjopayRequestModel,
                          );
                          print(
                              "Checking status: ${shurjopayResponseModel.status}");
                          print(shurjopayResponseModel.errorCode);
                          if (shurjopayResponseModel.status == true) {
                            // try {} catch (e) {}
                            try {
                              shurjopayVerificationModel =
                                  await shurjoPay.verifyPayment(
                                orderID:
                                    shurjopayResponseModel.shurjopayOrderID!,
                              );
                              print(
                                  "This is shurjopay id: ${shurjopayVerificationModel.id}");

                              print(shurjopayVerificationModel.spCode);
                              print(shurjopayVerificationModel.spMessage);
                              if (shurjopayVerificationModel.spCode == "1000") {
                                print("Payment Varified");
                                print(
                                    "This is shurjopay orderId from verification Model: ${shurjopayVerificationModel.orderId}");
                                storeOrderId(
                                    shurjopayVerificationModel.orderId!);
                                storeMembershipDetails();
                                setMembershipStatus();
                                if (referredId != null ||
                                    referredId!.isNotEmpty) {
                                  storeReferreredBalance();
                                }
                                print(
                                    shurjopayVerificationModel.customerOrderId);
                                // _nameController.clear();
                                // _addressController.clear();
                                // _phoneNumberController.clear();
                                // _cityController.clear();
                                // _postalCodeController.clear();
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => HomeScreen()));
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DoctorTabsScreen()));
                              }
                            } catch (error) {
                              print(error.toString());
                            }
                          }
                        }
                      },
                      child: Text(
                        'Confirm Your Subscription',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Change button color
                        padding: EdgeInsets.symmetric(
                          vertical: 15.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
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
}
