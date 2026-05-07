/// 存放中英文完整隐私政策正文。
import 'package:flutter/material.dart';

class PolicyContent extends StatelessWidget {
  const PolicyContent({super.key, required this.isChinese});

  final bool isChinese;

  @override
  Widget build(BuildContext context) {
    return isChinese ? _chinese() : _english();
  }

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Color(0xFF2E7D32),
        ),
      ),
    );
  }

  Widget _body(String text) {
    return Text(
      text,
      style: const TextStyle(height: 1.6, color: Color(0xFF47524A)),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(Icons.circle, size: 6, color: Color(0xFFC8DDBF)),
          ),
          const SizedBox(width: 10),
          Expanded(child: _body(text)),
        ],
      ),
    );
  }

  Widget _chinese() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _body('欢迎使用云鞋库。我们会在提供鞋库管理与活动同步服务时，谨慎处理你的个人信息。'),
        _title('1. 收集的信息'),
        _bullet('你主动提供的账号、跑鞋资料和个人基础信息。'),
        _bullet('在你授权后，从第三方运动平台同步的活动数据。'),
        _bullet('匿名的应用使用信息，用于优化体验与稳定性。'),
        _title('2. 使用目的'),
        _bullet('将活动与具体跑鞋关联，展示里程、寿命和统计信息。'),
        _bullet('优化页面表现、功能稳定性和使用体验。'),
        _bullet('通过应用内提示向你发送必要的服务通知。'),
        _title('3. 数据安全'),
        _bullet('我们会采用基础的传输加密与访问控制措施保护数据。'),
        _bullet('当账号注销或停止使用后，会在合理周期内清理相关数据。'),
        _title('4. 你的权利'),
        _bullet('你可以查看、修改并申请删除自己的个人信息。'),
        _bullet('你可以随时撤销第三方平台的授权同步。'),
        _title('5. 联系方式'),
        _body('如有隐私相关问题，可联系：13100162717@163.com'),
      ],
    );
  }

  Widget _english() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _body(
          'Welcome to ShoeCloud. We handle personal data carefully while providing shoe tracking and activity sync services.',
        ),
        _title('1. Data We Collect'),
        _bullet('Account details, shoe data, and profile information you provide.'),
        _bullet('Authorized activity data synced from third-party platforms.'),
        _bullet('Anonymous usage data for product improvement.'),
        _title('2. Why We Use It'),
        _bullet('To connect activities with shoes and present mileage statistics.'),
        _bullet('To improve performance, UX, and reliability.'),
        _bullet('To deliver necessary in-app service notifications.'),
        _title('3. Security'),
        _bullet('We use basic transport encryption and access control protections.'),
        _bullet('We remove data within a reasonable period after account cancellation.'),
        _title('4. Your Rights'),
        _bullet('You can review, edit, and request deletion of your information.'),
        _bullet('You can revoke third-party platform access at any time.'),
        _title('5. Contact'),
        _body('For privacy questions, contact: 13100162717@163.com'),
      ],
    );
  }
}
