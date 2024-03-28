import 'package:appcode3/views/ShurjoPayPaymentGatewayScreen.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChoosePlan extends StatefulWidget {
  const ChoosePlan({super.key});

  @override
  State<ChoosePlan> createState() => _ChoosePlanState();
}

class _ChoosePlanState extends State<ChoosePlan> {
  String? currency;
  bool isLimitedSelected = false;
  double amount = 1;

  get isFadeOut => true;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        currency = value.getString("Currency");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          title: Text(
            'Choose a Plan',
            style: Theme.of(context).textTheme.headline5!.apply(
                color: Theme.of(context).backgroundColor, fontWeightDelta: 5),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Row with 2 ToggleButtons
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (!isLimitedSelected) {
                                isLimitedSelected = true;
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                isLimitedSelected ? Colors.white : Colors.black,
                            textStyle: GoogleFonts.robotoCondensed(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            backgroundColor: isLimitedSelected
                                ? Color.fromARGB(255, 243, 103, 9)
                                : Colors.white, // Text color
                            // elevation: 5, // Elevation
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(15), // Border radius
                            ),
                            minimumSize: Size(160, 50), // Set width and height
                          ),
                          child: Text("Limited")),
                      SizedBox(
                        width: 2,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLimitedSelected = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                isLimitedSelected ? Colors.black : Colors.white,
                            textStyle: GoogleFonts.robotoCondensed(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            backgroundColor: isLimitedSelected
                                ? Colors.white
                                : const Color.fromARGB(
                                    255, 243, 103, 9), // Text color
                            // elevation: 5, // Elevation
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(15), // Border radius
                            ),
                            minimumSize: Size(160, 50), // Set width and height
                          ),
                          child: Text("Extended"))
                    ],
                  ),
                ),

                // Elevated Button in Column
                SizedBox(height: 30),

                // Container with 4 Avatars and Text in Rows
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                          AssetImage('assets/people 1.png'),
                                    ),
                                    Positioned(
                                      bottom: -10,
                                      right: -10,
                                      child: CircleAvatar(
                                        radius:
                                            20, // Adjust the radius as needed
                                        backgroundImage:
                                            AssetImage('assets/srch.png'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Browse locals',
                                      style: GoogleFonts.robotoCondensed(
                                        fontSize: 27,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'See available guides',
                                      style: GoogleFonts.robotoCondensed(
                                        fontSize: 18,
                                        color: Color.fromARGB(131, 0, 0,
                                            0), // You can customize the style as needed
                                      ),
                                    ),
                                    Text(
                                      'for all locations',
                                      style: GoogleFonts.robotoCondensed(
                                        fontSize: 18,
                                        color: Color.fromARGB(131, 0, 0,
                                            0), // You can customize the style as needed
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                          AssetImage('assets/people 2.png'),
                                    ),
                                    Positioned(
                                      bottom: -3,
                                      right: -8,
                                      child: CircleAvatar(
                                        radius:
                                            20, // Adjust the radius as needed
                                        backgroundImage:
                                            AssetImage('assets/map 3.png'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Create a trip',
                                      style: GoogleFonts.robotoCondensed(
                                        fontSize: 27,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Get "MeetLocal" offers',
                                      style: GoogleFonts.robotoCondensed(
                                        fontSize: 18,
                                        color: Color.fromARGB(131, 0, 0,
                                            0), // You can customize the style as needed
                                      ),
                                    ),
                                    Text(
                                      'from locals',
                                      style: GoogleFonts.robotoCondensed(
                                        fontSize: 18,
                                        color: Color.fromARGB(131, 0, 0,
                                            0), // You can customize the style as needed
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //),
                          //),
                          SizedBox(
                            height: 30,
                          ),

                          Container(
                            //color: Color.fromARGB(100, 236, 231, 231),
                            child: isLimitedSelected
                                ? AnimatedOpacity(
                                    duration: Duration(seconds: 1),
                                    opacity: isFadeOut ? 0.25 : 1.0,
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Stack(
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundImage: AssetImage(
                                                    'assets/people 3.png'),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: CircleAvatar(
                                                  radius:
                                                      15, // Adjust the radius as needed
                                                  backgroundImage: AssetImage(
                                                      'assets/telegram icon.png'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Send Offers',
                                                style:
                                                    GoogleFonts.robotoCondensed(
                                                  fontSize: 27,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Connect with travellers',
                                                style:
                                                    GoogleFonts.robotoCondensed(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      131,
                                                      0,
                                                      0,
                                                      0), // You can customize the style as needed
                                                ),
                                              ),
                                              Text(
                                                'who visit your city',
                                                style:
                                                    GoogleFonts.robotoCondensed(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      131,
                                                      0,
                                                      0,
                                                      0), // You can customize the style as needed
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Container(
                                        child: Stack(
                                          children: [
                                            CircleAvatar(
                                              radius: 40,
                                              backgroundImage: AssetImage(
                                                  'assets/people 3.png'),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: CircleAvatar(
                                                radius:
                                                    15, // Adjust the radius as needed
                                                backgroundImage: AssetImage(
                                                    'assets/telegram icon.png'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Send Offers',
                                              style:
                                                  GoogleFonts.robotoCondensed(
                                                fontSize: 27,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Connect with travellers',
                                              style:
                                                  GoogleFonts.robotoCondensed(
                                                fontSize: 18,
                                                color: Color.fromARGB(131, 0, 0,
                                                    0), // You can customize the style as needed
                                              ),
                                            ),
                                            Text(
                                              'who visit your city',
                                              style:
                                                  GoogleFonts.robotoCondensed(
                                                fontSize: 18,
                                                color: Color.fromARGB(131, 0, 0,
                                                    0), // You can customize the style as needed
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),

                          SizedBox(
                            height: 30,
                          ),

                          Container(
                            child: isLimitedSelected
                                ? AnimatedOpacity(
                                    duration: Duration(seconds: 1),
                                    opacity: isFadeOut ? 0.25 : 1.0,
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: Stack(
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundImage: AssetImage(
                                                    'assets/people 5.png'),
                                              ),
                                              Positioned(
                                                bottom: -3,
                                                right: -5,
                                                child: CircleAvatar(
                                                  radius:
                                                      20, // Adjust the radius as needed
                                                  backgroundImage: AssetImage(
                                                      'assets/whatsapp icon.png'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Pick a Local',
                                                style:
                                                    GoogleFonts.robotoCondensed(
                                                  fontSize: 27,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Contact those you like',
                                                style:
                                                    GoogleFonts.robotoCondensed(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      131,
                                                      0,
                                                      0,
                                                      0), // You can customize the style as needed
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: Stack(
                                          children: [
                                            CircleAvatar(
                                              radius: 40,
                                              backgroundImage: AssetImage(
                                                  'assets/people 5.png'),
                                            ),
                                            Positioned(
                                              bottom: -3,
                                              right: -5,
                                              child: CircleAvatar(
                                                radius:
                                                    20, // Adjust the radius as needed
                                                backgroundImage: AssetImage(
                                                    'assets/whatsapp icon.png'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Pick a Local',
                                              style:
                                                  GoogleFonts.robotoCondensed(
                                                fontSize: 27,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Contact those you like',
                                              style:
                                                  GoogleFonts.robotoCondensed(
                                                fontSize: 18,
                                                color: Color.fromARGB(131, 0, 0,
                                                    0), // You can customize the style as needed
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                Container(
                  child: isLimitedSelected
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Member Subscription for',
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '৳${amount.toStringAsFixed(2)}',
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 16,
                                color: Colors
                                    .black, // You can customize the style as needed
                              ),
                            ),
                          ],
                        ),
                ),

                SizedBox(
                  height: 15,
                ),

                ElevatedButton(
                  onPressed: () {
                    !isLimitedSelected
                        ? Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    // BookingScreen(widget.id, widget.guideName),
                                    ShurjoPayPayment(amount)),
                          )
                        : Navigator.of(context).pop();
                  },
                  child: Text('Continue'),
                  style: ElevatedButton.styleFrom(
                    textStyle: GoogleFonts.robotoCondensed(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 243, 103, 9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: Colors.white,
                      ), // Set border radius
                    ),
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
