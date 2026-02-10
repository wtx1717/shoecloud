import 'package:flutter/material.dart';
import 'package:shoecloud/components/Social/openSource.dart';
import 'package:shoecloud/components/Social/shoeKnowledge.dart';
import 'package:shoecloud/components/Social/shoeReviews.dart';
import 'package:shoecloud/components/Social/more.dart';

class SocialView extends StatefulWidget {
  const SocialView({super.key});

  @override
  State<SocialView> createState() => _SocialViewState();
}

class _SocialViewState extends State<SocialView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 延续云鞋库的背景色
      backgroundColor: const Color(0xFFE8F5E9),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: _getScrollViewSlivers(),
      ),
    );
  }

  List<Widget> _getScrollViewSlivers() {
    return [
      // 顶部留白，增加空气感
      const SliverToBoxAdapter(child: SizedBox(height: 20)),

      SliverToBoxAdapter(child: const shoeReviews()),
      SliverToBoxAdapter(child: const shoeKnowledge()),
      SliverToBoxAdapter(child: const Opensource()),
      SliverToBoxAdapter(child: const more()),

      // 底部留白
      const SliverToBoxAdapter(child: SizedBox(height: 30)),
    ];
  }
}
