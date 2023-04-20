import 'package:ecms/models/equipment_data.dart';
import 'package:ecms/screens/component_list.dart';
import 'package:ecms/screens/logIn.dart';
import 'package:ecms/screens/profile.dart';
import 'package:ecms/services/firebase_auth.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthMethods _auth = FirebaseAuthMethods();

    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Image.asset("assets/logo.png"),
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text('Profile'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                  ),
                ),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Feedback'),
            onTap: () => {
              Navigator.of(context).pop(),
              BetterFeedback.of(context)
                  .show((UserFeedback p0) => print(p0.extra))
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () async {
              _auth.signOut(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LogIn(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class VehiclePage extends StatefulWidget {
  const VehiclePage({Key? key}) : super(key: key);

  @override
  _VehiclePageState createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  @override
  Widget build(BuildContext context) {
    return BetterFeedback(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "ECMS",
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Machineries'),
            // actions: const [
            //   IconButton(
            //     icon: Icon(Icons.search),
            //     tooltip: 'Search',
            //     onPressed: null,
            //   ),
            // ],
          ),
          drawer: const SideDrawer(),
          body: const VehicleList(),
        ),
      ),
    );
  }
}

class VehicleList extends StatelessWidget {
  const VehicleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<VehicleData> vehicleListData = VehicleListData().vehicleData;
    return ListView.builder(
      itemCount: vehicleListData.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComponentList(
                      name: vehicleListData[index].name,
                      id: vehicleListData[index].id,
                      vehicleData: vehicleListData[index],
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // add this
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: Image.asset(vehicleListData[index].imagePath,
                        width: 120, height: 120, fit: BoxFit.fitHeight),
                  ),
                  ListTile(
                    title: Text(
                      vehicleListData[index].name,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
