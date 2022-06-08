import 'package:flutter/cupertino.dart';

class ShopProvider with ChangeNotifier {
  String panchayathId = "";

  void setPanchaythId(String id) {
    panchayathId = id;
  }

  get panchayath => panchayathId;
}
