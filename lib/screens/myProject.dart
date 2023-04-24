// ignore_for_file: prefer_const_constructors

import 'package:ecms/screens/addProj.dart';
import 'package:flutter/material.dart';

class Project extends StatefulWidget {
  final String uid;
  Project({Key? key, required this.uid}) : super(key: key);

  @override
  _ProjectState createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text("My Projects"),),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Add New Project",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 100,
            width: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddProject()));
                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(6.0),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.blue),
                        fixedSize: MaterialStateProperty.all<Size>(
                            const Size(150, 20)),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                    child: Text(
                      "Add a new Project",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
