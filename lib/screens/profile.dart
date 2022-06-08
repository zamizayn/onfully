import 'dart:developer';
import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/main.dart';
import 'package:ecom_app/pojo/User.dart';
import 'package:ecom_app/pojo/orderspojo.dart';
import 'package:ecom_app/pojo/productpojo.dart';
import 'package:ecom_app/pojo/profilepojo.dart';
import 'package:ecom_app/screens/edit_shopimage.dart';
import 'package:ecom_app/viewModel/loginVm.dart';
import 'package:ecom_app/viewModel/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import "package:latlong2/latlong.dart" as LatLng;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfilePojo? pojo;
  ProductPojo? products;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  OrdersPojo? orders;
  bool isShopOpen = false;
  Position? pos;

  @override
  void initState() {
    super.initState();
    new Future.delayed(new Duration(seconds: 0), () {
      getLoading(context);
      getProducts();

      getProfile();
      getPos();
    });
  }

  void getPos() async {
    var location = Location();
    PermissionStatus? status = await location.hasPermission();
    print("status" + status.toString());
    if (status == PermissionStatus.denied) {
      await location.requestPermission();
    }
    pos = await _determinePosition();
    setState(() {});
    log('position' + pos!.latitude.toString());
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void getProfile() async {
    LoginVM loginVM = LoginVM();
    pojo = await loginVM.getProfileDetails(context);
    setState(() {});
  }

  void getProducts() async {
    ProductsVM vm = ProductsVM();
    products = await vm.listProducts(context);
    //  Navigator.pop(context);
    // listOrders();
    setState(() {});
  }

  void refresh() async {
    getLoading(context);
    getProfile();
    _refreshController.refreshCompleted();
  }

  // void listOrders() async {
  //   OrdersVm ordersVm = OrdersVm();
  //   orders = await ordersVm.listOrders(context);
  //   print("ORDERRS" + orders!.results.first.imageDetails.length.toString());

  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Scaffold(
      appBar: appBarContent("PROFILE"),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: refresh,
        child: SafeArea(
          child: SingleChildScrollView(
            child: pojo != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      pojo!.imageDetails.isNotEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width.h,
                              height: 25.h,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 0.19),
                                  image: DecorationImage(
                                    colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.7),
                                        BlendMode.dstATop),
                                    image: NetworkImage(IMAGEURL +
                                        pojo!.imageDetails.last["shop_image"]),
                                    fit: BoxFit.cover,
                                  )),
                              child: Center(
                                  child: Text(
                                pojo!.shop_name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold),
                              )))
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          updateButton(context),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "Shop Online Status : ACTIVE",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Spacer(),
                            SizedBox(
                              height: 50,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: NeumorphicSwitch(
                                    style: NeumorphicSwitchStyle(
                                        activeTrackColor: Colors.green,
                                        activeThumbColor: Colors.green,
                                        inactiveTrackColor: Colors.red,
                                        inactiveThumbColor: Colors.red),
                                    isEnabled: true,
                                    value: isShopOpen,
                                    onChanged: (value) {
                                      isShopOpen = !isShopOpen;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: cardLayout(Icon(Icons.mail), pojo!.email),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Card(
                          elevation: 2,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: cardLayout(Icon(Icons.phone_android),
                                  pojo!.phoneNumber)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Card(
                          elevation: 2,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: cardLayout(
                                  Icon(Icons.location_city), pojo!.address)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Card(
                          elevation: 2,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: cardLayout(
                                  Icon(Icons.bike_scooter),
                                  "Delivery Distance : " +
                                      pojo!.deliveryDistance.toString() +
                                      " KM")),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Recently Added",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      products != null
                          ? Container(
                              height: 25.h,
                              child: ListView.builder(
                                  itemCount: products!.results.length,
                                  scrollDirection: Axis.horizontal,
                                  reverse: false,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              child: Image.network(
                                                IMAGEURL +
                                                    products!
                                                        .results[index]
                                                        .imageDetails
                                                        .first
                                                        .productImage,
                                                height: 140,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              products!.results[index].name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 9.sp),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      pos != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: FlutterMap(
                                  options: MapOptions(
                                    center: LatLng.LatLng(
                                        pos!.latitude, pos!.longitude),
                                    zoom: 13.0,
                                  ),
                                  layers: [
                                    TileLayerOptions(
                                        urlTemplate:
                                            "https://api.mapbox.com/styles/v1/shijin9072127759/cktbtjjxb57vi17pcsb9q97b8/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic2hpamluOTA3MjEyNzc1OSIsImEiOiJja3Ric2x3NjAxejVxMm9uOTdkZ3N6cjJoIn0.6vNnhR9JnlHP6Hcq0X3MVQ",
                                        additionalOptions: {
                                          'accessToken':
                                              'pk.eyJ1Ijoic2hpamluOTA3MjEyNzc1OSIsImEiOiJja3Ric2x3NjAxejVxMm9uOTdkZ3N6cjJoIn0.6vNnhR9JnlHP6Hcq0X3MVQ',
                                          'id': 'mapbox.country-boundaries-v1'
                                        }),
                                    MarkerLayerOptions(
                                      markers: [
                                        Marker(
                                          width: 80.0,
                                          height: 80.0,
                                          point: LatLng.LatLng(
                                              pos!.latitude, pos!.longitude),
                                          builder: (ctx) => Container(
                                            child: GestureDetector(
                                              onTap: () {
                                                _onTap(key);
                                              },
                                              child: Tooltip(
                                                key: key,
                                                message: "You are located here",
                                                child: Icon(
                                                  Icons.location_on,
                                                  color: Colors.green,
                                                  size: 50,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              child:
                                  Center(child: CircularProgressIndicator())),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            User userData = User(
                                email: "",
                                isLogined: false,
                                mobileNo: "",
                                name: "",
                                shopID: "",
                                token: "");
                            setPrefrenceUser(TOKENKEY, userData);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => MyHomePage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Container(
                            width: 14.h,
                            height: 50,
                            child: Card(
                              color: purple,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Logout",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 9.sp, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ),
        ),
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }

  Expanded updateButton(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: 14.h,
          height: 50,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.white,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditShopImage(
                                        image: pojo!,
                                      )));
                        },
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.image),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  "Edit Shop Image",
                                  style: TextStyle(fontSize: 9.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ListTile(
                      //   title: Padding(
                      //     padding:
                      //         const EdgeInsets.all(8.0),
                      //     child: Row(
                      //       children: [
                      //         Icon(Icons.edit),
                      //         SizedBox(
                      //           width: 10,
                      //         ),
                      //         Expanded(
                      //           child: Text(
                      //             "Edit Other Details",
                      //             style: TextStyle(
                      //                 fontSize: 9.sp),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // )
                    ],
                  );
                },
                context: context,
              );
            },
            child: Card(
              color: purple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Edit Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 9.sp, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row cardLayout(Icon icon, String text) {
    return Row(
      children: [
        icon,
        SizedBox(
          width: 10,
        ),
        Expanded(child: Text(text))
      ],
    );
  }
}
