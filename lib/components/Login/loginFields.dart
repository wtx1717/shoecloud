// ignore: file_names
import 'package:flutter/material.dart';
import 'package:shoecloud/components/common/clickableWrapper.dart';

// 1. 账号输入组件
class accountField extends StatefulWidget {
  final TextEditingController controller;
  const accountField({super.key, required this.controller});

  @override
  State<accountField> createState() => _accountFieldState();
}

class _accountFieldState extends State<accountField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        //校验账号是否为空
        if (value == null || value.isEmpty) {
          return "账号不能为空";
        }
        //校验手机号格式
        if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
          return "手机号格式不正确";
        }
        return null;
      },
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: "账号",
        prefixIcon: const Icon(Icons.person_outline, color: Colors.green),
        filled: true,
        fillColor: const Color(0xFFF1F8E9), // 极浅绿色背景
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), // 大圆角
          borderSide: BorderSide.none, // 去掉深色边框
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xFFC5E1A5),
            width: 1.5,
          ), // 浅绿色边框
        ),
      ),
    );
  }
}

// 2. 密码输入组件
class passwordField extends StatefulWidget {
  final TextEditingController controller;
  const passwordField({super.key, required this.controller});

  @override
  State<passwordField> createState() => _passwordFieldState();
}

class _passwordFieldState extends State<passwordField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        //校验密码是否为空
        if (value == null || value.isEmpty) {
          return "密码不能为空";
        }
        //密码校验，6-16位，包含数字、字母、下划线
        if (!RegExp(r'^[a-zA-Z0-9_]{6,16}$').hasMatch(value)) {
          return "密码格式不正确";
        }
        return null;
      },
      controller: widget.controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "密码",
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
        filled: true,
        fillColor: const Color(0xFFF1F8E9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFC5E1A5), width: 1.5),
        ),
      ),
    );
  }
}

// 3. 隐私协议组件
class privacyAgreement extends StatefulWidget {
  final bool isAgreed;
  final ValueChanged<bool?> onChanged;
  const privacyAgreement({
    super.key,
    required this.isAgreed,
    required this.onChanged,
  });

  @override
  State<privacyAgreement> createState() => _privacyAgreementState();
}

class _privacyAgreementState extends State<privacyAgreement> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.isAgreed,
          activeColor: Colors.green, // 选中时为绿色
          onChanged: widget.onChanged,
        ),
        const Text("我已同意  ", style: TextStyle(color: Colors.black54)),
        clickableWrapper(
          route: "privacyPage",
          child: const Text(
            " “云鞋库”用户 隐私协议",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// 4. 登录按钮组件
class loginButton extends StatefulWidget {
  final VoidCallback onPressed;
  const loginButton({super.key, required this.onPressed});

  @override
  State<loginButton> createState() => _loginButtonState();
}

class _loginButtonState extends State<loginButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFF59D), // 浅黄色
          foregroundColor: Colors.green[800], // 深绿色文字
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // 保持一致的圆角
          ),
        ),
        child: const Text(
          "立即登录",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
