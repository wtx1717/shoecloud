import 'package:flutter/material.dart';

// 符合规范：lowerCamelCase 类名
class policyContent extends StatelessWidget {
  final bool isChinese;
  const policyContent({super.key, required this.isChinese});

  @override
  Widget build(BuildContext context) {
    return isChinese ? chineseText() : englishText();
  }

  // 辅助组件：小标题
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF388E3C), // 深抹茶绿
        ),
      ),
    );
  }

  // 辅助组件：正文
  Widget bodyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF455A64),
        height: 1.6,
      ),
    );
  }

  // 辅助组件：带圆点的列表项
  Widget bulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(Icons.circle, size: 6, color: Color(0xFFC5E1A5)),
          ),
          const SizedBox(width: 10),
          Expanded(child: bodyText(text)),
        ],
      ),
    );
  }

  // 辅助组件：高亮文本
  TextSpan highlight(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF2E7D32),
      ),
    );
  }

  // --- 完整中文内容 ---
  Widget chineseText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bodyText(
          "欢迎使用 “云鞋库”（以下简称“本应用”）。我们深知个人信息对您的重要性，并庄严承诺保护您的隐私。本政策旨在清晰地说明，当您使用本应用时，我们如何收集、使用、存储和保护您的信息，以及您享有的权利。",
        ),

        sectionTitle("1. 我们收集哪些信息？"),
        bodyText("为了向您提供核心的跑鞋管理服务，我们需要处理以下信息："),
        bulletItem("您主动提供的信息：您创建的账户信息（如用户名）、您手动添加的跑鞋信息（如品牌、型号、购买日期）。"),
        bulletItem(
          "从第三方运动平台同步的信息：在获得您的明确授权后，我们会从您指定的第三方运动平台（如 Garmin Connect, COROS）同步您的运动活动数据。这些数据可能包括：活动时间、距离、持续时间、GPS轨迹等。我们不会收集或存储您在该平台的登录凭证（用户名和密码）。",
        ),
        bulletItem(
          "应用使用信息：为改进产品，我们可能会收集匿名的、无法识别个人身份的使用数据（如功能点击频率、崩溃报告），这类信息不包含任何个人身份信息。",
        ),

        sectionTitle("2. 我们如何使用这些信息？"),
        bodyText("您的信息将仅用于以下明确、有限的用途："),
        bulletItem(
          "提供核心服务：将您的跑步活动与特定跑鞋自动关联，计算并展示每双跑鞋的累计里程、磨损状态，并提供个性化的维护或更换建议。",
        ),
        bulletItem("改进产品体验：分析匿名使用数据以优化应用界面和性能。"),
        bulletItem("与您沟通：必要时，通过应用内通知或您提供的联系方式，向您发送与服务相关的通知（如重要功能更新、政策变更）。"),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF455A64),
              height: 1.6,
            ),
            children: [
              const TextSpan(text: "我们承诺："),
              highlight("绝不会"),
              const TextSpan(
                text: "出于任何营销目的向第三方出售、出租或交易您的个人数据。所有数据处理活动均严格限于实现上述服务目的。",
              ),
            ],
          ),
        ),

        sectionTitle("3. 数据存储与安全"),
        bulletItem("存储地点与期限：您的数据将存储在云端服务器上。我们仅在为您提供服务所需的期限内保留您的数据。"),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF455A64),
              height: 1.6,
            ),
            children: [
              const TextSpan(text: "如果您选择注销账户，我们将在 "),
              highlight("14个工作日内"),
              const TextSpan(text: " 删除您的所有个人数据。"),
            ],
          ),
        ),
        bulletItem("安全措施：我们采取加密传输、访问控制等技术和管理措施保护您的数据安全。"),

        sectionTitle("4. 您的权利"),
        bulletItem("访问与更正：您可以在应用内随时访问和更正信息。"),
        bulletItem("撤销授权：您可以在设置中随时断开与第三方平台的连接。"),
        bulletItem("删除数据：您可以通过注销账户要求删除所有个人数据。"),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF455A64),
              height: 1.6,
            ),
            children: [
              const TextSpan(text: "联系我们：请通过 "),
              highlight("13100162717@163.com"),
              const TextSpan(text: " 联系，我们将在 14个工作日内答复。"),
            ],
          ),
        ),

        sectionTitle("5. 第三方服务"),
        bodyText(
          "本应用集成了第三方服务（如 Garmin, COROS 的开放平台）。当您授权访问时，您的信息处理将同时受该第三方隐私政策的约束。",
        ),

        sectionTitle("6. 政策更新"),
        bodyText("我们可能会不时更新本政策。更新后，我们会在应用内发布新版本。您继续使用即视为接受更新后的政策。"),

        sectionTitle("7. 联系我们"),
        bodyText("邮箱：13100162717@163.com"),
      ],
    );
  }

  // --- 完整英文内容 ---
  Widget englishText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bodyText(
          "Welcome to 'ShoeCloud'. We understand the importance of personal information to you and solemnly commit to protecting your privacy.",
        ),

        sectionTitle("1. What information do we collect?"),
        bulletItem(
          "Information you actively provide: Account (username), shoe information (brand, model, purchase date).",
        ),
        bulletItem(
          "Information synced from third-party sports platforms: With your authorization, we sync sports activity data (time, distance, GPS track, etc.) from platforms like Garmin Connect, COROS. We will not collect your login credentials.",
        ),
        bulletItem(
          "App usage information: Anonymous, non-identifiable usage data to improve our product.",
        ),

        sectionTitle("2. How do we use this information?"),
        bulletItem(
          "Providing core services: Automatically associate activities with shoes and calculate cumulative mileage.",
        ),
        bulletItem(
          "Improving product experience: Optimize app interface and performance.",
        ),
        bulletItem(
          "Communicating with you: Send service-related notifications via in-app alerts.",
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF455A64),
              height: 1.6,
            ),
            children: [
              const TextSpan(text: "We promise: We will "),
              highlight("NEVER"),
              const TextSpan(
                text:
                    " sell, rent or trade your personal data to third parties for marketing purposes.",
              ),
            ],
          ),
        ),

        sectionTitle("3. Data storage and security"),
        bulletItem("Storage: Your data is stored on cloud servers."),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF455A64),
              height: 1.6,
            ),
            children: [
              const TextSpan(
                text:
                    "If you cancel your account, we will delete all your data within ",
              ),
              highlight("14 working days"),
              const TextSpan(text: "."),
            ],
          ),
        ),

        sectionTitle("4. Your rights"),
        bulletItem("Access and correction: Manage your info anytime in-app."),
        bulletItem(
          "Revocation of authorization: Disconnect from third-party platforms in settings.",
        ),
        bulletItem("Data deletion: Request deletion via account cancellation."),
        bodyText("Contact: 13100162717@163.com. 14-day response time."),

        sectionTitle("5. Third-party services"),
        bodyText(
          "When you authorize access to platforms like Garmin or COROS, your data is also subject to their privacy policies.",
        ),

        sectionTitle("6. Policy updates"),
        bodyText(
          "Continued use of this App will be deemed as acceptance of the updated policy.",
        ),

        sectionTitle("7. Contact us"),
        bodyText("Email: 13100162717@163.com"),
      ],
    );
  }
}
