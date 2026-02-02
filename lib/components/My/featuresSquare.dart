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
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("lib/assets/my/edit.png", height: 30, width: 30),
            SizedBox(height: 5),
            Text(widget.title, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
