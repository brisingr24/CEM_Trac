// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../models/userModel.dart';
import 'edit_profile.dart';
import '../services/userService.dart';

class Profile extends StatefulWidget {
  final String uid;
  Profile({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    late final Stream<UserModel?> userModelStream;
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(height: 70),
            // IconButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            //   icon: Icon(Icons.arrow_left),
            // ),
            Text(
              "My Profile",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: StreamBuilder<UserModel?>(
                stream: UserService().getUserInfo(widget.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      UserModel user = snapshot.data!;
                      return Column(
                        children: [
                          user.profileImgURL == null
                              ? CircleAvatar(
                                  child: Image.asset(
                                    "assets/images/userdef.png",
                                  ),
                                  radius: 60,
                                  backgroundColor: Colors.white,
                                )
                              : CircleAvatar(
                                  radius: 80,
                                  backgroundImage: NetworkImage(
                                    user.profileImgURL ?? ' ',
                                  ),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 16, 8, 0),
                            child: Text(
                              '${user.name}',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                            child: Text(
                              '${user.email}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              user.age != null
                                  ? Text(
                                      '${user.age} years |',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  : SizedBox(
                                      width: 1,
                                    ),
                              user.gender != null
                                  ? Text(
                                      '${user.gender}',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  : SizedBox(
                                      width: 1,
                                    ),
                            ],
                          ),
                          user.city != null
                              ? Text(
                                  '${user.city}',
                                  style: TextStyle(fontSize: 18),
                                )
                              : SizedBox(
                                  height: 1,
                                ),
                        ],
                      );
                    }
                  }
                  return loadingView();
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                width: 330,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 55,
                    ),
                    Text(
                      "Edit Details",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfile(),
                          ),
                        );
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget loadingView() => Center(
      child: CircularProgressIndicator(),
    );
