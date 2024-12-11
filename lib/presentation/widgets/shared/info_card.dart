import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String value;
  final String title;
  final MaterialColor color;
  const InfoCard({super.key, required this.value, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: color, 
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: const TextStyle(fontSize: 24, color: Colors.white),),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.white))
        ],
      )
    );
  }
}