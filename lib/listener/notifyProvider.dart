import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/pojo/creditPojo.dart';
import 'package:ecom_app/viewModel/shopPaymentRepo.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier {
  String notificationToken = '';
  List<String> orderIds = [];
  bool isDigiStore = false;
  bool digiPayment = false;
  ShopPaymentRepo repo = ShopPaymentRepo();
  CreditPojo? creditPojo;

  setCreditDetails(CreditPojo pojo) {
    this.creditPojo = pojo;
    notifyListeners();
  }

  resetCredit() {
    this.creditPojo = null;
    notifyListeners();
  }

  setIsDigistore(bool isDigi, bool digiPay) {
    this.isDigiStore = isDigi;
    this.digiPayment = digiPay;
    notifyListeners();
  }

  void addOrderIds(String id) {
    orderIds.add(id);
  }

  getLoanStatus(BuildContext context) {
    resetCredit();
    getLoading(context);
    repo.getLoanStatus(context);
  }

  get orders => orderIds;

  void resetOrders() {
    orderIds.clear();
  }

  void setNotification(String token) {
    notificationToken = token;
  }

  get token => notificationToken;

  checkStatus(BuildContext context) {
    ShopPaymentRepo repo = ShopPaymentRepo();
    repo.statusCheck(context);
  }
}
