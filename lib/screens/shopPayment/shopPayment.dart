import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/listener/notifyProvider.dart';
import 'package:ecom_app/pojo/User.dart';
import 'package:ecom_app/viewModel/shopPaymentRepo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ShopPayment extends StatefulWidget {
  const ShopPayment({Key? key}) : super(key: key);

  @override
  _ShopPaymentState createState() => _ShopPaymentState();
}

class _ShopPaymentState extends State<ShopPayment> {
  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<NotificationProvider>(context, listen: false)
          .checkStatus(context);
    });
  }

  late Razorpay _razorpay;

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    getLoading(context);
    ShopPaymentRepo repo = ShopPaymentRepo();
    repo.savePaymentDetails(context, response.paymentId!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void openCheckout() async {
    User user = await getPrefrenceUser(TOKENKEY);
    var options = {
      'key': 'rzp_test_xzu24fShjh7pO1',
      'amount': "10000",
      'name': 'Onfully Marketing Payments',
      'description': 'Onfully Payment Charges',
      'prefill': {'contact': user.mobileNo, 'email': user.email},
      'external': {
        'wallets': [
          'paytm',
        ]
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarContent("Shop Verification"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: Consumer<NotificationProvider>(
                  builder: (context, provider, child) {
                    return provider.isDigiStore == true &&
                            provider.digiPayment == false
                        ? Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 10,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 100,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "You need to make a payment of\nRs. 100 for making your shop ONLINE",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          height: 2,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      openCheckout();
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: Colors.green,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          alignment: WrapAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "MAKE PAYMENT",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 10,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 100,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Your Shop has been Verified",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          height: 2,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
