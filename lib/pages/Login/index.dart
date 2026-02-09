import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shoecloud/api/login.dart';
import 'package:shoecloud/api/userInfo.dart';
import 'package:shoecloud/components/Login/loginFields.dart';
import 'package:shoecloud/stores/tokenManager.dart';
import 'package:shoecloud/stores/userController.dart';
import 'package:shoecloud/viewmodels/userInfo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final accountController = TextEditingController();
  final passwordController = TextEditingController();
  bool isAgreed = false;
  final UserController _userController = Get.find(); //寻找对象

  final GlobalKey<FormState> _key = GlobalKey<FormState>(); // 表单状态管理
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 纯白底色衬托浅色组件
      appBar: AppBar(
        title: const Text("登录"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _key, // 表单状态管理
          child: Column(
            children: [
              const SizedBox(height: 40),
              // 标题
              const Text(
                "SHOECLOUD LOGIN",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF81C784), // 浅绿色标题
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 50),

              // 第一行：账户输入
              accountField(controller: accountController),
              const SizedBox(height: 20),

              // 第二行：密码输入
              passwordField(controller: passwordController),
              const SizedBox(height: 15),

              // 第三行：隐私协议
              privacyAgreement(
                isAgreed: isAgreed,
                onChanged: (val) => setState(() => isAgreed = val!),
              ),
              const SizedBox(height: 30),

              // 第四行：登录按钮
              loginButton(
                onPressed: () async {
                  _login();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 显示警告信息
  static bool _isShowed = false;
  void _showWarning(String message) {
    //阀门控制
    if (_isShowed) return;
    _isShowed = true;
    Future.delayed(Duration(seconds: 3), () => _isShowed = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        backgroundColor: const Color(0xFFFFF176), // 浅黄色背景提示
        content: Text(message, style: const TextStyle(color: Colors.black87)),
      ),
    );
  }

  // 登录逻辑
  void _login() async {
    // 1. 排除隐私协议未勾选
    if (!isAgreed) return _showWarning("请勾选隐私协议");

    // 2. 排除表单格式校验未通过
    if (!(_key.currentState?.validate() ?? false)) return;

    try {
      // 3. 调用 API 获取用户列表 (内部已解包 data["result"])
      // 注意：这里的 getLoginAPI 内部逻辑见下方补充
      final user = await getLoginAPI(
        accountController.text,
        passwordController.text,
      );

      // 4. 判断是否匹配成功
      if (user != null) {
        tokenManager.setToken(user.token); //写入持久化数据
        tokenManager.setUserId(user.userId); //写入持久化数据

        _userController.updateuserLogin(user); // 更新用户信息

        UserInfoModel? fullData = await getUserInfoAPI(
          "/user_${_userController.loginInfo.value.userId}/userInfo_base.json",
        );

        if (fullData != null) {
          _userController.updateFullInfo(fullData);
        }

        debugPrint("登录成功: ${user.userId}");
        _showWarning("登录成功，即将跳转主页");

        // 延迟一小会儿跳转，让用户看清 SnackBar 提示
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.pop(context); // 关闭当前页面，返回上一页面
        });
      } else {
        // 账号密码不匹配的情况
        _showWarning("账号或密码错误");
      }
    } catch (e) {
      // 网络错误或服务器 code 不为 200 的情况
      debugPrint("登录异常: $e");
      _showWarning("网络异常，请稍后再试");
    }
  }
}
