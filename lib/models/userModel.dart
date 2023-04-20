import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier {

  String? name;
  String? email;
  String? id;
  String? profileImgURL;
  String? city;
  String? age;
  String? gender;

  UserModel({this.name, this.email, this.id,this.profileImgURL,this.city,this.gender,this.age}){
    notifyListeners();
  }
}