import 'package:flutter/material.dart';
import 'package:shoecloud/components/My/userInfoEdit/editItemWrapper.dart';
import 'package:shoecloud/components/My/userInfoEdit/logoutButton.dart';

class baseInfoTab extends StatefulWidget {
  final dynamic base;
  const baseInfoTab({super.key, required this.base});

  @override
  State<baseInfoTab> createState() => _baseInfoTabState();
}

class _baseInfoTabState extends State<baseInfoTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 10),
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,
                backgroundImage: widget.base.avatarUrl.isNotEmpty
                    ? NetworkImage(widget.base.avatarUrl)
                    : null,
                child: widget.base.avatarUrl.isEmpty
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              const SizedBox(height: 10),
              const Text(
                "点击更换头像",
                style: TextStyle(color: Color(0xFF2E7D32), fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        editItemWrapper(label: "用户名", value: widget.base.userName),
        editItemWrapper(
          label: "账号",
          value: widget.base.account,
          isCanEdit: false,
        ),
        editItemWrapper(label: "性别", value: widget.base.gender),
        editItemWrapper(label: "生日", value: widget.base.birthday),
        editItemWrapper(
          label: "注册日期",
          value: widget.base.registerDate,
          isCanEdit: false,
        ),

        const SizedBox(height: 50),
        const logoutButton(),
        const SizedBox(height: 30),
      ],
    );
  }
}
