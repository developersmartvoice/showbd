import 'dart:convert';
import 'package:appcode3/views/Doctor/RegisterAsDoctor.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/views/ShurjoPayPaymentGatewayScreen.dart';

class ChoosePlan extends StatefulWidget {
  const ChoosePlan({super.key});

  @override
  State<ChoosePlan> createState() => _ChoosePlanState();
}

class _ChoosePlanState extends State<ChoosePlan> {
  bool isLoggedIn = false;
  String? currency;
  bool isLimitedSelected = false;
  double amount = 0.0;

  get isFadeOut => true;

  @override
  void initState() {
    super.initState();
    checkLoggedIn();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        currency = prefs.getString("Currency") ?? "BDT";
        getAmount(currency!);
      });
    });
  }

  void checkLoggedIn() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        isLoggedIn = prefs.getBool("isLoggedInAsDoctor") ?? false;
      });
    });
  }

  Future<void> getAmount(String cur) async {
    final response = await http
        .get(Uri.parse("$SERVER_ADDRESS/api/get_amount_info?currency=$cur"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        amount = double.parse(jsonResponse['amount']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(isLoggedIn);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 103, 9),
        title: Text(
          // "Two Steps to follow",
          "Choose Plan",
          style: Theme.of(context).textTheme.headline5!.apply(
                color: Theme.of(context).backgroundColor,
                fontWeightDelta: 5,
              ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // body: amount != null
      //     ? SingleChildScrollView(
      //         padding: const EdgeInsets.all(16.0),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.stretch,
      //           children: [
      //             buildToggleButtons(),
      //             const SizedBox(height: 20),
      //             buildFeatureList(),
      //             const SizedBox(height: 35),
      //             buildSubscriptionInfo(),
      //             const SizedBox(height: 20),
      //             buildContinueButton(context),
      //           ],
      //         ),
      //       )
      //     : Center(
      //         child: CircularProgressIndicator(
      //           color: const Color.fromARGB(255, 243, 103, 9),
      //         ),
      //       ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Card(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: Color.fromARGB(255, 243, 103, 9),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "One Month Plan",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              "Amount",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                                height: 2,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              "${amount.toString()}/৳ only",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Features",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.brightness_1,
                            size: 16,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Direct Contacts",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.brightness_1,
                            size: 16,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Create Tips",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.brightness_1,
                            size: 16,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Unlocked All Features",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            isLoggedIn
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShurjoPayPayment(amount)))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterAsDoctor(
                                        isFromChoosePlan: true,
                                      ),
                                    ),
                                  );
                          },
                          child: Text("Proceed"),
                          style: ButtonStyle(
                            elevation: MaterialStatePropertyAll(5),
                            padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8,
                              ),
                            ),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            foregroundColor: MaterialStatePropertyAll(
                              Colors.white,
                            ),
                            backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 243, 103, 9),
                            ),
                            shadowColor: MaterialStatePropertyAll(Colors.black),
                            textStyle: MaterialStatePropertyAll(
                              TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget buildToggleButtons() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       buildToggleButton("Limited", true),
  //       const SizedBox(width: 2),
  //       buildToggleButton("Extended", false),
  //     ],
  //   );
  // }

  // ElevatedButton buildToggleButton(String label, bool isLimited) {
  //   return ElevatedButton(
  //     onPressed: () {
  //       setState(() {
  //         isLimitedSelected = isLimited;
  //       });
  //     },
  //     style: ElevatedButton.styleFrom(
  //       foregroundColor: isLimitedSelected == isLimited
  //           ? Colors.white
  //           : Color.fromARGB(255, 243, 103, 9),
  //       textStyle: GoogleFonts.robotoCondensed(
  //         fontSize: 16,
  //         fontWeight: FontWeight.w500,
  //       ),
  //       backgroundColor: isLimitedSelected == isLimited
  //           ? const Color.fromARGB(255, 243, 103, 9)
  //           : Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(15),
  //       ),
  //       minimumSize: const Size(120, 40),
  //     ),
  //     child: Text(label),
  //   );
  // }

  // Widget buildFeatureList() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       buildFeatureRow(
  //         'assets/people 1.png',
  //         'assets/srch.png',
  //         'Browse locals',
  //         'See available guides',
  //         'for all locations',
  //         false,
  //       ),
  //       const SizedBox(height: 20),
  //       buildFeatureRow(
  //         'assets/people 2.png',
  //         'assets/map 3.png',
  //         'Create a trip',
  //         'Get "MeetLocal" offers',
  //         'from locals',
  //         true,
  //       ),
  //       const SizedBox(height: 20),
  //       buildFeatureRow(
  //         'assets/people 3.png',
  //         'assets/telegram icon.png',
  //         'Send Offers',
  //         'Connect with travellers',
  //         'who visit your city',
  //         true,
  //       ),
  //       const SizedBox(height: 20),
  //       buildFeatureRow(
  //         'assets/people 5.png',
  //         'assets/whatsapp icon.png',
  //         'Pick a Local',
  //         'Contact those you like',
  //         '',
  //         true,
  //       ),
  //     ],
  //   );
  // }

  // Widget buildFeatureRow(String mainImage, String iconImage, String title,
  //     String subtitle1, String subtitle2, bool applyOpacity) {
  //   return applyOpacity && isLimitedSelected
  //       ? AnimatedOpacity(
  //           duration: const Duration(seconds: 1),
  //           opacity: isFadeOut ? 0.25 : 1.0,
  //           child: featureRowContent(
  //               mainImage, iconImage, title, subtitle1, subtitle2),
  //         )
  //       : featureRowContent(mainImage, iconImage, title, subtitle1, subtitle2);
  // }

  // Widget featureRowContent(String mainImage, String iconImage, String title,
  //     String subtitle1, String subtitle2) {
  //   return Row(
  //     children: [
  //       Stack(
  //         children: [
  //           CircleAvatar(radius: 30, backgroundImage: AssetImage(mainImage)),
  //           Positioned(
  //             bottom: -3,
  //             right: -8,
  //             child: CircleAvatar(
  //                 radius: 15, backgroundImage: AssetImage(iconImage)),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(width: 10),
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(title,
  //               style: GoogleFonts.robotoCondensed(
  //                   fontSize: 20, fontWeight: FontWeight.bold)),
  //           Text(subtitle1,
  //               style: GoogleFonts.robotoCondensed(
  //                   fontSize: 14, color: const Color.fromARGB(131, 0, 0, 0))),
  //           if (subtitle2.isNotEmpty)
  //             Text(subtitle2,
  //                 style: GoogleFonts.robotoCondensed(
  //                     fontSize: 14, color: const Color.fromARGB(131, 0, 0, 0))),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget buildSubscriptionInfo() {
  //   if (!isLimitedSelected) {
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Text('Member Subscription for a month',
  //             maxLines: 2,
  //             style: GoogleFonts.robotoCondensed(
  //                 fontSize: 18, fontWeight: FontWeight.w500)),
  //         Text(
  //           currency == 'USD'
  //               ? '\$${amount.toStringAsFixed(2)}'
  //               : '৳${amount.toStringAsFixed(2)}',
  //           style:
  //               GoogleFonts.robotoCondensed(fontSize: 18, color: Colors.black),
  //         ),
  //       ],
  //     );
  //   }
  //   return Container();
  // }

  // ElevatedButton buildContinueButton(BuildContext context) {
  //   return ElevatedButton(
  //     onPressed: () {
  //       if (!isLimitedSelected) {
  //         Navigator.of(context).push(
  //           MaterialPageRoute(builder: (context) => ShurjoPayPayment(amount)),
  //         );
  //       } else {
  //         Navigator.of(context).pop();
  //       }
  //     },
  //     child: Text('Continue'),
  //     style: ElevatedButton.styleFrom(
  //       textStyle: GoogleFonts.robotoCondensed(
  //           fontSize: 20.0, fontWeight: FontWeight.bold),
  //       padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
  //       foregroundColor: Colors.white,
  //       backgroundColor: const Color.fromARGB(255, 243, 103, 9),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10.0),
  //         side: const BorderSide(color: Colors.white),
  //       ),
  //     ),
  //   );
  // }
}
