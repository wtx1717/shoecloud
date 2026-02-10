import 'package:flutter/material.dart';

class featuresSquare extends StatefulWidget {
  final String title;

  const featuresSquare({super.key, required this.title});

  @override
  State<featuresSquare> createState() => _featuresSquareState();
}

class _featuresSquareState extends State<featuresSquare> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/assets/my/edit.png",
              height: 28,
              width: 28,
              color: const Color(0xFF2E7D32),
            ),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
