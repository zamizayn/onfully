import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/pojo/profilepojo.dart';
import 'package:ecom_app/screens/addBanner.dart';
import 'package:ecom_app/viewModel/loginVm.dart';
import 'package:ecom_app/viewModel/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ViewShopBanners extends StatefulWidget {
  @override
  _ViewShopBannersState createState() => _ViewShopBannersState();
}

class _ViewShopBannersState extends State<ViewShopBanners> {
  bool flag = false;
  ProfilePojo? pojo;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    new Future.delayed(new Duration(seconds: 0), () {
      getLoading(context);
      getProfile();
    });
  }

  void getProfile() async {
    LoginVM loginVM = LoginVM();
    pojo = await loginVM.getProfileDetails(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarContent("VIEW BANNERS"),
      body: Neumorphic(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                addButton(context),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Active Banners in the app",
                        style: TextStyle(fontSize: 15),
                      )),
                ),
                pojo != null ? staggeredlist() : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding staggeredlist() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: pojo!.shopBanners.length,
        itemBuilder: (BuildContext context, int index) => new Container(
          child: GestureDetector(
            onTap: () {
              showBottom(context, index);
            },
            child: ClipRRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: IMAGEURL + pojo!.shopBanners[index].banner,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        staggeredTileBuilder: (int index) =>
            new StaggeredTile.count(2, index.isEven ? 2 : 1),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
    );
  }

  Future<dynamic> showBottom(BuildContext context, int index) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 50,
              child: ListTile(
                onTap: () {
                  deleteBanner(pojo!.shopBanners[index].id.toString(), index);
                },
                title: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Text(
                      "Delete this banner",
                      style: TextStyle(color: Colors.black),
                    ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  void deleteBanner(String id, int index) async {
    getLoading(context);
    ProductsVM productsVM = ProductsVM();
    String? msg = await productsVM.removeBanner(context, id);
    Navigator.pop(context);
    Navigator.pop(context);
    if (msg == "success") {
      showToast("Banner Deleted Successfully");
      pojo!.shopBanners.removeAt(index);
      setState(() {});
    }
  }

  GestureDetector addButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String? msg = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddBanner()));
        if (msg != null) {
          init();
        }
      },
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Neumorphic(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "ADD MORE BANNERS",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListView bannerList() {
    return ListView.builder(
        itemCount: pojo!.shopBanners.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Stack(
                children: [bannerImage(index, context), bannerIcon()],
              ),
            ),
          );
        });
  }

  Align bannerIcon() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NeumorphicSwitch(
          isEnabled: true,
          style: NeumorphicSwitchStyle(
              activeThumbColor: Colors.green,
              activeTrackColor: Colors.green,
              inactiveThumbColor: Colors.red,
              inactiveTrackColor: Colors.red),
          value: flag,
          onChanged: (val) {
            flag = !flag;
            setState(() {});
          },
          height: 30,
        ),
      ),
    );
  }

  CachedNetworkImage bannerImage(int index, BuildContext context) {
    return CachedNetworkImage(
      imageUrl: IMAGEURL + pojo!.shopBanners[index].banner,
      width: MediaQuery.of(context).size.width,
      height: 200,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.low,
    );
  }
}
