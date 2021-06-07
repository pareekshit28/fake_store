import 'package:fake_store/Services.dart';
import 'package:fake_store/data/Product.dart';
import 'package:fake_store/pages/CartPage.dart';
import 'package:fake_store/pages/ProductDescriptionPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  final Services services = Services();
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Products"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: () => Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (context) => Cart())))
        ],
      ),
      body: FutureBuilder<List<Product>>(
          future: widget.services.fetchAllProducts(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.all(2),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: InkWell(
                        onTap: () =>
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => ProductDescription(
                                      id: snapshot.data.elementAt(index).id,
                                    ))),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Image.network(
                                  snapshot.data.elementAt(index).image,
                                  height: 150,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                snapshot.data.elementAt(index).title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Spacer(),
                              Text("Price"),
                              Text("\$ " +
                                  snapshot.data
                                      .elementAt(index)
                                      .price
                                      .toString())
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.61),
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
                          setState(() {});
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
