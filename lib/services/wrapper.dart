import 'package:ecms/services/userService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/userModel.dart';
import '../screens/logIn.dart';
import '../screens/vehicles.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser;
    if (auth?.uid != null) {
      UserService().getHours();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => VehiclePage(),
            ),
          );
        },
      );
    }
    return LogIn();
  }
}
