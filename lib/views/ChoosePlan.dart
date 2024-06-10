// import 'dart:convert';

// import 'package:appcode3/main.dart';
// import 'package:appcode3/views/ShurjoPayPaymentGatewayScreen.dart';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ChoosePlan extends StatefulWidget {
//   const ChoosePlan({super.key});

//   @override
//   State<ChoosePlan> createState() => _ChoosePlanState();
// }

// class _ChoosePlanState extends State<ChoosePlan> {
//   String? currency;
//   bool isLimitedSelected = false;
//   double? amount;

//   get isFadeOut => true;

//   @override
//   void initState() {
//     super.initState();
//     print(currency);
//     SharedPreferences.getInstance().then((prefs) {
//       setState(() {
//         if (prefs.containsKey("Currency") &&
//             prefs.getString("Currency") != null) {
//           currency = prefs.getString("Currency")!;
//         } else {
//           currency = "BDT";
//         }
//         print(currency);
//         getAmount(currency!); // Assuming this function is defined elsewhere
//       });
//     });
//   }

//   Future<void> getAmount(String cur) async {
//     final response = await get(
//         Uri.parse("$SERVER_ADDRESS/api/get_amount_info?currency=${cur}"));
//     if (response.statusCode == 200) {
//       final jsonRespone = jsonDecode(response.body);
//       setState(() {
//         amount = double.tryParse(jsonRespone['amount']);
//         print("This is amount: $amount");
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Image.asset(
//           "assets/moreScreenImages/header_bg.png",
//           height: 140,
//           fit: BoxFit.fill,
//           width: MediaQuery.of(context).size.width,
//         ),
//         SafeArea(
//           child: Scaffold(
//               appBar: AppBar(
//                 backgroundColor: const Color.fromARGB(255, 243, 103, 9),
//                 title: Text(
//                   'Choose a Plan',
//                   style: Theme.of(context).textTheme.headline5!.apply(
//                       color: Theme.of(context).backgroundColor,
//                       fontWeightDelta: 5),
//                 ),
//                 centerTitle: true,
//                 leading: IconButton(
//                   icon: Icon(Icons.arrow_back),
//                   color: WHITE,
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//               body: amount != null
//                   ? SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             // Row with 2 ToggleButtons
//                             Container(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   ElevatedButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           if (!isLimitedSelected) {
//                                             isLimitedSelected = true;
//                                           }
//                                         });
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         foregroundColor: isLimitedSelected
//                                             ? Colors.white
//                                             : Colors.black,
//                                         textStyle: GoogleFonts.robotoCondensed(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                         backgroundColor: isLimitedSelected
//                                             ? Color.fromARGB(255, 243, 103, 9)
//                                             : Colors.white, // Text color
//                                         // elevation: 5, // Elevation
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                               15), // Border radius
//                                         ),
//                                         minimumSize: Size(
//                                             160, 50), // Set width and height
//                                       ),
//                                       child: Text("Limited")),
//                                   SizedBox(
//                                     width: 2,
//                                   ),
//                                   ElevatedButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           isLimitedSelected = false;
//                                         });
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         foregroundColor: isLimitedSelected
//                                             ? Colors.black
//                                             : Colors.white,
//                                         textStyle: GoogleFonts.robotoCondensed(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                         backgroundColor: isLimitedSelected
//                                             ? Colors.white
//                                             : const Color.fromARGB(
//                                                 255, 243, 103, 9), // Text color
//                                         // elevation: 5, // Elevation
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                               15), // Border radius
//                                         ),
//                                         minimumSize: Size(
//                                             160, 50), // Set width and height
//                                       ),
//                                       child: Text("Extended"))
//                                 ],
//                               ),
//                             ),

//                             // Elevated Button in Column
//                             SizedBox(height: 30),

//                             // Container with 4 Avatars and Text in Rows
//                             SizedBox(height: 16),
//                             Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         child: Stack(
//                                           children: [
//                                             CircleAvatar(
//                                               radius: 40,
//                                               backgroundImage: AssetImage(
//                                                   'assets/people 1.png'),
//                                             ),
//                                             Positioned(
//                                               bottom: -10,
//                                               right: -10,
//                                               child: CircleAvatar(
//                                                 radius:
//                                                     20, // Adjust the radius as needed
//                                                 backgroundImage: AssetImage(
//                                                     'assets/srch.png'),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 15,
//                                       ),
//                                       Container(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Browse locals',
//                                               style:
//                                                   GoogleFonts.robotoCondensed(
//                                                 fontSize: 27,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             Text(
//                                               'See available guides',
//                                               style:
//                                                   GoogleFonts.robotoCondensed(
//                                                 fontSize: 18,
//                                                 color: Color.fromARGB(131, 0, 0,
//                                                     0), // You can customize the style as needed
//                                               ),
//                                             ),
//                                             Text(
//                                               'for all locations',
//                                               style:
//                                                   GoogleFonts.robotoCondensed(
//                                                 fontSize: 18,
//                                                 color: Color.fromARGB(131, 0, 0,
//                                                     0), // You can customize the style as needed
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 30,
//                                   ),
//                                   Container(
//                                     child: isLimitedSelected
//                                         ? AnimatedOpacity(
//                                             duration: Duration(seconds: 1),
//                                             opacity: isFadeOut ? 0.25 : 1.0,
//                                             child: Row(
//                                               //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                               children: [
//                                                 Container(
//                                                   child: Stack(
//                                                     children: [
//                                                       CircleAvatar(
//                                                         radius: 40,
//                                                         backgroundImage: AssetImage(
//                                                             'assets/people 2.png'),
//                                                       ),
//                                                       Positioned(
//                                                         bottom: -3,
//                                                         right: -8,
//                                                         child: CircleAvatar(
//                                                           radius:
//                                                               20, // Adjust the radius as needed
//                                                           backgroundImage:
//                                                               AssetImage(
//                                                                   'assets/map 3.png'),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 15,
//                                                 ),
//                                                 Container(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         'Create a trip',
//                                                         style: GoogleFonts
//                                                             .robotoCondensed(
//                                                           fontSize: 27,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                       Text(
//                                                         'Get "MeetLocal" offers',
//                                                         style: GoogleFonts
//                                                             .robotoCondensed(
//                                                           fontSize: 18,
//                                                           color: Color.fromARGB(
//                                                               131,
//                                                               0,
//                                                               0,
//                                                               0), // You can customize the style as needed
//                                                         ),
//                                                       ),
//                                                       Text(
//                                                         'from locals',
//                                                         style: GoogleFonts
//                                                             .robotoCondensed(
//                                                           fontSize: 18,
//                                                           color: Color.fromARGB(
//                                                               131,
//                                                               0,
//                                                               0,
//                                                               0), // You can customize the style as needed
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           )
//                                         : Row(
//                                             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                             children: [
//                                               Container(
//                                                 child: Stack(
//                                                   children: [
//                                                     CircleAvatar(
//                                                       radius: 40,
//                                                       backgroundImage: AssetImage(
//                                                           'assets/people 2.png'),
//                                                     ),
//                                                     Positioned(
//                                                       bottom: -3,
//                                                       right: -8,
//                                                       child: CircleAvatar(
//                                                         radius:
//                                                             20, // Adjust the radius as needed
//                                                         backgroundImage: AssetImage(
//                                                             'assets/map 3.png'),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 15,
//                                               ),
//                                               Container(
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       'Create a trip',
//                                                       style: GoogleFonts
//                                                           .robotoCondensed(
//                                                         fontSize: 27,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       'Get "MeetLocal" offers',
//                                                       style: GoogleFonts
//                                                           .robotoCondensed(
//                                                         fontSize: 18,
//                                                         color: Color.fromARGB(
//                                                             131,
//                                                             0,
//                                                             0,
//                                                             0), // You can customize the style as needed
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       'from locals',
//                                                       style: GoogleFonts
//                                                           .robotoCondensed(
//                                                         fontSize: 18,
//                                                         color: Color.fromARGB(
//                                                             131,
//                                                             0,
//                                                             0,
//                                                             0), // You can customize the style as needed
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                   ),
//                                   //),
//                                   //),
//                                   SizedBox(
//                                     height: 30,
//                                   ),

//                                   Container(
//                                     //color: Color.fromARGB(100, 236, 231, 231),
//                                     child: isLimitedSelected
//                                         ? AnimatedOpacity(
//                                             duration: Duration(seconds: 1),
//                                             opacity: isFadeOut ? 0.25 : 1.0,
//                                             child: Row(
//                                               children: [
//                                                 Container(
//                                                   child: Stack(
//                                                     children: [
//                                                       CircleAvatar(
//                                                         radius: 40,
//                                                         backgroundImage: AssetImage(
//                                                             'assets/people 3.png'),
//                                                       ),
//                                                       Positioned(
//                                                         bottom: 0,
//                                                         right: 0,
//                                                         child: CircleAvatar(
//                                                           radius:
//                                                               15, // Adjust the radius as needed
//                                                           backgroundImage:
//                                                               AssetImage(
//                                                                   'assets/telegram icon.png'),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 15,
//                                                 ),
//                                                 Container(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         'Send Offers',
//                                                         style: GoogleFonts
//                                                             .robotoCondensed(
//                                                           fontSize: 27,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                       Text(
//                                                         'Connect with travellers',
//                                                         style: GoogleFonts
//                                                             .robotoCondensed(
//                                                           fontSize: 18,
//                                                           color: Color.fromARGB(
//                                                               131,
//                                                               0,
//                                                               0,
//                                                               0), // You can customize the style as needed
//                                                         ),
//                                                       ),
//                                                       Text(
//                                                         'who visit your city',
//                                                         style: GoogleFonts
//                                                             .robotoCondensed(
//                                                           fontSize: 18,
//                                                           color: Color.fromARGB(
//                                                               131,
//                                                               0,
//                                                               0,
//                                                               0), // You can customize the style as needed
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           )
//                                         : Row(
//                                             children: [
//                                               Container(
//                                                 child: Stack(
//                                                   children: [
//                                                     CircleAvatar(
//                                                       radius: 40,
//                                                       backgroundImage: AssetImage(
//                                                           'assets/people 3.png'),
//                                                     ),
//                                                     Positioned(
//                                                       bottom: 0,
//                                                       right: 0,
//                                                       child: CircleAvatar(
//                                                         radius:
//                                                             15, // Adjust the radius as needed
//                                                         backgroundImage: AssetImage(
//                                                             'assets/telegram icon.png'),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 15,
//                                               ),
//                                               Container(
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       'Send Offers',
//                                                       style: GoogleFonts
//                                                           .robotoCondensed(
//                                                         fontSize: 27,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       'Connect with travellers',
//                                                       style: GoogleFonts
//                                                           .robotoCondensed(
//                                                         fontSize: 18,
//                                                         color: Color.fromARGB(
//                                                             131,
//                                                             0,
//                                                             0,
//                                                             0), // You can customize the style as needed
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       'who visit your city',
//                                                       style: GoogleFonts
//                                                           .robotoCondensed(
//                                                         fontSize: 18,
//                                                         color: Color.fromARGB(
//                                                             131,
//                                                             0,
//                                                             0,
//                                                             0), // You can customize the style as needed
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                   ),

//                                   SizedBox(
//                                     height: 30,
//                                   ),

//                                   Container(
//                                     child: isLimitedSelected
//                                         ? AnimatedOpacity(
//                                             duration: Duration(seconds: 1),
//                                             opacity: isFadeOut ? 0.25 : 1.0,
//                                             child: Row(
//                                               //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                               children: [
//                                                 Container(
//                                                   child: Stack(
//                                                     children: [
//                                                       CircleAvatar(
//                                                         radius: 40,
//                                                         backgroundImage: AssetImage(
//                                                             'assets/people 5.png'),
//                                                       ),
//                                                       Positioned(
//                                                         bottom: -3,
//                                                         right: -5,
//                                                         child: CircleAvatar(
//                                                           radius:
//                                                               20, // Adjust the radius as needed
//                                                           backgroundImage:
//                                                               AssetImage(
//                                                                   'assets/whatsapp icon.png'),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 15,
//                                                 ),
//                                                 Container(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         'Pick a Local',
//                                                         style: GoogleFonts
//                                                             .robotoCondensed(
//                                                           fontSize: 27,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                       Text(
//                                                         'Contact those you like',
//                                                         style: GoogleFonts
//                                                             .robotoCondensed(
//                                                           fontSize: 18,
//                                                           color: Color.fromARGB(
//                                                               131,
//                                                               0,
//                                                               0,
//                                                               0), // You can customize the style as needed
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           )
//                                         : Row(
//                                             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                             children: [
//                                               Container(
//                                                 child: Stack(
//                                                   children: [
//                                                     CircleAvatar(
//                                                       radius: 40,
//                                                       backgroundImage: AssetImage(
//                                                           'assets/people 5.png'),
//                                                     ),
//                                                     Positioned(
//                                                       bottom: -3,
//                                                       right: -5,
//                                                       child: CircleAvatar(
//                                                         radius:
//                                                             20, // Adjust the radius as needed
//                                                         backgroundImage: AssetImage(
//                                                             'assets/whatsapp icon.png'),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 15,
//                                               ),
//                                               Container(
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       'Pick a Local',
//                                                       style: GoogleFonts
//                                                           .robotoCondensed(
//                                                         fontSize: 27,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       'Contact those you like',
//                                                       style: GoogleFonts
//                                                           .robotoCondensed(
//                                                         fontSize: 18,
//                                                         color: Color.fromARGB(
//                                                             131,
//                                                             0,
//                                                             0,
//                                                             0), // You can customize the style as needed
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             SizedBox(
//                               height: 30,
//                             ),

//                             Container(
//                               child: isLimitedSelected
//                                   ? Container()
//                                   : Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           'Member Subscription for',
//                                           style: GoogleFonts.robotoCondensed(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         Text(
//                                           currency == 'USD'
//                                               ? '\$' +
//                                                   '${amount!.toStringAsFixed(2)}'
//                                               : '৳' +
//                                                   '${amount!.toStringAsFixed(2)}',
//                                           style: GoogleFonts.robotoCondensed(
//                                             fontSize: 16,
//                                             color: Colors
//                                                 .black, // You can customize the style as needed
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                             ),

//                             SizedBox(
//                               height: 15,
//                             ),

//                             ElevatedButton(
//                               onPressed: () {
//                                 !isLimitedSelected
//                                     ? Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 // BookingScreen(widget.id, widget.guideName),
//                                                 ShurjoPayPayment(amount!)),
//                                       )
//                                     : Navigator.of(context).pop();
//                               },
//                               child: Text('Continue'),
//                               style: ElevatedButton.styleFrom(
//                                 textStyle: GoogleFonts.robotoCondensed(
//                                   fontSize: 25.0,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
//                                 foregroundColor: Colors.white,
//                                 backgroundColor:
//                                     Color.fromARGB(255, 243, 103, 9),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   side: BorderSide(
//                                     color: Colors.white,
//                                   ), // Set border radius
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : Container(
//                       alignment: Alignment.center,
//                       transformAlignment: Alignment.center,
//                       child: CircularProgressIndicator(
//                         color: Color.fromARGB(255, 243, 103, 9),
//                       ),
//                     )),
//         ),
//       ],
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String? currency;
  bool isLimitedSelected = false;
  double? amount;

  get isFadeOut => true;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        currency = prefs.getString("Currency") ?? "BDT";
        getAmount(currency!);
      });
    });
  }

  Future<void> getAmount(String cur) async {
    final response = await http
        .get(Uri.parse("$SERVER_ADDRESS/api/get_amount_info?currency=$cur"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        amount = double.tryParse(jsonResponse['amount']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/moreScreenImages/header_bg.png",
          height: 140,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
        SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 243, 103, 9),
              title: Text(
                'Choose a Plan',
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
            body: amount != null
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildToggleButtons(),
                        const SizedBox(height: 20),
                        buildFeatureList(),
                        const SizedBox(height: 35),
                        buildSubscriptionInfo(),
                        const SizedBox(height: 20),
                        buildContinueButton(context),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: const Color.fromARGB(255, 243, 103, 9),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildToggleButton("Limited", true),
        const SizedBox(width: 2),
        buildToggleButton("Extended", false),
      ],
    );
  }

  ElevatedButton buildToggleButton(String label, bool isLimited) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isLimitedSelected = isLimited;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isLimitedSelected == isLimited
            ? Colors.white
            : Color.fromARGB(255, 243, 103, 9),
        textStyle: GoogleFonts.robotoCondensed(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: isLimitedSelected == isLimited
            ? const Color.fromARGB(255, 243, 103, 9)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        minimumSize: const Size(120, 40),
      ),
      child: Text(label),
    );
  }

  Widget buildFeatureList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildFeatureRow(
            'assets/people 1.png',
            'assets/srch.png',
            'Browse locals',
            'See available guides',
            'for all locations',
            false),
        const SizedBox(height: 20),
        buildFeatureRow('assets/people 2.png', 'assets/map 3.png',
            'Create a trip', 'Get "MeetLocal" offers', 'from locals', true),
        const SizedBox(height: 20),
        buildFeatureRow(
            'assets/people 3.png',
            'assets/telegram icon.png',
            'Send Offers',
            'Connect with travellers',
            'who visit your city',
            true),
        const SizedBox(height: 20),
        buildFeatureRow('assets/people 5.png', 'assets/whatsapp icon.png',
            'Pick a Local', 'Contact those you like', '', true),
      ],
    );
  }

  Widget buildFeatureRow(String mainImage, String iconImage, String title,
      String subtitle1, String subtitle2, bool applyOpacity) {
    return applyOpacity && isLimitedSelected
        ? AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: isFadeOut ? 0.25 : 1.0,
            child: featureRowContent(
                mainImage, iconImage, title, subtitle1, subtitle2),
          )
        : featureRowContent(mainImage, iconImage, title, subtitle1, subtitle2);
  }

  Widget featureRowContent(String mainImage, String iconImage, String title,
      String subtitle1, String subtitle2) {
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(radius: 30, backgroundImage: AssetImage(mainImage)),
            Positioned(
              bottom: -3,
              right: -8,
              child: CircleAvatar(
                  radius: 15, backgroundImage: AssetImage(iconImage)),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.robotoCondensed(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            Text(subtitle1,
                style: GoogleFonts.robotoCondensed(
                    fontSize: 14, color: const Color.fromARGB(131, 0, 0, 0))),
            if (subtitle2.isNotEmpty)
              Text(subtitle2,
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 14, color: const Color.fromARGB(131, 0, 0, 0))),
          ],
        ),
      ],
    );
  }

  Widget buildSubscriptionInfo() {
    if (!isLimitedSelected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Member Subscription for a month',
              maxLines: 2,
              style: GoogleFonts.robotoCondensed(
                  fontSize: 18, fontWeight: FontWeight.w500)),
          Text(
            currency == 'USD'
                ? '\$${amount!.toStringAsFixed(2)}'
                : '৳${amount!.toStringAsFixed(2)}',
            style:
                GoogleFonts.robotoCondensed(fontSize: 18, color: Colors.black),
          ),
        ],
      );
    }
    return Container();
  }

  ElevatedButton buildContinueButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (!isLimitedSelected) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ShurjoPayPayment(amount!)),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Text('Continue'),
      style: ElevatedButton.styleFrom(
        textStyle: GoogleFonts.robotoCondensed(
            fontSize: 20.0, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 243, 103, 9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
