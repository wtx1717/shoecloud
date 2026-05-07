/// 渲染正式版登录页，并将认证流程交给控制器处理。
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/app/router/app_routes.dart';
import 'package:shoecloud/app/theme/app_theme.dart';
import 'package:shoecloud/features/auth/presentation/controllers/auth_controller.dart';
import 'package:shoecloud/shared/widgets/app_card.dart';
import 'package:shoecloud/shared/widgets/app_feedback.dart';
import 'package:shoecloud/shared/widgets/app_primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  final RxBool _agreed = false.obs;
  late final AuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AuthController>();
  }

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: AppCard(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'ShoeCloud Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '登录后继续管理你的跑鞋、活动记录和 NFC 绑定信息。',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _accountController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: '手机号',
                          hintText: '请输入登录手机号',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入账号';
                          }
                          if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
                            return '请输入正确的手机号';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: '密码',
                          hintText: '请输入登录密码',
                          prefixIcon: Icon(Icons.lock_outline_rounded),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入密码';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9_]{6,16}$').hasMatch(value)) {
                            return '密码格式不正确';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      Obx(
                        () => CheckboxListTile(
                          value: _agreed.value,
                          onChanged: (value) => _agreed.value = value ?? false,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: AppColors.primary,
                          title: GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.privacy),
                            child: const Text.rich(
                              TextSpan(
                                text: '我已阅读并同意 ',
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 13,
                                ),
                                children: [
                                  TextSpan(
                                    text: '隐私政策',
                                    style: TextStyle(
                                      color: AppColors.primaryDeep,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => AppPrimaryButton(
                          label: _controller.isSubmitting.value
                              ? '登录中...'
                              : '登录',
                          onPressed:
                              _controller.isSubmitting.value ? null : _submit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_agreed.value) {
      AppFeedback.showInfo(context, '请先同意隐私政策');
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final success = await _controller.login(
      account: _accountController.text,
      password: _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      AppFeedback.showSuccess(context, '登录成功');
      Get.back();
    } else {
      AppFeedback.showError(context, '账号或密码错误');
    }
  }
}
