import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/components/Home/addNewShoe/shoeInfo_Add/bindNFCBottom.dart';
import 'package:shoecloud/components/Home/shoeInfo_user/shoeDetailList.dart';
import 'package:shoecloud/components/Home/shoeInfo_user/shoeFeatureTags.dart';
import 'package:shoecloud/components/Home/shoeInfo_user/shoeHeroHeader.dart';
import 'package:shoecloud/components/Home/shoeInfo_user/shoeStatsGrid.dart';
import 'package:shoecloud/stores/userController.dart';
import 'package:shoecloud/viewmodels/shoeInfo.dart';
// 导入上面的组件
// import 'package:shoecloud/widgets/shoe_detail_widgets.dart';

class shoeInfo_UserView extends StatefulWidget {
  const shoeInfo_UserView({super.key});

  @override
  State<shoeInfo_UserView> createState() => _shoeInfo_UserViewState();
}

class _shoeInfo_UserViewState extends State<shoeInfo_UserView> {
  final UserController _userController = Get.find();
  @override
  Widget build(BuildContext context) {
    // 提取路由参数
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final shoe = args?['shoeInfo'] as ShoeInfo?;

    if (shoe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("详情")),
        body: const Center(child: Text("数据加载失败")),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFE8F5E9),
      appBar: AppBar(
        title: Text(
          shoe.shoeName,
          style: const TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 使用分离后的组件
            shoeHeroHeader(shoe: shoe),
            shoeStatsGrid(shoe: shoe),
            shoeFeatureTags(features: shoe.features),
            shoeDetailList(shoe: shoe),
            const SizedBox(height: 30),
            bindNFCBottom(
              shoeId: shoe.shoeId,
              userId: _userController.fullInfo.value!.baseInfo.userId,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
