import 'package:flutter/material.dart';

class SvgWave extends StatelessWidget {
  final bool isTop;

  const SvgWave({super.key, required this.isTop});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      color: isTop ? Colors.blue : Colors.green, // Example colors
      // Add your SVG drawing logic here
    );
  }
}
