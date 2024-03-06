import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shurjopay/models/config.dart';
import 'package:shurjopay/models/payment_verification_model.dart';
import 'package:shurjopay/models/shurjopay_request_model.dart';
import 'package:shurjopay/models/shurjopay_response_model.dart';
import 'package:shurjopay/shurjopay.dart';

class ShurjoPayPayment extends StatefulWidget {
  const ShurjoPayPayment({Key? key}) : super(key: key);

  @override
  State<ShurjoPayPayment> createState() => _ShurjoPayPaymentState();
}

class _ShurjoPayPaymentState extends State<ShurjoPayPayment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  String? name, address, city;
  int? phoneNo, postalCode;
  ShurjoPay shurjoPay = ShurjoPay();

  ShurjopayConfigs shurjopayConfigs = ShurjopayConfigs(
    prefix: "sp",
    userName: "sp_sandbox",
    password: "pyyk97hu&6u6",
    clientIP: "127.0.0.1",
  );

  ShurjopayResponseModel shurjopayResponseModel = ShurjopayResponseModel();
  ShurjopayVerificationModel shurjopayVerificationModel =
      ShurjopayVerificationModel();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
                        "MEET LOCAL SUBSCRIBTION",
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
                              phoneNo = int.parse(value);
                            });
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          } else {
                            setState(() {
                              address = value.toString();
                            });
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
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
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _postalCodeController,
                        decoration: InputDecoration(
                          labelText: 'Postal Code',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              (value.length != 4 && int.parse(value) < 0)) {
                            return 'Please enter your postal code and length must be 4';
                          } else {
                            setState(() {
                              postalCode = int.parse(value);
                            });
                          }
                          return null;
                        },
                      ),
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
                            ShurjopayRequestModel shurjopayRequestModel =
                                ShurjopayRequestModel(
                              configs: shurjopayConfigs,
                              currency: "BDT",
                              amount: double.parse("1"),
                              orderID: "sp1ab2c3d4",
                              discountAmount: 0,
                              discountPercentage: 0,
                              customerName: name!,
                              customerPhoneNumber: phoneNo.toString(),
                              customerAddress: address!,
                              customerCity: city!,
                              customerPostcode: postalCode.toString(),
                              // Live: https://www.engine.shurjopayment.com/return_url
                              returnURL:
                                  "https://www.sandbox.shurjopayment.com/return_url",
                              // Live: https://www.engine.shurjopayment.com/cancel_url
                              cancelURL:
                                  "https://www.sandbox.shurjopayment.com/cancel_url",
                            );

                            shurjopayResponseModel =
                                await shurjoPay.makePayment(
                              context: context,
                              shurjopayRequestModel: shurjopayRequestModel,
                            );
                            if (shurjopayResponseModel.status == true) {
                              try {
                                shurjopayVerificationModel =
                                    await shurjoPay.verifyPayment(
                                  orderID:
                                      shurjopayResponseModel.shurjopayOrderID!,
                                );
                                print(shurjopayVerificationModel.spCode);
                                print(shurjopayVerificationModel.spMessage);
                                if (shurjopayVerificationModel.spCode ==
                                    "1000") {
                                  print("Payment Varified");
                                  _nameController.clear();
                                  _addressController.clear();
                                  _phoneNumberController.clear();
                                  _cityController.clear();
                                  _postalCodeController.clear();
                                }
                              } catch (error) {
                                print(error.toString());
                              }
                            }
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange, // Change button color
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
      ),
    );
  }
}
