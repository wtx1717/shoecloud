import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shoecloud/components/My/userInfoEdit/editItemWrapper.dart';
import 'package:shoecloud/stores/userController.dart';

class physicalStatsTab extends StatefulWidget {
  final dynamic stats;
  const physicalStatsTab({super.key, required this.stats});

  @override
  State<physicalStatsTab> createState() => _physicalStatsTabState();
}

class _physicalStatsTabState extends State<physicalStatsTab> {
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 2. 从响应式变量中实时抓取最新的身体数据
      final liveStats = _userController.fullInfo.value?.physicalStats;

      // 如果数据还没加载出来，给个容错
      if (liveStats == null) {
        return const Center(child: CircularProgressIndicator());
      }

      // 这里的 unit 也要从实时数据里拿
      final unit = liveStats.unit;

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 10),
          _buildInfoTip(),
          const SizedBox(height: 20),
          // 3. 这里的 value 必须改用 liveStats，不能用 widget.stats
          editItemWrapper(
            label: "身高",
            value: "${liveStats.height} ${unit['height'] ?? ''}",
          ),
          editItemWrapper(
            label: "体重",
            value: "${liveStats.weight} ${unit['weight'] ?? ''}",
          ),
          editItemWrapper(
            label: "鞋码",
            value: "${liveStats.shoeSize} ${unit['shoeSize'] ?? ''}",
          ),
        ],
      );
    });
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
