import 'package:flutter/material.dart';
import 'package:simple_weather_app/constrants.dart';
import 'package:weather/weather.dart' as weather_pkg;
import 'package:simple_weather_app/widget/gradient.dart';
import 'package:simple_weather_app/widget/round_container.dart';

class Weather extends StatefulWidget {
  final String cityname;

  const Weather({super.key, required this.cityname});

  @override
  State<Weather> createState() =>
      _WeatherState(); // Create state for the Weather widget
}

class _WeatherState extends State<Weather> {
  final weather_pkg.WeatherFactory _wf = weather_pkg.WeatherFactory(
      WeatherApikey); // WeatherFactory instance with your API key
  weather_pkg.Weather? _weather; // Weather object to store current weather data
  String? _error; // String to store error message if any

  @override
  void initState() {
    super.initState();
    _fetchWeather(); // Fetch weather data when widget initializes
  }

  void _fetchWeather() async {
    try {
      final weather = await _wf.currentWeatherByCityName(
          widget.cityname); // Fetch weather by city name
      setState(() {
        _weather = weather; // Update weather data
        _error = null; // Clear error message
      });
    } catch (e) {
      setState(() {
        _error = 'City not found'; // Set error message if city not found
        _weather = null; // Clear weather data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );

                await Future.delayed(const Duration(seconds: 2));
                Navigator.pop(context);
                _fetchWeather;
              } // Refresh weather data
              ),
        ],
      ),
      body: Container(
        decoration:
            const BoxDecoration(gradient: AppGradients.backgroundGradient),
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    if (_error != null) {
      // Show error message if there's an error
      return Center(
        child: Text(
          _error!,
          style: const TextStyle(fontSize: 24, color: Colors.red),
        ),
      );
    }

    if (_weather == null) {
      // Show a loading indicator while weather data is fetched
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show weather details if data is available
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _weather?.areaName ?? "", // Display area name if available
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          _weatherIcon(), // Display weather icon
          Text(
            "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°", // Display temperature in Celsius
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomRoundedContainer(
                text1: "Wind",
                text2: "${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                img: "windy.png",
              ),
              const SizedBox(width: 30),
              CustomRoundedContainer(
                text1: "Humidity",
                text2: "${_weather?.humidity?.toStringAsFixed(0)}%",
                img: "humidity.png",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
              ),
            ),
          ), // Weather icon image
        ),
        Text(
          _weather?.weatherDescription ?? "",
        ), // Display weather description
      ],
    );
  }
}
