import 'package:flutter/material.dart';

// ignore: camel_case_types
class shoeInfoMin extends StatefulWidget {
  final String shoeName;
  final String imageUrl;
  const shoeInfoMin({
    super.key,
    required this.shoeName,
    required this.imageUrl,
  });

  @override
  State<shoeInfoMin> createState() => _shoeInfoMinState();
}

// ignore: camel_case_types
class _shoeInfoMinState extends State<shoeInfoMin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.greenAccent[100],
      ),

      child: Column(
        children: [
          Image.network(
            widget.imageUrl,
            height: 130,
            width: 130,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            widget.shoeName,
            style: TextStyle(fontSize: 10, color: Colors.black),
            overflow: TextOverflow.ellipsis, // 关键属性
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
