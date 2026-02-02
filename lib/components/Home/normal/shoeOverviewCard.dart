// 跑鞋概览卡片组件
import 'package:flutter/material.dart';

// ignore: camel_case_types
class shoeOverviewCard extends StatefulWidget {
  final int shoeId;
  const shoeOverviewCard({super.key, required this.shoeId});

  @override
  State<shoeOverviewCard> createState() => _shoeOverviewCardState();
}

// ignore: camel_case_types
class _shoeOverviewCardState extends State<shoeOverviewCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: Color.fromARGB(92, 158, 158, 158),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _getShoeOverviewCardChildren(),
      ),
    );
  }

  // 获取跑鞋概览卡片的子组件列表
  List<Widget> _getShoeOverviewCardChildren() {
    return [_getImage(), SizedBox(width: 20), _getInformation()];
  }

  //鞋子实例图片
  Widget _getImage() {
    return Flexible(
      flex: 4,
      child: Image.asset(
        "lib/assets/home/shoe_example.png",
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
    );
  }

  //概览信息
  Widget _getInformation() {
    return Flexible(
      flex: 6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,

          //鞋子信息示例
          //这里实际上应该为一个json文件，并从该文件中解析获得数据显示，目前先写死为一定的内容
          children: [
            //名称or昵称
            Text(
              "Nike Air Zoom Pegasus ${widget.shoeId}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            //总里程
            Text(
              "总里程：xxx km",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 10),
            //使用次数
            Text(
              "使用次数：33次",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
