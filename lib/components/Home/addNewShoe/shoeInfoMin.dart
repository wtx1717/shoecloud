import 'package:flutter/material.dart';

class shoeInfoMin extends StatefulWidget {
  final String shoeName;
  final String imageUrl;
  const shoeInfoMin({
    super.key,
    required this.shoeName,
    required this.imageUrl,
  });

  @override
  State<shoeInfoMin> createState() => _shoeInfoMinState();
}

class _shoeInfoMinState extends State<shoeInfoMin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24), // 更圆润的角
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 图片容器增加一点点奶油黄光晕
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFDE7), // 极淡黄
              shape: BoxShape.circle,
            ),
            child: Image.network(
              widget.imageUrl,
              height: 80,
              width: 80,
              fit: BoxFit.contain, // 保持鞋子比例
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.shoeName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
