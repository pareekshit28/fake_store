import 'package:fake_store/Services.dart';
import 'package:fake_store/data/CartItem.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  final Services services = Services();

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  double _totalAmount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Cart"),
      ),
      bottomNavigationBar: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: Card(
          elevation: 10,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              "Total Amount: \$ ${_totalAmount.toString()}",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )),
          ),
        ),
      ),
      body: FutureBuilder(
          future: widget.services.getCartItems().whenComplete(() {
            setState(() {
              _totalAmount = Services.totalAmount;
            });
          }),
          builder:
              (BuildContext context, AsyncSnapshot<List<CartItem>> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.length > 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListView.separated(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          snapshot.data
                              .sort((a, b) => b.count.compareTo(a.count));
                          return ListTile(
                            title: Text(snapshot.data.elementAt(index).title),
                            leading: Image.network(
                              snapshot.data.elementAt(index).image,
                              height: 50,
                              width: 40,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "\$ " +
                                    snapshot.data
                                        .elementAt(index)
                                        .price
                                        .toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.add,
                                            size: 20,
                                          ),
                                          onPressed: () async {
                                            bool res = await widget.services
                                                .saveToCart(snapshot.data
                                                    .elementAt(index));
                                            if (res == true) {
                                              setState(() {});
                                            } else {
                                              SnackBar(
                                                content: Text(
                                                    "Something went wrong, Please try again!"),
                                              );
                                            }
                                          })),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(snapshot.data
                                    .elementAt(index)
                                    .count
                                    .toString()),
                                SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.remove,
                                            size: 20,
                                          ),
                                          onPressed: () async {
                                            bool res = await widget.services
                                                .deleteFromCart(snapshot.data
                                                    .elementAt(index));
                                            if (res == true) {
                                              setState(() {});
                                            } else {
                                              SnackBar(
                                                content: Text(
                                                    "Something went wrong, Please try again!"),
                                              );
                                            }
                                          })),
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text("Nothing here!"),
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
