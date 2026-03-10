import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shoecloud/api/userInfo.dart';
import 'package:shoecloud/components/My/userInfoEdit/professionalDatePicker.dart';
import 'package:shoecloud/stores/userController.dart';
import 'package:shoecloud/utils/dialog.dart';

// ignore: camel_case_types
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

// ignore: camel_case_types
class _editItemWrapperState extends State<editItemWrapper> {
  // 临时存储日期，用户点确定时才真正生效
  DateTime _tempSelectedDate = DateTime(2000, 1, 1);
  final UserController _userController = Get.find();

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
                onPressed: () async {
                  // A. 先关闭弹出的 ActionSheet
                  Navigator.pop(context);

                  // B. 发送请求
                  bool success = await updateUserInfoAPI(
                    _userController.loginInfo.value.userId,
                    {"gender": g},
                  );

                  // C. 使用外层的 context 弹出对话框
                  if (success) {
                    // 1. 获取当前内存对象
                    var full = _userController.fullInfo.value;
                    if (full != null) {
                      // 2. 手动修改性别字段
                      full.baseInfo.gender = g;
                      // 3. 触发同步和刷新
                      _userController.updateFullInfo(full);
                    }
                    _userController.updateFullInfo(
                      _userController.fullInfo.value!,
                    );
                    // ignore: use_build_context_synchronously
                    MyDialog.showSuccess(context, "信息已同步至服务器");
                    debugPrint("【性别修改】成功");
                  } else {
                    // ignore: use_build_context_synchronously
                    MyDialog.showError(context, "同步失败，请检查网络");
                    debugPrint("【性别修改】失败");
                  }
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
        onConfirm: (finalDate) async {
          setState(() {
            _tempSelectedDate = finalDate;
          });

          // 先关闭弹出的日期选择器
          Navigator.pop(context);

          // 发送请求
          bool success = await updateUserInfoAPI(
            _userController.loginInfo.value.userId,
            {"birthday": finalDate.toString()},
          );

          // 弹出对话框
          if (success) {
            // 1. 获取当前内存对象
            var full = _userController.fullInfo.value;
            if (full != null) {
              // 2. 手动修改生日字段
              // 提示：最好只取 yyyy-MM-dd 部分，避免 toString() 带出微秒
              String formattedDate =
                  "${finalDate.year}-${finalDate.month.toString().padLeft(2, '0')}-${finalDate.day.toString().padLeft(2, '0')}";
              full.baseInfo.birthday = formattedDate;

              // 3. 触发同步和刷新
              _userController.updateFullInfo(full);
            }
            _userController.updateFullInfo(_userController.fullInfo.value!);
            MyDialog.showSuccess(context, "信息已同步至服务器");
            debugPrint("【生日修改】成功");
          } else {
            MyDialog.showError(context, "同步失败，请检查网络");
            debugPrint("【生日修改】失败");
          }
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
    if (widget.label.contains("身高")) {
      unit = "cm";
    } else if (widget.label.contains("体重")) {
      unit = "kg";
    } else if (widget.label.contains("鞋码")) {
      unit = "EUR";
    }
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
            onPressed: () async {
              // 先关闭弹出的输入框
              Navigator.pop(context);

              // --- 1. 翻译 Key 和 转换 Value ---
              String apiKey = "";
              dynamic apiValue; // 后端需要的是数字或特定字符串

              if (widget.label.contains("身高")) {
                apiKey = "height";
                apiValue = double.tryParse(ctrl.text) ?? 0.0;
              } else if (widget.label.contains("体重")) {
                apiKey = "weight";
                apiValue = double.tryParse(ctrl.text) ?? 0.0;
              } else if (widget.label.contains("鞋码")) {
                apiKey = "shoeSize";
                apiValue = double.tryParse(ctrl.text) ?? 0.0;
              } else if (widget.label.contains("用户名") ||
                  widget.label.contains("昵称") ||
                  widget.label.contains("姓名")) {
                apiKey = "userName";
                apiValue = ctrl.text;
              }

              // --- 2. 发送请求 ---
              bool success = await updateUserInfoAPI(
                _userController.loginInfo.value.userId,
                {apiKey: apiValue}, // 这样后端才能精准识别
              );

              // 弹出对话框
              if (success) {
                // 1. 获取当前 Controller 里的完整对象
                var full = _userController.fullInfo.value;

                if (full != null) {
                  // 2. 根据修改的 Key，手动更新内存中的值
                  // 这样 Obx 监测的对象内部数据才会发生变化
                  if (apiKey == "userName") full.baseInfo.userName = apiValue;
                  if (apiKey == "gender") full.baseInfo.gender = apiValue;
                  if (apiKey == "birthday") full.baseInfo.birthday = apiValue;

                  if (apiKey == "height") full.physicalStats.height = apiValue;
                  if (apiKey == "weight") full.physicalStats.weight = apiValue;
                  if (apiKey == "shoeSize") {
                    full.physicalStats.shoeSize = apiValue;
                  }

                  // 3. 发射刷新信号！
                  // 只有调用了 updateFullInfo 并执行了 refresh()，上面的 Obx 才会发现数据变了
                  _userController.updateFullInfo(full);
                }
                MyDialog.showSuccess(context, "信息已同步至服务器");
                debugPrint("【${widget.label}修改】成功");
                _userController.updateFullInfo(_userController.fullInfo.value!);
              } else {
                MyDialog.showError(context, "同步失败，请检查网络");
                debugPrint("【${widget.label}修改】失败");
              }
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
