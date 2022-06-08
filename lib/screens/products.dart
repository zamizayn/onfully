import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/pojo/productpojo.dart';
import 'package:ecom_app/screens/addProduct.dart';
import 'package:ecom_app/screens/product_detail.dart';
import 'package:ecom_app/viewModel/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool list = false;
  ProductPojo? pojo;
  RefreshController controller = RefreshController(initialRefresh: false);
  TextEditingController search = TextEditingController();
  List<Result>? searchPojo;

  @override
  void initState() {
    super.initState();
    new Future.delayed(new Duration(seconds: 0), () {
      getLoading(context);
      getProducts();
    });
    search.addListener(() {
      searchData(search.text.toString());
    });
  }

  void getProducts() async {
    ProductsVM vm = ProductsVM();
    pojo = await vm.listProducts(context);
    Navigator.pop(context);
    setState(() {});
  }

  void refresh() async {
    new Future.delayed(new Duration(seconds: 0), () {
      getLoading(context);
      getProducts();
      controller.refreshCompleted();
    });
  }

  void searchData(String keyword) {
    searchPojo = null;
    searchPojo = pojo!.results;
    searchPojo = pojo!.results
        .where((element) =>
            element.name.toLowerCase().contains(keyword.toLowerCase()))
        .toList();

    setState(() {});
    // print('keyword' + keyword);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.5;
    final double itemWidth = size.width / 2;
    return Scaffold(
      appBar: appBarContent("PRODUCTS"),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4, top: 4, bottom: 8),
        child: Container(
          height: 70,
          width: 70,
          child: Neumorphic(
            style: NeumorphicStyle(
                shape: NeumorphicShape.convex,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
                color: Colors.white),
            child: IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  size: 30,
                  color: purple,
                ),
                onPressed: () async {
                  String result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProduct()),
                  );
                  if (result == 'added') {
                    new Future.delayed(new Duration(seconds: 0), () {
                      getLoading(context);
                      getProducts();
                    });
                  }
                }),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Neumorphic(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: deviceWidth * responsiveMargin()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        hint: 'Search your products',
                        inputType: TextInputType.text,
                        formatters: [],
                        controller: search,
                        isEnabled: true),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "VIEW / ADD PRODUCTS",
                                    style: TextStyle(
                                        color: purple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 4.0, right: 4, top: 4, bottom: 8),
                                child: list
                                    ? Neumorphic(
                                        style: NeumorphicStyle(
                                            shape: NeumorphicShape.convex,
                                            boxShape:
                                                NeumorphicBoxShape.roundRect(
                                                    BorderRadius.circular(50)),
                                            color: Colors.white),
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.grid_on,
                                              color: purple,
                                            ),
                                            onPressed: () {
                                              list = !list;
                                              setState(() {});
                                            }),
                                      )
                                    : Neumorphic(
                                        style: NeumorphicStyle(
                                            shape: NeumorphicShape.convex,
                                            boxShape:
                                                NeumorphicBoxShape.roundRect(
                                                    BorderRadius.circular(50)),
                                            color: Colors.white),
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.list,
                                              color: purple,
                                            ),
                                            onPressed: () {
                                              list = !list;
                                              setState(() {});
                                            }),
                                      ),
                              )
                            ],
                          ),

                          SizedBox(
                            height: 15,
                          ),
                          // topSecttion(),
                          // SizedBox(
                          //   height: 30,
                          // ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Showing all the products")),
                          SizedBox(
                            height: 15,
                          ),
                          list == false &&
                                  pojo != null &&
                                  search.text.toString().length == 0
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  reverse: false,
                                  itemCount: pojo!.results.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: (itemWidth / itemHeight),
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 5.0,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0,
                                          bottom: 8,
                                          left: 4,
                                          right: 4),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             ProductDetail(
                                          //               id: pojo!
                                          //                   .results[index].id
                                          //                   .toString(),
                                          //             )));
                                          showBottom(context, index, 'normal');
                                        },
                                        child: Container(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color(0xffa3aaaf),
                                                      blurRadius: 3.0,
                                                      offset: Offset(2, 3))
                                                ]),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      CoolAlert.show(
                                                        context: context,
                                                        confirmBtnColor: purple,
                                                        backgroundColor:
                                                            Colors.red,
                                                        showCancelBtn: true,
                                                        cancelBtnText: "NO",
                                                        confirmBtnText: "YES",
                                                        onCancelBtnTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        widget: WillPopScope(
                                                          child: Container(),
                                                          onWillPop: () async =>
                                                              true,
                                                        ),
                                                        onConfirmBtnTap:
                                                            () async {
                                                          Navigator.pop(
                                                              context);
                                                          getLoading(context);
                                                          ProductsVM vm =
                                                              ProductsVM();
                                                          String? message = await vm
                                                              .removeproduct(
                                                                  context,
                                                                  pojo!
                                                                      .results[
                                                                          index]
                                                                      .id
                                                                      .toString());
                                                          if (message ==
                                                              "success") {
                                                            pojo!.results
                                                                .removeAt(
                                                                    index);

                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          }
                                                          // Navigator.pushAndRemoveUntil(
                                                          //   context,
                                                          //   MaterialPageRoute(
                                                          //     builder: (BuildContext context) =>
                                                          //         Dashboard(),
                                                          //   ),
                                                          //   (route) => false,
                                                          // );
                                                        },
                                                        barrierDismissible:
                                                            true,
                                                        type: CoolAlertType
                                                            .warning,
                                                        text:
                                                            "Do you want to delete this product ?",
                                                      );
                                                    },
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Image.network(
                                                      IMAGEURL +
                                                          pojo!
                                                              .results[index]
                                                              .imageDetails[0]
                                                              .productImage,
                                                      height: 135,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8,
                                                          top: 4),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        pojo!.results[index]
                                                            .name,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0,
                                                          left: 8,
                                                          right: 8,
                                                          bottom: 10),
                                                  child: Row(
                                                    children: [
                                                      pojo!
                                                                  .results[
                                                                      index]
                                                                  .discount
                                                                  .length ==
                                                              0
                                                          ? Text(
                                                              "Rs. " +
                                                                  pojo!
                                                                      .results[
                                                                          index]
                                                                      .price,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          : Text(
                                                              "Rs. " +
                                                                  pojo!
                                                                      .results[
                                                                          index]
                                                                      .discount,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                      Spacer(),
                                                      Container(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0,
                                                                  right: 8,
                                                                  top: 4,
                                                                  bottom: 4),
                                                          child: Text(
                                                            "4.5",
                                                            style: TextStyle(
                                                                color: purple,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey.shade400,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                      ),
                                    );
                                  },
                                )
                              : pojo != null &&
                                      search.text.toString().length == 0
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      reverse: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: pojo!.results.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, bottom: 12),
                                          child: Container(
                                            height: 90,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.network(
                                                  IMAGEURL +
                                                      pojo!
                                                          .results[index]
                                                          .imageDetails
                                                          .first
                                                          .productImage,
                                                  height: 60,
                                                  width: 60,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(pojo!
                                                        .results[index].name),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "Rs. " +
                                                          pojo!.results[index]
                                                              .price,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        child: Text(
                                                          "4.5",
                                                          style: TextStyle(
                                                              color: purple,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey.shade400,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color(0xffa3aaaf),
                                                      blurRadius: 3.0,
                                                      offset: Offset(2, 3))
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        );
                                      })
                                  : Container(),
                          search.text.toString().length > 0
                              ? searchGrid()
                              : Container()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showBottom(BuildContext context, int index, String type) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 50,
                  child: ListTile(
                    onTap: () {
                      if (type == 'search') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetail(
                                      id: searchPojo![index].id.toString(),
                                      type: 'edit',
                                    )));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetail(
                                      id: pojo!.results[index].id.toString(),
                                      type: 'edit',
                                    )));
                      }
                    },
                    title: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          "Edit this product",
                          style: TextStyle(color: Colors.black),
                        ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  child: ListTile(
                    onTap: () async {
                      if (type == 'search') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetail(
                                      id: searchPojo![index].id.toString(),
                                      type: 'normal',
                                    )));
                      } else if (type == 'normal') {
                        String result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetail(
                                      id: pojo!.results[index].id.toString(),
                                      type: 'normal',
                                    )));
                      }
                    },
                    title: Row(
                      children: [
                        Icon(Icons.remove_red_eye),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          "View this product",
                          style: TextStyle(color: Colors.black),
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  GridView searchGrid() {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.5;
    final double itemWidth = size.width / 2;
    return GridView.builder(
      shrinkWrap: true,
      reverse: false,
      itemCount: searchPojo!.length,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        log("IMAGE IS " + searchPojo![index].imageDetails.last.productImage);
        return Padding(
          padding:
              const EdgeInsets.only(top: 8.0, bottom: 8, left: 4, right: 4),
          child: GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => ProductDetail(
              //           id: searchPojo![index].id.toString(),
              //         )));
              showBottom(context, index, 'search');
            },
            child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xffa3aaaf),
                          blurRadius: 3.0,
                          offset: Offset(2, 3))
                    ]),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          CoolAlert.show(
                            context: context,
                            confirmBtnColor: purple,
                            backgroundColor: Colors.red,
                            showCancelBtn: true,
                            cancelBtnText: "NO",
                            confirmBtnText: "YES",
                            onCancelBtnTap: () {
                              Navigator.pop(context);
                            },
                            widget: WillPopScope(
                              child: Container(),
                              onWillPop: () async => true,
                            ),
                            onConfirmBtnTap: () async {
                              Navigator.pop(context);
                              getLoading(context);
                              ProductsVM vm = ProductsVM();
                              String? message = await vm.removeproduct(
                                  context, searchPojo![index].id.toString());
                              if (message == "success") {
                                searchPojo!.removeAt(index);

                                Navigator.pop(context);
                                setState(() {});
                              }
                              // Navigator.pushAndRemoveUntil(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (BuildContext context) =>
                              //         Dashboard(),
                              //   ),
                              //   (route) => false,
                              // );
                            },
                            barrierDismissible: true,
                            type: CoolAlertType.warning,
                            text: "Do you want to delete this product ?",
                          );
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          IMAGEURL +
                              searchPojo![index].imageDetails.last.productImage,
                          height: 135,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8, top: 4),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            searchPojo![index].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8, right: 8, bottom: 10),
                      child: Row(
                        children: [
                          searchPojo![index].discount.length == 0
                              ? Text(
                                  "Rs. " + searchPojo![index].price,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  "Rs. " + searchPojo![index].discount,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                          Spacer(),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, top: 4, bottom: 4),
                              child: Text(
                                "4.5",
                                style: TextStyle(
                                    color: purple, fontWeight: FontWeight.bold),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(5)),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
        );
      },
    );
  }

  Padding topSecttion() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Neumorphic(
            child: Container(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      color: purple,
                    ),
                    Text("Search")
                  ],
                ),
              ),
            ),
          ),
          Neumorphic(
            child: Container(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sort_by_alpha,
                      color: purple,
                    ),
                    Text("  Sort")
                  ],
                ),
              ),
            ),
          ),
          Neumorphic(
            child: Container(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sort,
                      color: purple,
                    ),
                    Text("  Filter")
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
