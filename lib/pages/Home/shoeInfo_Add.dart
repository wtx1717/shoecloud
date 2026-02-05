import 'package:flutter/material.dart';
import 'package:shoecloud/components/Home/addNewShoe/shoeInfo_Add/banner.dart';
import 'package:shoecloud/components/Home/addNewShoe/shoeInfo_Add/bindNFCBottom.dart';
import 'package:shoecloud/components/Home/addNewShoe/shoeInfo_Add/infoCard.dart';

class shoeInfo_AddView extends StatefulWidget {
  const shoeInfo_AddView({super.key});

  @override
  State<shoeInfo_AddView> createState() => _shoeInfo_AddViewState();
}

class _shoeInfo_AddViewState extends State<shoeInfo_AddView> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Bind Your New Shoe')),
      body: SafeArea(
        child: Column(
          children: [
            // 轮播图
            bannerShoeInfo_Add(imagesUrl: args['imagesUrl']),
            SizedBox(height: 10),

            // 信息卡片
            cardShoeInfo_Add(
              name: args['name'],
              brand: args['brand'],
              release_price: args['release_price'],
              release_year: args['release_year'],
              features: args['features'],
              description: args['description'],
              category: args['category'],
            ),

            Spacer(), //填充空白
            // 绑定NFC按钮
            bindNFCBottom(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
