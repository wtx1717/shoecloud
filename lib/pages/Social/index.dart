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
    return CustomScrollView(slivers: _getScrollViewSlivers());
  }

  List<Widget> _getScrollViewSlivers() {
    return [
      SliverToBoxAdapter(child: shoeReviews()),
      SliverToBoxAdapter(child: shoeKnowledge()),
      SliverToBoxAdapter(child: Opensource()),
      SliverToBoxAdapter(child: more()),
    ];
  }
}
