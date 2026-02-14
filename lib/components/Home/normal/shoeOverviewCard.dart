import 'package:flutter/material.dart';
import 'package:shoecloud/utils/TimeUtils.dart';

class shoeOverviewCard extends StatefulWidget {
  final String? shoeName;
  final String? nickName;
  final String? totalDistance;
  final int? totalTime;
  final String? imageUrl;

  const shoeOverviewCard({
    super.key,
    this.shoeName,
    this.nickName,
    this.totalDistance,
    this.totalTime,
    this.imageUrl,
  });

  @override
  State<shoeOverviewCard> createState() => _shoeOverviewCardState();
}

class _shoeOverviewCardState extends State<shoeOverviewCard> {
  // 定义配色方案
  final Color cardBg = const Color(0xFFE8F5E9); // 极浅绿
  final Color accentColor = const Color(0xFFFFF9C4); // 淡黄
  final Color textDark = const Color(0xFF2E7D32); // 深绿文字

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      height: 140, // 稍微收紧高度，显得更精致
      decoration: BoxDecoration(
        // 使用渐变色增加活力感
        gradient: LinearGradient(
          colors: [cardBg, accentColor.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        // 使用Stack实现背景文字或装饰
        children: [
          Row(children: [_buildImageSection(), _buildInfoSection()]),
          // 装饰：在右上角加一个淡色标签或小图标
          Positioned(
            right: 15,
            top: 15,
            child: Icon(Icons.bolt, color: textDark.withOpacity(0.1), size: 40),
          ),
        ],
      ),
    );
  }

  // 鞋子图片部分
  Widget _buildImageSection() {
    return Expanded(
      flex: 4,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Hero(
          // 如果详情页也有，加上动画
          tag: 'shoe_${widget.nickName}',
          child: Image.network(
            widget.imageUrl ??
                "https://www.shoecloud.cn/uploadtest/image/addShoeImageExample/shoe_example.png",
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.directions_run, size: 50, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  // 概览信息部分
  Widget _buildInfoSection() {
    return Expanded(
      flex: 6,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 昵称 (主标题)
            Text(
              widget.nickName ?? "未命名跑鞋",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: textDark,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // 2. 真实型号 (副标题)
            Text(
              widget.shoeName ?? "未知型号",
              style: TextStyle(
                fontSize: 13,
                color: textDark.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // 3. 数据行
            Row(
              children: [
                Expanded(
                  child: _buildSmallStat(
                    Icons.straighten,
                    "${widget.totalDistance ?? '0'} km",
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: _buildSmallStat(
                    Icons.access_time,
                    TimeUtils.formatToChinese(widget.totalTime ?? 0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 提取小数据组件
  Widget _buildSmallStat(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: textDark.withOpacity(0.5)),
        const SizedBox(width: 4),
        // 用 Expanded 包住 Text
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            maxLines: 1, // 必须指定为 1 行，省略号才会出现
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textDark.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}
