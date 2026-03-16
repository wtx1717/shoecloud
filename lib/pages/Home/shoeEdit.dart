import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/api/shoeInfo.dart';
import 'package:shoecloud/components/Home/addNewShoe/editFormField.dart';
import 'package:shoecloud/components/Home/addNewShoe/shoeInfo_Add/bindNFCBottom.dart';
import 'package:shoecloud/stores/userController.dart';

class shoeEditView extends StatefulWidget {
  const shoeEditView({super.key});

  @override
  State<shoeEditView> createState() => _shoeEditViewState();
}

class _shoeEditViewState extends State<shoeEditView> {
  late TextEditingController _nicknameController;
  late TextEditingController _sizeController;
  late TextEditingController _priceController;
  bool _isDataLoaded = false;

  final UserController _userController = Get.find();

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController();
    _sizeController = TextEditingController(text: "42.5");
    _priceController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataLoaded) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _nicknameController.text = args['nickname'] ?? args['name'] ?? "";
        _priceController.text = args['release_price']?.toString() ?? "";
      }
      _isDataLoaded = true;
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _sizeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "完善跑鞋信息",
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 20),
                _buildHeaderTip(),
                const SizedBox(height: 30),
                editFormField(
                  label: "跑鞋昵称",
                  controller: _nicknameController,
                  hint: "例如：我的破二战靴",
                ),
                editFormField(
                  label: "尺码 (EUR)",
                  controller: _sizeController,
                  hint: "例如：42.5",
                  isNumber: true,
                ),
                editFormField(
                  label: "购买价格 (元)",
                  controller: _priceController,
                  hint: "选填",
                  isNumber: true,
                ),
              ],
            ),
          ),
          _buildBottomActionArea(),
        ],
      ),
    );
  }

  Widget _buildHeaderTip() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
      ),
      child: const Row(
        children: [
          Icon(Icons.tips_and_updates_rounded, color: Color(0xFF2E7D32)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "您可以设置个性化的昵称和尺码，方便后续进行跑量统计。",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF2E7D32),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionArea() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // bindNFCBottom(
          //   // 这里传入一个临时的 ID
          //   shoeId: (DateTime.now().millisecondsSinceEpoch).toString(),
          //   userId: _userController.loginInfo.value.userId,
          //   // 关键：点击写入成功后，会自动触发这个 handle
          //   onSuccess: _handlePureAdd,
          // ),
          // 2. 统一风格的“仅添加不绑定”按钮
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
            child: InkWell(
              onTap: _handlePureAdd,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 55,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFC8E6C9).withOpacity(0.5), // 浅绿半透明背景
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF2E7D32).withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      color: Color(0xFF2E7D32),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "添加该跑鞋",
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePureAdd() async {
    final userId = _userController.loginInfo.value.userId;
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final rawName = args?['name'] ?? "未知型号";

    // 注意：假设你有生成 ID 的工具类，如果没有请替换为你的逻辑
    final String newShoeId = DateTime.now().millisecondsSinceEpoch.toString();

    final Map<String, dynamic> fullDetail = {
      "code": "1",
      "msg": "success",
      "result": {
        "shoe_id": newShoeId,
        "shoe_name": rawName,
        "brand": args?['brand'] ?? "未知品牌",
        "nickname": _nicknameController.text.isEmpty
            ? rawName
            : _nicknameController.text,
        "size": double.tryParse(_sizeController.text) ?? 42.5,
        "purchase_price":
            double.tryParse(_priceController.text) ??
            (args?['release_price']?.toDouble() ?? 0.0),
        "retail_price": args?['release_price']?.toDouble() ?? 0.0,
        "release_year": args?['release_year'] ?? 2024,
        "category": args?['category'] ?? "跑鞋",
        "description": args?['description'] ?? "",
        "imagesUrl": (args?['imagesUrl'] is List)
            ? args!['imagesUrl']
            : [args?['image_url'] ?? ""],
        "features": args?['features'] ?? ["专业避震"],
        "is_retired": false,
        "bind_time": DateTime.now().toString().split('.')[0],
      },
    };

    bool isSuccess = await updateUserBaseIndexAPI(
      userId: userId,
      newShoeName: rawName,
      newShoeId: newShoeId,
      fullDetail: fullDetail,
    );

    if (isSuccess) {
      _showSuccessDialog(); // 调用统一风格的成功弹窗
    } else {
      Get.snackbar(
        "同步失败",
        "请检查网络连接",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  // --- 统一风格的成功确认弹窗 ---
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // 强制用户点击按钮
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: const Color(0xFFE8F5E9),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "添加成功",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "您的新跑鞋已成功同步至云端！\n准备好开始下一次奔跑了吗？",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await _userController.refreshUserInfo();
                      if (mounted) {
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/', (route) => false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      "好 的",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
