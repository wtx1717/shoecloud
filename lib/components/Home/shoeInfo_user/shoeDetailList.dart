import 'package:flutter/material.dart';
import 'package:shoecloud/viewmodels/shoeInfo.dart';

/// 4. 购买细节列表
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
          _buildInfoTile(
            "状态",
            widget.shoe.isRetired ? "已退役" : "服役中",
            Icons.directions_run,
            isLast: true,
          ),
        ],
      ),
    );
  }

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
}
