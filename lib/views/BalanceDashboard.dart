// import 'package:flutter/material.dart';

// class BalanceDashboard extends StatefulWidget {
//   final String userId;
//   const BalanceDashboard({super.key, required this.userId});
//   @override
//   _BalanceDashboardState createState() => _BalanceDashboardState();
// }

// class _BalanceDashboardState extends State<BalanceDashboard>
//     with SingleTickerProviderStateMixin {
//   double currentMonthEarnings = 0.0;
//   double totalEarnings = 0.0;
//   double withdrawalBalance = 0.0;
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );
//     _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//     _controller.forward();
//     fetchBalanceData();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> fetchBalanceData() async {
//     // Simulating API call
//     await Future.delayed(Duration(seconds: 2));

//     // Example data, replace with your API call and response handling
//     setState(() {
//       currentMonthEarnings = 1200.50;
//       totalEarnings = 5000.75;
//       withdrawalBalance = 300.25;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Balance Dashboard'),
//         backgroundColor: Colors.orange,
//       ),
//       body: FadeTransition(
//         opacity: _animation,
//         child: ListView(
//           padding: EdgeInsets.all(16.0),
//           children: [
//             _buildBalanceCard(
//               'Current Month\'s Earnings',
//               currentMonthEarnings,
//               Icons.calendar_today,
//             ),
//             _buildBalanceCard(
//               'Total Earnings',
//               totalEarnings,
//               Icons.attach_money,
//             ),
//             _buildBalanceCard(
//               'Withdrawal Balance',
//               withdrawalBalance,
//               Icons.account_balance_wallet,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle button press
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 padding: EdgeInsets.symmetric(vertical: 15.0),
//               ),
//               child: Text(
//                 'Withdraw',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBalanceCard(String title, double amount, IconData icon) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       elevation: 5,
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.orange,
//               child: Icon(icon, size: 30, color: Colors.white),
//             ),
//             SizedBox(width: 20),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   '\$${amount.toStringAsFixed(2)}',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.green,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:appcode3/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

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

  showMessage() {
    // showLicensePage(context: context)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
      backgroundColor: WHITE,
      appBar: AppBar(
        title: Text(
          "Balance Dashboard",
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.headline5!.apply(
                color: Theme.of(context).backgroundColor,
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
                                "- To earn money, you need to take the membership first.",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "- Then, you can refer your friends to register the app.",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "- If your referred friend takes membership of this app, you will get 15% of the fees.",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "- This money will be earned for a lifetime.",
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
                    // TextButton.icon(
                    //   onPressed: () {},
                    //   icon: Icon(Icons.monetization_on),
                    //   label: Text("Withdraw"),
                    //   style: ButtonStyle(
                    //     textStyle: MaterialStatePropertyAll(
                    //       TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     foregroundColor: MaterialStatePropertyAll(
                    //       Color.fromARGB(255, 243, 103, 9),
                    //     ),
                    //     elevation: MaterialStatePropertyAll(5),
                    //     shape: MaterialStatePropertyAll(
                    //       OvalBorder(
                    //         side: BorderSide(
                    //           width: 1.5,
                    //           color: Color.fromARGB(255, 243, 103, 9),
                    //         ),
                    //       ),
                    //     ),
                    //     padding: MaterialStatePropertyAll(
                    //       EdgeInsets.all(16),
                    //     ),
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Withdraw"),
                      style: ButtonStyle(
                        textStyle: MaterialStatePropertyAll(
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 243, 103, 9),
                        ),
                        foregroundColor: MaterialStatePropertyAll(WHITE),
                        elevation: MaterialStatePropertyAll(5),
                        padding: MaterialStatePropertyAll(
                          EdgeInsets.all(16),
                        ),
                      ),
                    ),
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
