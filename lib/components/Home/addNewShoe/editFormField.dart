import 'package:flutter/material.dart';

class editFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool isNumber;

  const editFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.isNumber = false,
  });

  @override
  State<editFormField> createState() => _editFormFieldState();
}

class _editFormFieldState extends State<editFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.isNumber
            ? TextInputType.number
            : TextInputType.text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(color: Color(0xFF2E7D32), fontSize: 14),
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: Colors.grey.withOpacity(0.6),
            fontSize: 14,
          ),
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
