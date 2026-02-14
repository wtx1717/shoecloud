import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class professionalDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final String label;
  final Function(DateTime) onConfirm;

  const professionalDatePicker({
    super.key,
    required this.initialDate,
    required this.label,
    required this.onConfirm,
  });

  @override
  State<professionalDatePicker> createState() => _professionalDatePickerState();
}

class _professionalDatePickerState extends State<professionalDatePicker> {
  late int selYear;
  late int selMonth;
  late int selDay;

  // 控制器，用于初始定位
  late FixedExtentScrollController yearCtrl;
  late FixedExtentScrollController monthCtrl;
  late FixedExtentScrollController dayCtrl;

  final List<int> years = List.generate(
    DateTime.now().year - 1900 + 1,
    (i) => 1900 + i,
  );
  final List<int> months = List.generate(12, (i) => i + 1);

  @override
  void initState() {
    super.initState();
    selYear = widget.initialDate.year;
    selMonth = widget.initialDate.month;
    selDay = widget.initialDate.day;

    yearCtrl = FixedExtentScrollController(initialItem: years.indexOf(selYear));
    monthCtrl = FixedExtentScrollController(
      initialItem: months.indexOf(selMonth),
    );
    dayCtrl = FixedExtentScrollController(initialItem: selDay - 1);
  }

  // 计算当前年月对应的天数
  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    int maxDays = _daysInMonth(selYear, selMonth);
    // 如果当前选中的日期超过了该月最大天数（比如从1月31切到2月），自动修正
    if (selDay > maxDays) selDay = maxDays;

    return Container(
      height: 380,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Column(
        children: [
          // --- 顶部胶囊控制栏 ---
          _buildHeader(),

          // --- 三路联动选择器 ---
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    _buildPicker(
                      years,
                      yearCtrl,
                      (v) => setState(() => selYear = v),
                      "年",
                    ),
                    _buildPicker(
                      months,
                      monthCtrl,
                      (v) => setState(() => selMonth = v),
                      "月",
                    ),
                    _buildPicker(
                      List.generate(maxDays, (i) => i + 1),
                      dayCtrl,
                      (v) => setState(() => selDay = v),
                      "日",
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: Color(0xFFF1F8E9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "取消",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          Text(
            "选择${widget.label}",
            style: const TextStyle(
              color: Color(0xFF2E7D32),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                widget.onConfirm(DateTime(selYear, selMonth, selDay)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text("确定", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker(
    List<int> items,
    FixedExtentScrollController ctrl,
    ValueChanged<int> onChanged,
    String unit,
  ) {
    return Expanded(
      child: CupertinoPicker(
        scrollController: ctrl,
        itemExtent: 45,
        looping: false, // 撞墙模式
        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
          capStartEdge: false,
          capEndEdge: false,
        ),
        onSelectedItemChanged: (index) {
          // --- 核心优化：震动反馈，真机手感无敌 ---
          HapticFeedback.selectionClick();
          onChanged(items[index]);
        },
        children: items
            .map(
              (i) => Center(
                child: Text(
                  "$i$unit",
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
