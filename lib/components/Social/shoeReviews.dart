import 'package:flutter/material.dart';
import 'package:shoecloud/components/Social/socialCard.dart';

class shoeReviews extends StatefulWidget {
  const shoeReviews({super.key});

  @override
  State<shoeReviews> createState() => _shoeReviewsState();
}

class _shoeReviewsState extends State<shoeReviews> {
  @override
  Widget build(BuildContext context) {
    return socialCard(
      title: "跑鞋评价",
      content: Image.asset("lib/assets/social/shoeReviews.png"),
    );
  }
}
