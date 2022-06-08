import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/listener.dart';
import 'package:ecom_app/listener/notifyProvider.dart';
import 'package:ecom_app/main.dart';
import 'package:ecom_app/pojo/User.dart';
import 'package:ecom_app/pojo/profilepojo.dart';
import 'package:ecom_app/screens/addBanner.dart';
import 'package:ecom_app/screens/loan/loanDetails.dart';
import 'package:ecom_app/screens/shopPayment/shopPayment.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ecom_app/screens/earnings.dart';
import 'package:ecom_app/screens/listBanks.dart';
import 'package:ecom_app/screens/listOrders.dart';
import 'package:ecom_app/screens/mycustomers.dart';
import 'package:ecom_app/screens/products.dart';
import 'package:ecom_app/screens/profile.dart';
import 'package:ecom_app/screens/viewShopBanners.dart';
import 'package:ecom_app/viewModel/loginVm.dart';
import 'package:ecom_app/viewModel/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final CarouselController controller = CarouselController();
  int indeximg = 0;
  User? user;
  final ImagePicker _picker = ImagePicker();
  bool shopStatus = false;
  XFile? file;
  ProfilePojo? pojo;
  RefreshController refrreshController = RefreshController();

  void addImages() async {
    PermissionStatus storageAccess = await Permission.storage.status;
    if (storageAccess.isGranted) {
      file = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);

      setState(() {});
      updateShopImage();
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
  }

  void addImageFromCamera() async {
    PermissionStatus cameraAccess = await Permission.camera.status;
    if (cameraAccess.isGranted) {
      PickedFile? img = await ImagePicker.platform
          .pickImage(source: ImageSource.camera, imageQuality: 50);

      file = XFile(img!.path);
      updateShopImage();
      setState(() {});
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
      ].request();
    }
  }

  void chooseType(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            color: Colors.white,
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Pick Image by using two options"),
                  SizedBox(
                    height: 20,
                  ),
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            addImageFromCamera();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera,
                                size: 50,
                              ),
                              Text("CAMERA")
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("OR")],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            addImages();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 50,
                              ),
                              Text("GALLERY")
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void getProfile() async {
    LoginVM loginVM = LoginVM();
    pojo = await loginVM.getProfileDetails(context);
    Provider.of<ShopProvider>(context, listen: false)
        .setPanchaythId(pojo!.panchayath.toString());

    setState(() {});
  }

  static const channel = MethodChannel("");

  @override
  void initState() {
    super.initState();
    new Future.delayed(new Duration(seconds: 0), () async {
      //await channel.invokeMethod("gpay");
      getLoading(context);
      getUserData();
      getProfile();
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

      OneSignal.shared.setAppId(ONESIGNAL_KEY);

      // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
      OneSignal.shared
          .promptUserForPushNotificationPermission()
          .then((accepted) {
        print("Accepted permission: $accepted");
        initOneSignal(context);
      });
    });
  }

  void sendToken(String token) {
    LoginVM loginVM = LoginVM();
    loginVM.saveToken(context, token);
  }

  Future<void> initOneSignal(BuildContext context) async {
    /// Set App Id.
    //await OneSignal.shared.setAppId(SahityaOneSignalCollection.appID);

    /// Get the Onesignal userId and update that into the firebase.
    /// So, that it can be used to send Notifications to users later.̥
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    log('message' + osUserID.toString());
    Provider.of<NotificationProvider>(context, listen: false)
        .setNotification(osUserID.toString());
    sendToken(osUserID.toString());
    // We will update this once he logged in and goes to dashboard.
    ////updateUserProfile(osUserID);
    // Store it into shared prefs, So that later we can use it.
    // Preferences.setOnesignalUserId(osUserID);

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared.promptUserForPushNotificationPermission(
      fallbackToSettings: true,
    );

    /// Calls when foreground notification arrives.
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      indeximg = index;
    });
  }

  void getUserData() async {
    user = await getPrefrenceUser(TOKENKEY);
    setState(() {});
  }

  void updateShopImage() async {
    getLoading(context);
    ProductsVM productsVM = ProductsVM();
    productsVM.editShopLogo(context, file);
  }

  Drawer sideDrawer() {
    return Drawer(
      child: Neumorphic(
        child: Container(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    "assets/images/onfully.png",
                    height: 100,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Row(
                        children: [
                          Icon(Icons.home_outlined),
                          Text(
                            "  HOME",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Products()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Row(
                          children: [
                            Icon(Icons.pages),
                            Text(
                              "  PRODUCTS",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Earnings()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Row(
                          children: [
                            Icon(Icons.wallet_giftcard),
                            Text(
                              "  EARNINGS",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListOrders()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Row(
                          children: [
                            Icon(Icons.chat_bubble_outline),
                            Text(
                              "  ORDERS",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShopPayment()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Row(
                          children: [
                            Icon(Icons.payment),
                            Text(
                              "  MAKE SHOP ACTIVE",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyCustomers()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Row(
                          children: [
                            Icon(Icons.people_outline),
                            Text(
                              "  MY CUSTOMERS",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewShopBanners()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Row(
                          children: [
                            Icon(Icons.settings),
                            Text(
                              "  BANNERS",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.of(context).push(
                        //     MaterialPageRoute(builder: (context) => ContactUs()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline),
                            Text(
                              "  HELP",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        // exit(0);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Row(
                          children: [
                            Icon(Icons.text_format),
                            Text(
                              "  TERMS ",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "VERSION 1.0.0 (1)",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
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
                        decoration: BoxDecoration(
                            color: purple,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x10000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 6)
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 12, bottom: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "  LOGOUT  ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.call,
                            color: purple,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "CONTACT US AT : 7012738756",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.business,
                            color: purple,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "VISIT : www.onfullymarketing.com",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void refresh() {
    new Future.delayed(new Duration(seconds: 0), () {
      getLoading(context);
      getUserData();
      getProfile();
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

      OneSignal.shared.setAppId(ONESIGNAL_KEY);

      // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
      OneSignal.shared
          .promptUserForPushNotificationPermission()
          .then((accepted) {
        print("Accepted permission: $accepted");
      });
      // listOrders();
    });
    refrreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      width: deviceWidth,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: Neumorphic(
              child: AppBar(
                actions: [
                  notification(),
                ],
                backgroundColor: background,
                elevation: 0,
                title: Image.network(
                  logoUrl,
                  fit: BoxFit.cover,
                  height: 100,
                ),
                centerTitle: true,
                leading: Builder(
                  builder: (context) => // Ensure Scaffold is in context
                      menu(context),
                ),
              ),
            ),
          ),
          //backgroundColor: background,
          drawer: sideDrawer(),
          body: Neumorphic(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SmartRefresher(
                  onRefresh: refresh,
                  controller: refrreshController,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        user != null
                            ? Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "WELCOME  TO ONFULLY",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 20,
                        ),
                        pojo != null
                            ? pojo!.imageDetails.isNotEmpty
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.19),
                                        image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0.8),
                                                BlendMode.dstATop),
                                            image: NetworkImage(IMAGEURL +
                                                pojo!.imageDetails
                                                    .last["shop_image"]),
                                            fit: BoxFit.cover)),
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            chooseType(context);
                                          },
                                          child: file == null
                                              ? Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: CircleAvatar(
                                                      radius: 35,
                                                      backgroundColor:
                                                          Colors.white,
                                                      backgroundImage:
                                                          NetworkImage(IMAGEURL +
                                                              pojo!.shopLogo),
                                                    ),
                                                  ),
                                                )
                                              : Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: CircleAvatar(
                                                      radius: 35,
                                                      backgroundColor:
                                                          Colors.white,
                                                      backgroundImage:
                                                          FileImage(
                                                              File(file!.path)),
                                                    ),
                                                  ),
                                                ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container()
                            : Container(),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            navigate(LoanDetails(), context);
                          },
                          child: Container(
                              height: 45,
                              width: getWidth(context),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: purple),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Row(
                                  children: [
                                    Text(
                                      "LOAN REPAYMENT",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    CircleAvatar(
                                      backgroundColor: purple,
                                      child: Icon(Icons.chevron_right),
                                    )
                                  ],
                                )),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "INSIDE ONFULLY ",
                                style: TextStyle(
                                    color: black, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(),
                            pojo != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      NeumorphicSwitch(
                                        height: 30,
                                        value: pojo!.isOnline,
                                        style: NeumorphicSwitchStyle(
                                            activeThumbColor: purple,
                                            inactiveThumbColor: Colors.red,
                                            inactiveTrackColor: Colors.red,
                                            activeTrackColor: purple),
                                        onChanged: (flag) {
                                          pojo!.isOnline = !pojo!.isOnline;
                                          LoginVM loginVM = LoginVM();
                                          loginVM.changeStatus(context, flag);
                                          setState(() {});
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        pojo!.isOnline ? 'OPEN' : "CLOSED",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: purple),
                                      )
                                    ],
                                  )
                                : Container()
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Products()),
                                );
                              },
                              child: tiles(
                                context,
                                "PRODUTCS",
                                Icon(
                                  Icons.production_quantity_limits,
                                  size: 50,
                                  color: purple,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Profile()));
                              },
                              child: tiles(
                                context,
                                "SHOP DETAILS",
                                Icon(
                                  Icons.business,
                                  size: 50,
                                  color: purple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ListOrders()));
                              },
                              child: tiles(
                                context,
                                "ORDERS",
                                Icon(
                                  Icons.library_books_outlined,
                                  size: 50,
                                  color: purple,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ListBanks()));
                              },
                              child: tiles(
                                context,
                                "BANK DETAILS",
                                Icon(
                                  Icons.credit_card,
                                  size: 50,
                                  color: purple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 3,
                                isDismissible: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                context: context,
                                builder: (context) {
                                  return Neumorphic(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Image.asset(
                                            "assets/images/onfully.png",
                                            height: 40,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          QrImage(
                                            data: pojo!.id.toString(),
                                            version: QrVersions.auto,
                                            size: 180.0,
                                          ),
                                          Text(
                                            "Shop Name : " +
                                                pojo!.shop_name.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Shop Address : " +
                                                pojo!.address.toString() +
                                                " " +
                                                pojo!.pincode.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Your Referal Code",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            pojo!.referal.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: purple,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Neumorphic(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(Icons.check),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Image.asset(
                                              "assets/images/playstore.png"),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Neumorphic(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.qr_code),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'OFFER BANNERS',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddBanner()));
                                },
                                child: Neumorphic(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Add More",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: purple),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        pojo != null ? slider() : Container(),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  CarouselSlider slider() {
    return CarouselSlider(
      carouselController: controller,
      options: CarouselOptions(
          height: 200,
          onPageChanged: onPageChanged,
          viewportFraction: 0.9,
          initialPage: 0,
          enableInfiniteScroll: true,
          autoPlay: true,
          disableCenter: true,
          scrollDirection: Axis.horizontal),
      items: pojo!.shopBanners
          .map((e) => Stack(
                children: [
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: IMAGEURL + e.banner,
                        fit: BoxFit.cover,
                        width: 1000,
                        height: 160,
                      ),
                    )),
                  )),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () async {
                        getLoading(context);
                        ProductsVM productsVM = ProductsVM();
                        productsVM.removeBanner(context, e.id.toString());
                        getProfile();
                        //Navigator.pop(context);
                      },
                      child: Neumorphic(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete_forever_outlined,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ))
          .toList(),
    );
  }

  Neumorphic tiles(BuildContext context, String title, Icon icon) {
    return Neumorphic(
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width / 3,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(title),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding menu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4, top: 4, bottom: 4),
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
        ),
        child: IconButton(
            icon: Icon(
              Icons.menu,
              color: black,
            ),
            onPressed: () => Scaffold.of(context).openDrawer()),
      ),
    );
  }

  Padding notification() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4, top: 4, bottom: 4),
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
        ),
        child: IconButton(
            icon: Icon(
              Icons.notifications,
              color: black,
            ),
            onPressed: () => print("object")),
      ),
    );
  }

  Padding iconSet(Icon icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4, top: 4, bottom: 4),
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
        ),
        child: IconButton(icon: icon, onPressed: () => print("object")),
      ),
    );
  }
}
