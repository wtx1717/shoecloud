import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// 定义一个StatefulWidget来展示鞋子的轮播图信息
class bannerShoeInfo_Add extends StatefulWidget {
  final List<String> imagesUrl; // 存储鞋子图片的URL列表

  // 构造函数，接收图片URL列表作为参数
  const bannerShoeInfo_Add({super.key, required this.imagesUrl});

  @override
  // 创建对应的State对象
  State<bannerShoeInfo_Add> createState() => _bannerShoeInfo_AddState();
}

// 定义bannerShoeInfo_Add的State类
class _bannerShoeInfo_AddState extends State<bannerShoeInfo_Add> {
  CarouselSliderController _controller = CarouselSliderController(); // 轮播图控制器
  int _currentPage = 0; // 当前激活图片的索引

  // 构建轮播图插件
  Widget _buildBanner() {
    // 获取屏幕宽度
    final double screenWidth = MediaQuery.of(context).size.width;
    return CarouselSlider(
      carouselController: _controller, // 控制轮播图
      items: List.generate(widget.imagesUrl.length, (index) {
        // 根据imagesUrl列表生成Image网络图片
        return Image.network(widget.imagesUrl[index], width: screenWidth);
      }),
      options: CarouselOptions(
        autoPlayInterval: Duration(seconds: 3), // 自动播放间隔时间
        viewportFraction: 1.0, // 设置视图中显示的图片比例
        autoPlay: true, // 是否自动播放
        onPageChanged: (index, reason) {
          // 当页面改变时更新当前索引并刷新UI
          _currentPage = index;
          setState(() {});
        },
      ),
    );
  }

  // 构建底部指示器
  Widget _getDots() {
    return Positioned(
      bottom: 10.0, // 距离底部的距离
      left: 0.0, // 距离左边的距离
      right: 0.0, // 距离右边的距离
      child: SizedBox(
        height: 40, // 指示器的高度
        width: double.infinity, // 指示器的宽度
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 指示器居中
          children: List.generate(widget.imagesUrl.length, (index) {
            // 根据图片数量生成指示器
            return GestureDetector(
              onTap: () {
                // 点击指示器时跳转到对应页面
                _controller.animateToPage(index);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200), // 动画持续时间
                width: index == _currentPage ? 40 : 20, // 当前页指示器宽度较大
                height: 6, // 指示器高度
                margin: EdgeInsets.symmetric(horizontal: 5.0), // 指示器之间的间距
                decoration: BoxDecoration(
                  color: index == _currentPage
                      ? const Color(0xFFFFF9C4) // 当前页指示器颜色较亮
                      : Colors.grey[300], // 其他页指示器颜色较暗
                  borderRadius: BorderRadius.circular(3), // 指示器的圆角
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  // 构建整个Widget树
  Widget build(BuildContext context) {
    return Stack(children: [_buildBanner(), _getDots()]); // 将轮播图和指示器叠加在一起
  }
}
