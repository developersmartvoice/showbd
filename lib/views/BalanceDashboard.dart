import 'dart:convert';

import 'package:appcode3/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class BalanceDashboard extends StatefulWidget {
  final String userId;
  const BalanceDashboard({super.key, required this.userId});

  @override
  State<BalanceDashboard> createState() => _BalanceDashboardState();
}

class _BalanceDashboardState extends State<BalanceDashboard> {
  double totalMoney = 0.00;
  double currentMotnth = 0.00;
  double prevMonth = 0.00;
  double withdrawMoney = 0.00;
  bool withdrawalAllowed = false;
  String withdrawalMessage = "";
  String nextWithdrawalDate = "";

  getAllBalances() async {
    final response = await get(Uri.parse(
        "$SERVER_ADDRESS/api/get_all_balances?referred_id=${widget.userId}"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        totalMoney = double.parse(jsonResponse['total_earnings']);
        currentMotnth = double.parse(jsonResponse['current_month_earnings']);
        prevMonth = double.parse(jsonResponse['previous_month_earnings']);
        withdrawMoney = double.parse(jsonResponse['withdrawal_balance']);
        withdrawalAllowed = jsonResponse['withdrawal_allowed'];
        withdrawalMessage = jsonResponse['withdrawal_message'].toString();
        nextWithdrawalDate = jsonResponse['next_withdrawal_date'].toString();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllBalances();
  }

  @override
  Widget build(BuildContext context) {
    print(withdrawalMessage);
    print(nextWithdrawalDate);
    print(withdrawalAllowed);
    return Scaffold(
      // backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
      backgroundColor: WHITE,
      appBar: AppBar(
        title: Text(
          "Balance Dashboard",
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.headlineSmall!.apply(
                color: Theme.of(context).primaryColorDark,
                fontWeightDelta: 1,
                fontSizeFactor: .8),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 243, 103, 9),
        foregroundColor: WHITE,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.history_sharp),
            style: ButtonStyle(
              elevation: MaterialStatePropertyAll(5),
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Stack(
                    children: <Widget>[
                      Dialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
//                               Text(
//                                 '''
// - To earn money, you need to take the membership first.
// - Then, you can refer your friends to register the app.
// - If your referred friend takes membership of this app, you will get 15% of the fees.
// - This money will be earned for a lifetime.
//                   ''',
//                                 style: TextStyle(
//                                   fontSize: 16.0,
//                                 ),
//                               ),
                              Text(
                                "1. To earn money, you need to take the membership first.",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "2. Then, you can refer your friends to register the app.",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "3. If your referred friend takes membership of this app, you will get 15% of the fees.",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "4. This money will be earned for a lifetime.",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button background color
                            child: InkWell(
                              splashColor:
                                  Colors.white.withAlpha(30), // Splash color
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: SizedBox(
                                width: 36,
                                height: 36,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  weight: 50,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.info),
            style: ButtonStyle(
              elevation: MaterialStatePropertyAll(5),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width,
                // padding: EdgeInsets.all(16),
                // color: Colors.blue,
                decoration: BoxDecoration(
                  // border: Border.all(style: BorderStyle.solid),
                  border: BorderDirectional(
                    bottom: BorderSide(
                      color: Color.fromARGB(255, 243, 103, 9),
                      width: 2,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/withdrawal.png",
                      height: 80,
                      width: 80,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Withdrawal Balance",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        decoration: TextDecoration.overline,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "৳ ${totalMoney.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double
                          .infinity, // Make the container take the full width
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: withdrawalAllowed
                                  ? () {
                                      // Your onPressed logic here
                                    }
                                  : null,
                              child: Text("Withdraw"),
                              style: ButtonStyle(
                                textStyle: MaterialStatePropertyAll(
                                  TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                                backgroundColor: MaterialStatePropertyAll(
                                  withdrawalAllowed
                                      ? Color.fromARGB(255, 243, 103, 9)
                                      : Colors.grey,
                                ),
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                elevation: MaterialStatePropertyAll(5),
                                padding: MaterialStatePropertyAll(
                                  EdgeInsets.all(16),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton.filled(
                              onPressed: () {
                                // Your onPressed logic here
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          withdrawalMessage,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      // insetPadding: EdgeInsets.all(50),
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.question_mark_sharp,
                                size: 14,
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                // color: Colors.green,
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        width: MediaQuery.of(context).size.width * .5,
                        // color: Colors.white,
                        decoration: BoxDecoration(
                          border: BorderDirectional(
                            end: BorderSide(
                              color: Color.fromARGB(255, 243, 103, 9),
                              width: 2,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/current_money.png",
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Current Month Balance",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                // letterSpacing: 2,
                                // decoration: TextDecoration.overline,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "৳ ${withdrawMoney.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        width: MediaQuery.of(context).size.width * .5,
                        // color: Colors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/previous_month.png",
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Previous Month Balance",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                // letterSpacing: 2,
                                // decoration: TextDecoration.overline,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "৳ ${prevMonth.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width,
                // padding: EdgeInsets.all(16),
                // color: const Color.fromARGB(255, 248, 17, 0),
                decoration: BoxDecoration(
                  // border: Border.all(style: BorderStyle.solid),
                  border: BorderDirectional(
                    top: BorderSide(
                      color: Color.fromARGB(255, 243, 103, 9),
                      width: 2,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/total.png",
                      height: 80,
                      width: 80,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Total Earnings",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        decoration: TextDecoration.overline,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "৳ ${currentMotnth.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
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
