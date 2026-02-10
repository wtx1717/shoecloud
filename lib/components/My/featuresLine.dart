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
      // 保持 margin 逻辑
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
