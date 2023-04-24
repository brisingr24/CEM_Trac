// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddProject extends StatefulWidget {
  const AddProject({Key? key}) : super(key: key);

  @override
  _AddProjectState createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  late TextEditingController proj_name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Project"),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: proj_name,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter Name of your Project",
              labelText: "Abc",
              prefixIcon: Icon(Icons.description),
            ),
          ),
          DropdownSearch<String>.multiSelection(
            items: ["Backhoe Loader", "Tandem Roller", "Excavator", "Vibratory Compact Roller","Hydra Crane","Grader","Dump Truck"],
            popupProps: PopupPropsMultiSelection.menu(
              showSelectedItems: true,
            ),
            onChanged: print,
            selectedItems: ["Excavator"],
          )
        ],
      ),
    );
  }
}
