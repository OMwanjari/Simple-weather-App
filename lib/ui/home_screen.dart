import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_weather_app/constrants.dart';
import 'package:simple_weather_app/widget/gradient.dart';
import 'package:simple_weather_app/ui/weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController =
      TextEditingController(); // Controller for the search input

  final BehaviorSubject<String> _searchSubject =
      BehaviorSubject<String>(); // Subject for managing search input stream
  List<dynamic> listOfLocation = []; // List to store location suggestions

  @override
  void initState() {
    super.initState();

    // Listen to the search input stream, debounce it, and call placeSuggestion method
    _searchSubject
        .debounceTime(const Duration(milliseconds: 200))
        .distinct()
        .listen((input) => placeSuggestion(input));

    // Add listener to searchController to update _searchSubject with new text
    searchController.addListener(() {
      _searchSubject.add(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose(); // Dispose the controller
    _searchSubject.close(); // Close the subject
    super.dispose();
  }

  // Method to fetch location suggestions from Geoapify API
  void placeSuggestion(String input) async {
    if (input.isEmpty) return;

    const String apikey = SearchApikey;
    try {
      String request =
          "https://api.geoapify.com/v1/geocode/autocomplete?text=$input&apiKey=$apikey";
      var response = await http.get(Uri.parse(request));
      var data = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          listOfLocation = data[
              'features']; // Update the list of locations with API response
        });
      } else {
        throw Exception("Failed to load suggestions");
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString()); // Print error to console
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth =
        MediaQuery.of(context).size.width; //for responsiveness of search bar
    double pad = 0;
    if (screenWidth > 600) {
      pad = screenWidth * 0.3;
    } else {
      pad = screenWidth * 0.05;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Simple",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: AppGradients
                .backgroundGradient), //accesing gradient form gradient.dart file
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: pad), // Use screenWidth here
          child: Column(
            children: [
              const SizedBox(height: 150),
              TextField(
                style: const TextStyle(color: Colors.deepPurple),
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Enter City",
                  hintStyle: const TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.deepPurple,
                  ),
                  filled: true,
                  fillColor: Colors.white54,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 18, vertical: 16.0),
                ),
              ),
              Visibility(
                visible: searchController.text.isNotEmpty,
                child: Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shrinkWrap: true,
                    itemCount: listOfLocation.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            searchController.text = listOfLocation[index]
                                ["properties"]["formatted"];
                            listOfLocation.clear();
                          });
                        },
                        child: Card(
                          color: Colors.deepPurple[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: ListTile(
                            title: Text(
                              listOfLocation[index]["properties"]["formatted"],
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(14),
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    await Future.delayed(const Duration(seconds: 2));

                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Weather(cityname: searchController.text),
                      ),
                    );
                  },
                  child: const Wrap(
                    children: <Widget>[
                      Text("Get started",
                          style: TextStyle(color: Colors.white)),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_right_alt_rounded,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
