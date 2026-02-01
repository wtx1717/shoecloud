import 'package:flutter/material.dart';
import 'package:shoecloud/components/Social/socialCard.dart';

class more extends StatefulWidget {
  const more({super.key});

  @override
  State<more> createState() => _moreState();
}

class _moreState extends State<more> {
  @override
  Widget build(BuildContext context) {
    return socialCard(
      title: "更多",
      content: Image.asset("lib/assets/social/more.png"),
    );
  }
}
