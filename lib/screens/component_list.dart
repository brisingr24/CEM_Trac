import 'package:ecms/models/equipment_data.dart';
import 'package:ecms/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/components.dart';

class ComponentList extends StatefulWidget {
  final String name;
  final String id;
  final VehicleData vehicleData;
  const ComponentList(
      {Key? key,
      required this.name,
      required this.id,
      required this.vehicleData})
      : super(key: key);

  @override
  _ComponentListState createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  final _myBox = Hive.box("hoursBox");
  double hour = 0;
  double usedHour = 0;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    updateHours();
    super.initState();
  }

  void updateHours() {
    var data = _myBox.get(widget.id);
    if (data != null) {
      hour = data;
      usedHour = data;
    }
  }

  void submit(buildContext) {
    Navigator.of(buildContext).pop(double.parse(controller.text));
    controller.clear();
  }

  void cancel(buildContext) {
    Navigator.of(buildContext).pop();
    controller.clear();
  }

  Future<double?> openDialog() => showDialog<double>(
        context: context,
        builder: (buildContext) => AlertDialog(
          title: const Text('Add Hours'),
          content: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter value in Hours',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
            onChanged: (text) {
              hour = double.parse(text);
            },
            controller: controller,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => cancel(buildContext),
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () => submit(buildContext),
                  child: const Text('SUBMIT'),
                ),
              ],
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    List<ComponentData> componentDataList = widget.vehicleData.componentData;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.name} - Components'),
        actions: const [
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: 600,
            child: ListView.builder(
              itemCount: componentDataList.length,
              itemBuilder: (buildContext, index) {
                return Component(
                  componentName: componentDataList[index].componentName,
                  imagePath: componentDataList[index].imagePath,
                  totalHour: componentDataList[index].totalHour,
                  hour: hour,
                  usedHour: usedHour,
                  changeType: componentDataList[index].changeType,
                );
              },
              padding: const EdgeInsets.all(8),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: ElevatedButton(
                  child: const Text('Update Hours'),
                  onPressed: () async {
                    final hour = await openDialog();
                    if (hour == 0 || hour == null) {
                      return;
                    }
                    setState(() {
                      this.hour = hour;
                      this.usedHour = usedHour + hour;
                      UserService().updateHours(widget.id, usedHour);
                      _myBox.put(widget.id, this.usedHour);
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
