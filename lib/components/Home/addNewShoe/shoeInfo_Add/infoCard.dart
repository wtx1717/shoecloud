import 'package:flutter/material.dart';

class cardShoeInfo_Add extends StatefulWidget {
  final String name;
  final String brand;
  final double release_price;
  final int release_year;
  final List<String> features;
  final String description;
  final String category;

  const cardShoeInfo_Add({
    super.key,
    required this.name,
    required this.brand,
    required this.release_price,
    required this.release_year,
    required this.features,
    required this.description,
    required this.category,
  });

  @override
  State<cardShoeInfo_Add> createState() => _cardShoeInfo_AddState();
}

class _cardShoeInfo_AddState extends State<cardShoeInfo_Add> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getShoeName(),
          const SizedBox(height: 15),
          _getTagsRow(), // 品牌、年份、价格标签化
          const SizedBox(height: 15),
          _getFeaturesGrid(), // 功能特性展示
          const SizedBox(height: 20),
          _getDescription(),
        ],
      ),
    );
  }

  Widget _getShoeName() {
    return Center(
      child: Text(
        widget.name,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: Color(0xFF2E7D32),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // 品牌、年份、价格采用小气泡样式
  Widget _getTagsRow() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        _buildTag(widget.brand, const Color(0xFFFFF9C4)), // 奶油黄
        _buildTag("${widget.release_year}年", const Color(0xFFF1F8E9)),
        _buildTag("￥${widget.release_price}", const Color(0xFFF1F8E9)),
        _buildTag(widget.category, const Color(0xFFE8F5E9)),
      ],
    );
  }

  Widget _buildTag(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF2E7D32),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // 功能特性展示
  Widget _getFeaturesGrid() {
    return Center(
      child: Text(
        "核心功能: ${widget.features.join(" · ")}",
        style: const TextStyle(
          fontSize: 14,
          color: Colors.green,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _getDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "跑鞋详情",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.6),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
