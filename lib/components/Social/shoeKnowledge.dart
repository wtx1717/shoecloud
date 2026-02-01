import 'package:flutter/material.dart';
import 'package:shoecloud/components/Social/socialCard.dart';

class shoeKnowledge extends StatefulWidget {
  const shoeKnowledge({super.key});

  @override
  State<shoeKnowledge> createState() => _shoeKnowledgeState();
}

class _shoeKnowledgeState extends State<shoeKnowledge> {
  @override
  Widget build(BuildContext context) {
    return socialCard(
      title: "跑鞋知识",
      content: Image.asset("lib/assets/social/shoeKnowledge.png"),
    );
  }
}
