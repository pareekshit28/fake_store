import 'dart:convert';

import 'package:fake_store/data/CartItem.dart';
import 'package:fake_store/data/Product.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Services {
  static double totalAmount = 0;

  Future<List<Product>> fetchAllProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<Product> allProducts = List<Product>.from(
          jsonDecode(response.body).map((model) => Product.fromJson(model)));
      return allProducts;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Product> fetchOneProduct(int id) async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products/$id'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Product.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<bool> saveToCart(
    var item,
  ) async {
    bool res;
    var _item = item.runtimeType == CartItem ? item : await item;
    var _prefs = await SharedPreferences.getInstance();
    List<String> _oldList = _prefs.getStringList("cartList");
    List<String> _newList = _oldList == null ? [] : _oldList;
    _newList.add(json.encode(_item.runtimeType == Product
        ? Product.toMap(_item)
        : CartItem.toMap(_item)));
    await _prefs.setStringList("cartList", _newList).then((value) {
      res = value;
    });
    return res;
  }

  Future<bool> deleteFromCart(
    var item,
  ) async {
    bool res;
    var _item = item.runtimeType == Product ? await item : item;
    var _prefs = await SharedPreferences.getInstance();
    List<String> _oldList = _prefs.getStringList("cartList");
    List<String> _newList = _oldList == null ? [] : _oldList;
    _newList.remove(json.encode(_item.runtimeType == Product
        ? Product.toMap(_item)
        : CartItem.toMap(_item)));
    await _prefs.setStringList("cartList", _newList).then((value) {
      res = value;
    });
    return res;
  }

  Future<List<CartItem>> getCartItems() async {
    var _prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> _cartList = [];
    Map<int, List<Map<String, dynamic>>> _uniqueMap = {};

    List<CartItem> _uniqueList = [];
    _prefs.getStringList("cartList").forEach((element) {
      _cartList.add(json.decode(element));
    });

    for (Map<String, dynamic> map in _cartList) {
      if (_uniqueMap[map["id"]] == null) {
        _uniqueMap.putIfAbsent(map["id"], () => [map]);
      } else {
        _uniqueMap[map["id"]].add(map);
      }
    }

    totalAmount = 0;
    _uniqueMap.forEach((key, value) {
      var element = value[0];
      element["count"] = value.length;
      totalAmount += element["price"] * element["count"];
      _uniqueList.add(CartItem.fromJson(element));
    });

    return _uniqueList;
  }
}
