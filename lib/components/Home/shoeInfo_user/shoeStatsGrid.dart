import 'package:flutter/material.dart';
import 'package:shoecloud/utils/TimeUtils.dart';
import 'package:shoecloud/viewmodels/shoeInfo.dart';

/// 2. 核心数据统计网格
class shoeStatsGrid extends StatefulWidget {
  final ShoeInfo shoe;
  const shoeStatsGrid({super.key, required this.shoe});

  @override
  State<shoeStatsGrid> createState() => _shoeStatsGridState();
}

class _shoeStatsGridState extends State<shoeStatsGrid> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _buildStatItem(
            "累计里程",
            "${widget.shoe.stats.totalMileage} km",
            Icons.straighten,
          ),
          _buildStatItem(
            "使用次数",
            "${widget.shoe.stats.usageCount} 次",
            Icons.history,
          ),
          // 使用你打包好的 TimeUtils 工具类
          _buildStatItem(
            "累计时长",
            TimeUtils.formatToChinese(widget.shoe.stats.totalDuration),
            Icons.timer,
          ),
          _buildStatItem(
            "最大单次",
            "${widget.shoe.stats.maxSingleDistance} km",
            Icons.emoji_events,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFFFF9C4).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.yellow.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.brown[400]),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
