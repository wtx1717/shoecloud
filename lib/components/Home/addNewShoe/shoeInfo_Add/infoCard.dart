import 'package:flutter/material.dart';

class cardShoeInfo_Add extends StatefulWidget {
  final String name;
  final String brand;
  final double release_price;
  final int release_year;
  final List<String> features;
  final String description;
  final String category;

  cardShoeInfo_Add({
    required this.name,
    required this.brand,
    required this.release_price,
    required this.release_year,
    required this.features,
    required this.description,
    required this.category,
  });

  @override
  State<cardShoeInfo_Add> createState() => _cardShoeInfo_AddState();
}

class _cardShoeInfo_AddState extends State<cardShoeInfo_Add> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getShoeName(),
          SizedBox(height: 10),
          _getBrand_ReleasePrice_ReleaseYear(),
          SizedBox(height: 10),
          _getFeatures_Category(),
          SizedBox(height: 10),
          _getDescription(),
        ],
      ),
    );
  }

  Widget _getShoeName() {
    return Center(
      child: Text(
        widget.name,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _getBrand_ReleasePrice_ReleaseYear() {
    return Center(
      child: Text(
        "品牌: ${widget.brand} | 发售价格: ${widget.release_price}元 | 上市时间: ${widget.release_year}年",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _getFeatures_Category() {
    return Center(
      child: Text(
        "功能: ${widget.features.join(", ")}  |  类别: ${widget.category}",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _getDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Text(
          "描述: ${widget.description}",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
