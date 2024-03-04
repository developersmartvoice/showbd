import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/OffersClassSender.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SeeAllOffers extends StatefulWidget {
  // const SeeAllOffers({super.key});
  final String id;

  SeeAllOffers({required this.id});

  @override
  State<SeeAllOffers> createState() => _SeeAllOffersState();
}

class _SeeAllOffersState extends State<SeeAllOffers> {
  OffersClassSender? offersClassSender;

  @override
  void initState() {
    super.initState();
    setState(() {
      getSenderOffers();
    });
  }

  getSenderOffers() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getSendOffers?id=${widget.id}"));
    print("$SERVER_ADDRESS/api/getSendOffers?id=${widget.id}");
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      setState(() {
        offersClassSender = OffersClassSender.fromJson(jsonResponse);
        print(offersClassSender!.dataForChat);
        print(offersClassSender!.dataForShow);
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
            children: [header()],
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
