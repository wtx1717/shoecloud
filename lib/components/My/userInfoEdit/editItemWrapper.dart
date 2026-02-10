import 'package:flutter/material.dart';

class editItemWrapper extends StatefulWidget {
  final String label;
  final String value;
  final bool isCanEdit;

  const editItemWrapper({
    super.key,
    required this.label,
    required this.value,
    this.isCanEdit = true,
  });

  @override
  State<editItemWrapper> createState() => _editItemWrapperState();
}

class _editItemWrapperState extends State<editItemWrapper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            widget.label,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          const Spacer(),
          Text(
            widget.value,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
          if (widget.isCanEdit) ...[
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
          ],
        ],
      ),
    );
  }
}
