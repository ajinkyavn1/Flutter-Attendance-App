
import 'package:flutter/widgets.dart';
import 'package:untitled1/services/database.dart';

class UserModel with ChangeNotifier {
  String uid;

  String email;
  String status;


  UserModel({this.uid, this.email, this.status});

  updateUser({UserModel user}) {

    this.email = user.email;
    this.status = user.status;

    this.uid = user.uid;
    notifyListeners();
  }
}
