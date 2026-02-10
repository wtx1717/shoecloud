import 'package:flutter/material.dart';
import 'package:shoecloud/components/My/userInfoEdit/editItemWrapper.dart';

class physicalStatsTab extends StatefulWidget {
  final dynamic stats;
  const physicalStatsTab({super.key, required this.stats});

  @override
  State<physicalStatsTab> createState() => _physicalStatsTabState();
}

class _physicalStatsTabState extends State<physicalStatsTab> {
  @override
  Widget build(BuildContext context) {
    final unit = widget.stats.unit;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 10),
        _buildInfoTip(),
        const SizedBox(height: 20),
        editItemWrapper(
          label: "身高",
          value: "${widget.stats.height} ${unit['height'] ?? ''}",
        ),
        editItemWrapper(
          label: "体重",
          value: "${widget.stats.weight} ${unit['weight'] ?? ''}",
        ),
        editItemWrapper(
          label: "鞋码",
          value: "${widget.stats.shoeSize} ${unit['shoeSize'] ?? ''}",
        ),
      ],
    );
  }

  Widget _buildInfoTip() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
        "身体数据仅用于为您提供更专业的跑鞋建议。",
        style: TextStyle(fontSize: 12, color: Color(0xFF2E7D32)),
      ),
    );
  }
}
