import 'package:fake_store/Services.dart';
import 'package:fake_store/data/Product.dart';
import 'package:fake_store/pages/CartPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDescription extends StatefulWidget {
  final int id;
  final Services services = Services();

  ProductDescription({@required this.id});

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool loaded = false;

  Future<Product> futureProduct;

  @override
  Widget build(BuildContext context) {
    futureProduct = widget.services.fetchOneProduct(widget.id);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Product Details"),
      ),
      bottomNavigationBar: loaded
          ? SizedBox(
              height: 70,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
                margin: EdgeInsets.all(0),
                child: InkWell(
                  onTap: () async {
                    bool res = await widget.services.saveToCart(futureProduct);

                    if (res == true) {
                      Navigator.of(context).push(
                          CupertinoPageRoute(builder: (context) => Cart()));
                    } else {
                      SnackBar(
                        content:
                            Text("Something went wrong, Please try again!"),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Add to Cart",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))
                    ],
                  ),
                ),
              ),
            )
          : null,
      body: FutureBuilder(
          future: futureProduct,
          builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                setState(() {
                  loaded = true;
                });
              });
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Center(
                        child: Image.network(
                          snapshot.data.image,
                          height: 350,
                        ),
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Divider()),
                    SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(230, 230, 230, 1),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 18,
                                      color: Colors.black87,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      snapshot.data.category,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Price: \$ " + snapshot.data.price.toString(),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Product Description",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          SizedBox(
                            height: 1,
                          ),
                          Text(snapshot.data.description,
                              style: TextStyle(
                                fontSize: 14,
                              )),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Couldn't load results right now\n:(",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                        color: Colors.blueGrey,
                        child: Text("🔃 Refresh"),
                        onPressed: () {
                          setState(() {
                            futureProduct =
                                widget.services.fetchOneProduct(widget.id);
                          });
                        })
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
