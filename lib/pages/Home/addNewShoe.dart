import 'package:flutter/material.dart';
import 'package:shoecloud/api/home.dart';
import 'package:shoecloud/components/Home/addNewShoe/expandableCategoryBar.dart';
import 'package:shoecloud/components/Home/addNewShoe/shoeInfoMin.dart';
import 'package:shoecloud/components/common/clickableWrapper.dart';
import 'package:shoecloud/viewmodels/addShoeInfo.dart';

class addNewShoeView extends StatefulWidget {
  const addNewShoeView({super.key});

  @override
  State<addNewShoeView> createState() => _addNewShoeViewState();
}

class _addNewShoeViewState extends State<addNewShoeView> {
  //从服务器获取的鞋子数据
  List<addShoeInfo> _list = [];

  @override
  void initState() {
    super.initState();
    _getList();
  }

  void _getList() async {
    _list = await getAddShoeInfoListAPI();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // 保持背景色统一
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: _getScrollViewSlivers(),
        ),
      ),
    );
  }

  List<Widget> _getScrollViewSlivers() {
    return [
      // 顶部分类栏悬停效果
      SliverFloatingHeader(child: const expandableCategoryBar()),
      SliverToBoxAdapter(child: const SizedBox(height: 10)),

      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 每行3个
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),

          delegate: SliverChildBuilderDelegate((context, index) {
            return clickableWrapper(
              route: "shoeInfo_AddView",
              arguments: {
                'id': _list[index].id,
                'name': _list[index].name,
                'brand': _list[index].brand,
                'release_price': _list[index].release_price,
                'release_year': _list[index].release_year,
                'features': _list[index].features,
                'imagesUrl': _list[index].imagesUrl,
                'description': _list[index].description,
                'category': _list[index].category,
              },
              child: shoeInfoMin(
                shoeName: _list[index].name,
                imageUrl: _list[index].imagesUrl[0],
              ),
            );
          }, childCount: _list.length),
        ),
      ),
    ];
  }
}
