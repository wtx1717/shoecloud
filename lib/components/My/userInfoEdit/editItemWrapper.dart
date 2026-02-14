import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shoecloud/components/My/userInfoEdit/professionalDatePicker.dart';

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
  // 临时存储日期，用户点确定时才真正生效
  DateTime _tempSelectedDate = DateTime(2000, 1, 1);

  void _handleTap() {
    if (!widget.isCanEdit) return;
    if (widget.label.contains("性别")) {
      _showGenderPicker();
    } else if (widget.label.contains("生日")) {
      _showDatePicker();
    } else {
      _showTextInputDialog();
    }
  }

  // 1. 性别选择器（保持画风一致）
  void _showGenderPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text("选择${widget.label}", style: const TextStyle(fontSize: 14)),
        actions: ["男", "女", "未知"]
            .map(
              (g) => CupertinoActionSheetAction(
                onPressed: () {
                  print("【性别修改】: $g");
                  Navigator.pop(context);
                },
                child: Text(
                  g,
                  style: const TextStyle(color: Color(0xFF2E7D32)),
                ),
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text("取消", style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }

  // 2. 重新设计的“奶油绿”生日选择器
  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => professionalDatePicker(
        initialDate: _tempSelectedDate,
        label: widget.label,
        onConfirm: (finalDate) {
          setState(() {
            _tempSelectedDate = finalDate;
          });
          print(
            "【最终确定日期】: ${finalDate.year}-${finalDate.month}-${finalDate.day}",
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  // 3. 通用文本输入
  void _showTextInputDialog() {
    // 提取当前的数值（去掉单位）
    // 比如 "180 cm" 提取出 "180"
    String initialNumber = widget.value.split(' ')[0];
    TextEditingController ctrl = TextEditingController(text: initialNumber);

    // 根据 label 判断单位
    String unit = "";
    if (widget.label.contains("身高"))
      unit = "cm";
    else if (widget.label.contains("体重"))
      unit = "kg";
    else if (widget.label.contains("鞋码"))
      unit = "EUR";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF1F8E9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text(
          "修改${widget.label}",
          style: const TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          // --- 核心修改 1：只弹出数字键盘 ---
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          cursorColor: const Color(0xFF2E7D32),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            // --- 核心修改 2：显示单位后缀 ---
            suffixText: unit,
            suffixStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("取消", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              // 这里打印的结果就是：数值 + 单位
              print("【数据修改】${widget.label}: ${ctrl.text} $unit");
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("确定", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
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
      ),
    );
  }
}
