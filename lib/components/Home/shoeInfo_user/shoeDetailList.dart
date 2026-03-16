import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 确保引入了 GetX
import 'package:shoecloud/viewmodels/shoeInfo.dart';

class shoeDetailList extends StatefulWidget {
  final ShoeInfo shoe;
  const shoeDetailList({super.key, required this.shoe});

  @override
  State<shoeDetailList> createState() => _shoeDetailListState();
}

class _shoeDetailListState extends State<shoeDetailList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildInfoTile("尺码", "${widget.shoe.size} EUR", Icons.format_size),
          _buildInfoTile(
            "购买价格",
            "¥${widget.shoe.purchasePrice}",
            Icons.payments,
          ),
          _buildInfoTile("发布日期", widget.shoe.releaseDate, Icons.calendar_today),
          _buildInfoTile("绑定时间", widget.shoe.bindTime, Icons.access_time),
          // 这里将原先的 isLast 改为 false，因为下面还要加一列
          _buildInfoTile(
            "状态",
            widget.shoe.isRetired ? "已退役" : "服役中",
            Icons.directions_run,
          ),

          _buildActionTile(
            "运动记录",
            "查看全部",
            Icons.history_toggle_off_rounded,
            onTap: () {
              // 使用原生 Navigator 跳转并传参
              Navigator.pushNamed(
                context,
                '/shoeActivityList',
                arguments: {'shoeInfo': widget.shoe},
              );
            },
            isLast: true,
          ),
        ],
      ),
    );
  }

  // 基础信息条目
  Widget _buildInfoTile(
    String title,
    String trailing,
    IconData icon, {
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(color: Colors.black87)),
          const Spacer(),
          Text(trailing, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // 新增：带 Material 水波纹的可点击条目
  Widget _buildActionTile(
    String title,
    String trailing,
    IconData icon, {
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(20))
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(bottom: BorderSide(color: Colors.grey.shade100)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF2E7D32)), // 森林绿图标
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(color: Colors.black87)),
              const Spacer(),
              Text(
                trailing,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
