import 'package:flutter/material.dart';

class featuresLine extends StatefulWidget {
  final String title;

  const featuresLine({super.key, required this.title});

  @override
  State<featuresLine> createState() => _featuresLineState();
}

class _featuresLineState extends State<featuresLine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
      color: Colors.amberAccent,
      padding: EdgeInsets.all(10),
      child: Text(widget.title, style: TextStyle(fontSize: 16)),
    );
  }
}
