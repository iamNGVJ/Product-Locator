import 'dart:core';

class Products {
  List<String> colors;
  int size;
  int rating;
  String brandName;
  String productName;
  String imageUrl;
  double price;
  DateTime date;

  Products(
      {this.size,
      this.rating,
      this.brandName,
      this.productName,
      this.imageUrl,
      this.price,
      this.date});

  Products.fromJSON(Map<String, dynamic> json)
    : size = json['size'],
      rating = json['rating'],
      brandName = json['brandName'],
      productName = json['productName'],
      imageUrl = json['imageUrl'],
      price = json['price'].toDouble(),
      date = DateTime.parse(json['date']);
}
