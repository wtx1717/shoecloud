import 'package:flutter/material.dart';
import 'package:shoecloud/nfc/bind.dart';

class bindNFCBottom extends StatefulWidget {
  const bindNFCBottom({super.key});

  @override
  State<bindNFCBottom> createState() => _bindNFCBottomState();
}

class _bindNFCBottomState extends State<bindNFCBottom> {
  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _getBottom("不与NFC绑定", _screenWidth),
        _getBottom("与NFC绑定", _screenWidth),
      ],
    );
  }

  Widget _getBottom(String text, double width) {
    final double _screenHeight = MediaQuery.of(context).size.height;

    //点击事件
    return InkWell(
      onTap: () {
        if (text == "不与NFC绑定") {
          //关闭当前页面
          Navigator.pop(context);
        } else {
          //弹出底部弹窗（非切换路由）
          showModalBottomSheet(
            context: context,
            //透明背景
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              //弹窗内容
              return _getShowModalBottomSheet(_screenHeight);
            },
          );
        }
      },
      //按钮样式
      child: Container(
        height: 80,
        width: width / 2 - 20,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            " $text ",
            style: TextStyle(
              color: text == "不与NFC绑定" ? Colors.red[300] : Colors.green[300],
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getShowModalBottomSheet(double height) {
    return Container(
      height: height * 0.5,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "请将NFC标签靠近手机",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 20),
          Image.asset(
            "lib/assets/home/bindNFC.png",
            height: 150,
            fit: BoxFit.fitHeight,
          ),

          Spacer(),

          GestureDetector(
            onTap: () async {
              //这里要补充NFC绑定逻辑，即写入NFC的行为
              print("用户要绑定NFC标签了");

              await writeToNFC("12");

              //关闭弹窗
              Navigator.pop(context);
            },
            child: Container(
              height: 80,
              width: 160,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Text(
                  " 写入 ",
                  style: TextStyle(color: Colors.green[300], fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
