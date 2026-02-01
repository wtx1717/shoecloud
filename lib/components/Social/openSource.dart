import 'package:flutter/material.dart';
import 'package:shoecloud/components/Social/socialCard.dart';

class Opensource extends StatefulWidget {
  const Opensource({super.key});

  @override
  State<Opensource> createState() => _OpensourceState();
}

class _OpensourceState extends State<Opensource> {
  @override
  Widget build(BuildContext context) {
    return socialCard(
      title: "开源社区",
      content: Image.asset("lib/assets/social/openSource.png"),
    );
  }
}
