import 'package:flutter/material.dart';

class CartItem {
  final int id;
  final String title;
  final price;
  final String description;
  final String category;
  final String image;
  final int count;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.description,
      @required this.category,
      @required this.image,
      @required this.count});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
        id: json['id'],
        title: json['title'],
        price: json['price'],
        description: json['description'],
        category: json['category'],
        image: json['image'],
        count: json['count']);
  }

  static Map<String, dynamic> toMap(CartItem cartItem) => {
        "id": cartItem.id,
        "title": cartItem.title,
        "price": cartItem.price,
        "description": cartItem.description,
        "category": cartItem.category,
        "image": cartItem.image
      };
}
