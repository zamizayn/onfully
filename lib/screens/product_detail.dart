import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/pojo/productdetail.dart';
import 'package:ecom_app/screens/editProduct.dart';
import 'package:ecom_app/viewModel/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductDetail extends StatefulWidget {
  String id;
  String type;
  ProductDetail({required this.id, required this.type});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  RefreshController controller = RefreshController(initialRefresh: false);
  ProductDetailPojo? pojo;
  @override
  void initState() {
    super.initState();
    new Future.delayed(new Duration(seconds: 0), () {
      getLoading(context);
      loadProductDetails();
    });
  }

  void refresh() async {
    getLoading(context);
    loadProductDetails();
    controller.refreshCompleted();
  }

  void loadProductDetails() async {
    ProductsVM vm = ProductsVM();
    pojo = await vm.getProductDetails(context, widget.id);
    setState(() {});
    Navigator.pop(context);
    if (widget.type == 'edit') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProduct(
                  productId: widget.id,
                  incentive: pojo!.incentive,
                  description: pojo!.description,
                  name: pojo!.name,
                  price: pojo!.price,
                  returncontroller: pojo!.returnPeriod,
                  stock: pojo!.stock,
                  tags: pojo!.tagDetails,
                  images: pojo!.imageDetails,
                  category: pojo!.categoryDetails.categoryName,
                  discount: pojo!.discount,
                  purchased: pojo!.purchased,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarContent("PRODUCT DETAILS"),
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
                  Icons.edit,
                  color: purple,
                ),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProduct(
                                productId: widget.id,
                                incentive: pojo!.incentive,
                                description: pojo!.description,
                                name: pojo!.name,
                                price: pojo!.price,
                                returncontroller: pojo!.returnPeriod,
                                stock: pojo!.stock,
                                tags: pojo!.tagDetails,
                                images: pojo!.imageDetails,
                                category: pojo!.categoryDetails.categoryName,
                                discount: pojo!.discount,
                                purchased: pojo!.purchased,
                              )),
                    )),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SmartRefresher(
        controller: controller,
        onRefresh: refresh,
        child: SafeArea(
          child: Neumorphic(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: pojo != null
                  ? SingleChildScrollView(
                      child: bodyContent(),
                    )
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }

  Column bodyContent() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.topLeft,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8),
        //     child: Neumorphic(
        //       style: NeumorphicStyle(
        //         shape: NeumorphicShape.convex,
        //         boxShape:
        //             NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
        //       ),
        //       child: IconButton(
        //           icon: Icon(
        //             Icons.arrow_back_ios,
        //             color: black,
        //             size: 20,
        //           ),
        //           onPressed: () => print("object")),
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: deviceWidth * responsiveMargin()),
          child: Column(
            children: [
              pojo != null
                  ? ProductImages(
                      details: pojo!.imageDetails,
                    )
                  : Container(),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          pojo!.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: pojo!.discount.length == 0
                                  ? Text(
                                      "₹ " + pojo!.price,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: purple),
                                    )
                                  : Text(
                                      "₹ " +
                                          pojo!.discount +
                                          "\n(MRP - Rs. " +
                                          pojo!.price +
                                          ")",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: purple),
                                    ),
                            ),
                          ),
                          Spacer(),
                          Neumorphic(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10, top: 8, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        int stockval = int.parse(pojo!.stock);
                                        if (stockval > 1) {
                                          stockval--;
                                          pojo!.stock = stockval.toString();
                                          setState(() {});
                                        }
                                      },
                                      child: Icon(Icons.remove,
                                          color: Colors.black)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    pojo!.stock,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        int stockVal = int.parse(pojo!.stock);
                                        stockVal++;
                                        pojo!.stock = stockVal.toString();
                                        setState(() {});
                                      },
                                      child:
                                          Icon(Icons.add, color: Colors.black)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        pojo!.description,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            height: 1.4),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Other Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("MRP "),
                      Text("Rs. " + pojo!.price.toString().toUpperCase())
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Onfully Price "),
                      Text("Rs. " + pojo!.discount.toString().toUpperCase())
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Returnable"),
                      Text(pojo!.returnable.toString().toUpperCase())
                    ],
                  ),
                  SizedBox(height: 10),
                  pojo!.returnable
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Return Period"),
                            Text(pojo!.returnPeriod.toString().toUpperCase() +
                                " Days")
                          ],
                        )
                      : Container(),
                  pojo!.returnable ? SizedBox(height: 10) : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Category"),
                      Text(pojo!.categoryDetails.categoryName
                          .toString()
                          .toUpperCase())
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Purchased Amount "),
                      Text("Rs. " + pojo!.purchased.toString().toUpperCase())
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Incentive "),
                      Text("Rs. " + pojo!.incentive.toString().toUpperCase())
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 100,
        )
      ],
    );
  }
}

class ProductImages extends StatefulWidget {
  const ProductImages({required this.details});
  final List<ImageDetail> details;
  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Hero(
              tag: "id",
              child: Image.network(
                  IMAGEURL + widget.details[selectedImage].productImage),
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 90,
          child: ListView.builder(
              itemCount: widget.details.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return buildSmallProductPreview(index);
              }),
        ),
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        selectedImage = index;
        setState(() {});
      },
      child: AnimatedContainer(
        duration: Duration(seconds: 0),
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: purple.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(IMAGEURL + widget.details[index].productImage),
      ),
    );
  }
}
