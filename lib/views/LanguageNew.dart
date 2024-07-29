import 'package:flutter/material.dart';
import 'package:appcode3/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class LanguageNew extends StatefulWidget {
  @override
  State<LanguageNew> createState() => _LanguageNewState();
  final String id;
  final List<String> languages;
  LanguageNew(this.id, this.languages);
}

class _LanguageNewState extends State<LanguageNew> {
  List<String> selectedLanguages = [];
  bool isLanguageSelected = false;
  bool loading = false;

  void updatingLanguages() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateLanguages"), body: {
      "id": widget.id,
      "languages": selectedLanguages.join(','), // Convert list to string
    });
    print("$SERVER_ADDRESS/api/updateLanguages");
    print(response.body);
    if (response.statusCode == 200) {
      print("Language Updated");
      setState(() {
        loading = false;
        Navigator.of(context).pop(true);
      });
    } else {
      print("Language Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    selectedLanguages =
        List.from(widget.languages); // Initialize selectedLanguages
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }

  Widget buildLanguageItem(String key, String title) {
    bool isSelected = selectedLanguages.contains(key);

    return Column(
      children: [
        ListTile(
          title: Text(capitalizeFirstLetter(title)),
          trailing: isSelected ? Icon(Icons.check) : null,
          onTap: () {
            setState(() {
              isSelected
                  ? selectedLanguages.remove(key)
                  : selectedLanguages.add(key);
              isLanguageSelected = selectedLanguages.isNotEmpty;
            });
          },
        ),
        Divider(
          height: 2,
          //color: Colors.grey,
        ),
      ],
    );
  }

  Map<String, String> languageMap = {
    "english": "English",
    "bengali": "Bengali",
    "hindi": "Hindi",
    "urdu": "Urdu",
    "french": "French",
    "spanish": "Spanish"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Languages',
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.headlineSmall!.apply(
                  // color: Theme.of(context).primaryColorDark,
                  color: WHITE,
                  fontWeightDelta: 1,
                  fontSizeFactor: .8,
                ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 243, 103, 9),
        foregroundColor: WHITE,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (isLanguageSelected && selectedLanguages.isNotEmpty) {
                setState(() {
                  loading = true;
                });
                updatingLanguages();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Color.fromARGB(255, 224, 16, 1),
                  content: Text(
                    'Please select at least one language.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.2,
                  ),
                ));
              }
            },
            child: Text(
              'Save',
              style: GoogleFonts.robotoCondensed(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: loading
          ? Container(
              alignment: Alignment.center,
              transformAlignment: Alignment.center,
              child: CircularProgressIndicator(
                color: const Color.fromARGB(255, 243, 103, 9),
              ),
            )
          : Container(
              color: LIGHT_GREY_SCREEN_BACKGROUND,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        'Select Your Preferred Language',
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Divider(
                      height: 2,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: 370,
                    child: ListView(
                      children: languageMap.keys.map((key) {
                        return buildLanguageItem(key, languageMap[key]!);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
