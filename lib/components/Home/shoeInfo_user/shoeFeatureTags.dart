import 'package:flutter/material.dart';

const Color darkGreen = Color(0xFF2E7D32);

/// 3. 特性标签云
class shoeFeatureTags extends StatefulWidget {
  final List<String> features;
  const shoeFeatureTags({super.key, required this.features});

  @override
  State<shoeFeatureTags> createState() => _shoeFeatureTagsState();
}

class _shoeFeatureTagsState extends State<shoeFeatureTags> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: widget.features
            .map(
              (f) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: darkGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: darkGreen.withOpacity(0.2)),
                ),
                child: Text(
                  f,
                  style: const TextStyle(color: darkGreen, fontSize: 12),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
