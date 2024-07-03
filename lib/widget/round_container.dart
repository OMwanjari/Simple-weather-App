import 'package:flutter/material.dart';
import 'package:simple_weather_app/widget/buttongradient.dart';

class CustomRoundedContainer extends StatelessWidget {
  final String text1;
  final String text2;
  final String img;

  CustomRoundedContainer(
      {required this.text1, required this.text2, required this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        gradient: ButtonGradients.bGradient,
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      padding: const EdgeInsets.all(16.0), // Padding inside container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text1,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0), // Spacer
          Row(
            children: [
              Text(
                text2,
                style: const TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                height: 20,
                child: Image.asset(
                  "assets/$img",
                  fit: BoxFit.contain,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
