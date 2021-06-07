import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title;
  final price;
  final String description;
  final String category;
  final String image;

  Product(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.description,
      @required this.category,
      @required this.image});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        title: json['title'],
        price: json['price'],
        description: json['description'],
        category: json['category'],
        image: json['image']);
  }

  static Map<String, dynamic> toMap(Product product) => {
        "id": product.id,
        "title": product.title,
        "price": product.price,
        "description": product.description,
        "category": product.category,
        "image": product.image
      };
}
