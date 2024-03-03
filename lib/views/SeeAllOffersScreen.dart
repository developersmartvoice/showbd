import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:flutter/material.dart';

class SeeAllOffers extends StatefulWidget {
  const SeeAllOffers({super.key});

  @override
  State<SeeAllOffers> createState() => _SeeAllOffersState();
}

class _SeeAllOffersState extends State<SeeAllOffers> {
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
