import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecms/models/equipment_data.dart';
import 'package:ecms/screens/vehicles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:hive_flutter/hive_flutter.dart';

import '../models/userModel.dart';

class UtilsService {
  Future<String> uploadFile(File image, String path) async {
    firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance.ref(path);
    firebase_storage.UploadTask uploadTask = storageReference.putFile(image);

    await uploadTask.whenComplete(() => null);
    String returnURL = "";
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }
}

class UserService {
  UtilsService _utilsService = UtilsService();

  UserModel? _userFromFirebaseSnapshot(DocumentSnapshot<dynamic> snapshot) {
    return snapshot != null
        ? UserModel(
            id: snapshot.id,
            profileImgURL: snapshot.data()['profileImgURL'],
            name: snapshot.data()['name'],
            email: snapshot.data()['email'],
            city: snapshot.data()['city'],
            age: snapshot.data()['age'],
            gender: snapshot.data()['gender'],
          )
        : UserModel(name: "User");
  }

  Stream<UserModel?> getUserInfo(uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map(_userFromFirebaseSnapshot);
  }

  Future<void> updateProfile(
      String name, String city, String age, String gender) async {
    Map<String, Object> data = HashMap();
    if (name != '') data['name'] = name;
    if (city != '') data['city'] = city;
    if (age != '') data['age'] = age;
    if (gender != '') data['gender'] = gender;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(data);
  }

  Future<void> updateHours(String id, double hours) async {
    Map<String, Object> data = HashMap();
    data[id] = hours;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(data);
  }

  Future<void> getHours() async {
    List<VehicleData> vehicleData = VehicleListData().vehicleData;
    List<String> vehicleID = [];
    for (VehicleData i in vehicleData) {
      vehicleID.add(
        i.id,
      );
    }
    final _myBox = Hive.box("hoursBox");
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    for (var i in data.data()!.keys) {
      if (vehicleID.contains(i)) {
        _myBox.put(i, data.data()![i]);
      }
    }
  }

  Future<void> updatePic(File _profileImg) async {
    String profileImgURL = "";

    if (_profileImg != null) {
      //save image to storage
      profileImgURL = await _utilsService.uploadFile(_profileImg,
          'user/profile/${FirebaseAuth.instance.currentUser?.uid}/profile');
    }

    Map<String, Object> data = HashMap();
    if (profileImgURL != '') data['profileImgURL'] = profileImgURL;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(data);
  }
}
