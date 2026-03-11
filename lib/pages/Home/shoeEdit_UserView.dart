import 'package:flutter/material.dart';
import 'package:shoecloud/components/Home/shoeInfo_user/shoeEditForm.dart';
import 'package:shoecloud/viewmodels/shoeInfo.dart';

class shoeEdit_UserView extends StatelessWidget {
  const shoeEdit_UserView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final shoe = args?['shoeInfo'] as ShoeInfo?;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9), // 极淡的绿色背景
      appBar: AppBar(
        title: const Text("编辑跑鞋信息", style: TextStyle(color: Color(0xFF2E7D32))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
      ),
      body: SingleChildScrollView(
        child: shoe == null 
          ? const Center(child: Text("数据丢失")) 
          : shoeEditForm(shoe: shoe),
      ),
    );
  }
}