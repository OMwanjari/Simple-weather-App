import 'package:flutter/material.dart';
import 'package:simple_weather_app/ui/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color.fromRGBO(185, 190, 189, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 220, child: Image.asset('assets/logo.png')),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Simple",
              style: TextStyle(fontSize: 41, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Weather App",
              style: TextStyle(fontSize: 21),
            )
          ],
        ),
      ),
    );
  }
}
