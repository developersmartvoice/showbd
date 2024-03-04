import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/OffersClassReceiver.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SeeAllOffers extends StatefulWidget {
  // const SeeAllOffers({super.key});

  final String? id;
  SeeAllOffers({required this.id});

  @override
  State<SeeAllOffers> createState() => _SeeAllOffersState();
}

class _SeeAllOffersState extends State<SeeAllOffers> {
  OffersClassReceiver? offersClassReceiver;

  bool isSenderSelected = true;

  Future<void> getOffersReceiver() async {
    var response = await http.get(
      Uri.parse("$SERVER_ADDRESS/api/notifyGuidesAboutTrip?id=${widget.id}"),
    );
    if (response.statusCode == 200) {
      print(response.body);
      var data = json.decode(response.body);
      setState(() {
        offersClassReceiver = OffersClassReceiver.fromJson(data);
        print("");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              header(),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isSenderSelected = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSenderSelected != null && isSenderSelected!
                                ? Colors.orange
                                : Color.fromARGB(255, 242, 235,
                                    235), // Change the colors as needed
                      ),
                      child: Text(
                        'Sender',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.5,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isSenderSelected = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSenderSelected != null && isSenderSelected!
                                ? Color.fromARGB(255, 242, 235, 235)
                                : Colors.orange, // Change the colors as needed
                      ),
                      child: Text(
                        'Recipient',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.5,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ));
  }

  Widget header() {
    return Stack(
      children: [
        Image.asset(
          "assets/moreScreenImages/header_bg.png",
          height: 60,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              Title(
                color: BLACK,
                child: Text(ALL_OFFERS,
                    style: Theme.of(context).textTheme.headline5!.apply(
                        color: Theme.of(context).backgroundColor,
                        fontWeightDelta: 5)),
              ),
            ],
          ),
        ),
        Container(
          height: 60,
        )
      ],
    );
  }
}
