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
          // 底部操作区：直接平铺两个组件
          _buildBottomActionArea(),
        ],
      ),
    );
  }

  Widget _buildHeaderTip() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        children: [
          Icon(Icons.edit_note, color: Color(0xFF2E7D32)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "您可以设置个性化的昵称和尺码，方便后续进行跑量统计。",
              style: TextStyle(fontSize: 12, color: Color(0xFF2E7D32)),
            ),
          ),
        ],
      ),
    );
  }

  // 核心修改：平铺显示所有操作
  Widget _buildBottomActionArea() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 直接显示 NFC 绑定组件（带它自己的 UI 和逻辑）
          bindNFCBottom(
            shoeId:
                (_userController.fullInfo.value!.accountSummary.shoesCount + 1)
                    .toString(),
            userId: _userController.loginInfo.value.userId,
          ),

          // 2. 下方紧跟“仅添加不绑定”按钮
          Padding(
            padding: const EdgeInsets.fromLTRB(
              25,
              0,
              25,
              20,
            ), // 调整边距，让它在 NFC 组件下方
            child: GestureDetector(
              onTap: _handlePureAdd,
              child: Container(
                height: 55,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF2E7D32),
                    width: 1.5,
                  ),
                ),
                child: const Text(
                  "仅添加不绑定",
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
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

    final String newShoeId = ShoeUpdateUtils.generateShoeId();

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
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("添加成功"),
            content: const Text("您的新跑鞋已成功同步至云端！"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // 关闭弹窗
                child: const Text("好的"),
              ),
            ],
          );
        },
      ).then((_) async {
        // --- 这里是原生 Navigator 跳转逻辑 ---

        // 1. 同步内存数据
        await _userController.refreshUserInfo();

        if (mounted) {
          // 2. 使用原生方式回退到首页并清空栈
          // '/' 是你定义的首页路由名
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        }
      });
    } else {
      // 失败逻辑保持不变
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("同步失败，请检查网络")));
    }
  }
}
