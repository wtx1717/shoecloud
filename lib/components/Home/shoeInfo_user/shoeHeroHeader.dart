import 'package:flutter/material.dart';
import 'package:shoecloud/viewmodels/shoeInfo.dart';

/// 1. 顶部大图与标题组件
class shoeHeroHeader extends StatefulWidget {
  final ShoeInfo shoe;
  const shoeHeroHeader({super.key, required this.shoe});

  @override
  State<shoeHeroHeader> createState() => _shoeHeroHeaderState();
}

class _shoeHeroHeaderState extends State<shoeHeroHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              widget.shoe.imageUrl,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => Container(
                height: 200,
                color: Color(0xFFFFF9C4),
                child: const Icon(
                  Icons.directions_run,
                  size: 50,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.shoe.nickname,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            "${widget.shoe.brand} · ${widget.shoe.category}",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
