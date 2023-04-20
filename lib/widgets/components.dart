import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';

class Component extends StatelessWidget {
  String? componentName;
  String? imagePath;
  double? hour = 0;
  double? totalHour = 0;
  double? usedHour = 0;
  String? changeType;

  Component({
    @required this.componentName,
    @required this.imagePath,
    @required this.hour,
    @required this.totalHour,
    @required this.usedHour,
    @required this.changeType,
  });

  String addComponentName() {
    var name = componentName;
    if (name != null) return name;
    return '';
  }

  String addImagePath() {
    var name = imagePath;
    if (name != null) return name;
    return '';
  }

  double addHour() {
    var j = totalHour;
    var k = usedHour;

    if (k != null) {
      return (k / j!);
    }
    return 0;
  }

  void triggerAlarm() {
    var j = totalHour;
    var k = usedHour;

    if (j == k) {
      if (kDebugMode) {
        print(k);
        print(j);
      }
      // scheduleAlarm();
    }
  }

  double displayTotalHour() {
    var i = totalHour;

    if (i != null) {
      return i;
    }
    return 0;
  }

  Icon displayIcon() {
    var j = usedHour;
    var k = totalHour;
    if (j! >= k!) {
      return const Icon(
        Icons.add_alert,
        color: Colors.blueAccent,
      );
    }
    return const Icon(Icons.add_alert_outlined);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(addComponentName()),
            LinearProgressIndicator(
              value: addHour(),
              backgroundColor: Colors.grey,
              color: Colors.purple,
              minHeight: 5,
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text("Used Hours: "),
            Text(usedHour.toString()),
          ],
        ),
        leading: CircleAvatar(backgroundImage: AssetImage(addImagePath())),
        trailing: IconButton(
          icon: displayIcon(),
          highlightColor: Colors.pink,
          onPressed: () async {
            int hours = 0;
            int minutes = 0;
            int seconds = 1;
            await showDialog<int>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title:
                        Text("How long before you would like to be reminded?"),
                    content: StatefulBuilder(builder: (context, SBsetState) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Hours"),
                              NumberPicker(
                                  itemWidth:
                                      MediaQuery.of(context).size.width * 0.2,
                                  selectedTextStyle:
                                      TextStyle(color: Colors.red),
                                  value: hours,
                                  minValue: 0,
                                  maxValue: 24,
                                  onChanged: (value) {
                                    // to change on widget level state
                                    SBsetState(() => hours =
                                        value); //* to change on dialog state
                                  }),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Minutes"),
                              NumberPicker(
                                  itemWidth:
                                      MediaQuery.of(context).size.width * 0.2,
                                  selectedTextStyle:
                                      TextStyle(color: Colors.red),
                                  value: minutes,
                                  minValue: 0,
                                  maxValue: 60,
                                  onChanged: (value) {
                                    // to change on widget level state
                                    SBsetState(() => minutes =
                                        value); //* to change on dialog state
                                  }),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Seconds"),
                              NumberPicker(
                                  itemWidth:
                                      MediaQuery.of(context).size.width * 0.2,
                                  selectedTextStyle:
                                      TextStyle(color: Colors.red),
                                  value: seconds,
                                  minValue: (minutes > 0 || hours > 0) ? 0 : 1,
                                  maxValue: 60,
                                  onChanged: (value) {
                                    // to change on widget level state
                                    SBsetState(() => seconds =
                                        value); //* to change on dialog state
                                  }),
                            ],
                          ),
                        ],
                      );
                    }),
                    actions: [
                      TextButton(
                        child: Text(
                          "OK",
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
            scheduleAlarm(hours, minutes, seconds);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "Notification set for after${(hours > 0) ? " ${hours} hours" : ""}${(minutes > 0) ? " ${minutes} minutes" : ""}${(seconds > 0) ? " ${seconds} seconds" : ""}"),
              ),
            );
          },
        ),
        onTap: () {
          showDialog<String>(
            context: context,
            builder: (buildContext) => AlertDialog(
              title: Text(addComponentName()),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                      maxRadius: 75.0,
                      backgroundImage: AssetImage(addImagePath())),
                  Text(''),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Total Interval Hours: '),
                      Text(displayTotalHour().toInt().toString()),
                    ],
                  ),
                  Text('Change Type: ' + changeType.toString()),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(buildContext, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void scheduleAlarm(int hours, int minutes, int seconds) async {
    var scheduledNotificationDateTime =
        DateTime.now().add(const Duration(seconds: 5));

    var androidPlatformChannelSpecifies = const AndroidNotificationDetails(
      'alarm_notify',
      'alarm_notify',
      channelDescription: 'channel for Alarm Notification',
      icon: 'app_icon',
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    );

    var iOSPlatformChannelSpecifies = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    print(DateTime.now().timeZoneName);
    var platformChannelSpecifies = NotificationDetails(
        android: androidPlatformChannelSpecifies,
        iOS: iOSPlatformChannelSpecifies,
        macOS: null);
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        addComponentName(),
        'Usage Limit Reached!! Used: ' +
            displayTotalHour().toInt().toString() +
            'Hours',
        tz.TZDateTime.now(tz.local).add(Duration(
          seconds: seconds,
          hours: hours,
          minutes: minutes,
        )),
        platformChannelSpecifies,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    // await flutterLocalNotificationsPlugin.show(
    //   0,
    //   addComponentName(),
    //   'Usage Limit Reached!! Used: ' +
    //       displayTotalHour().toInt().toString() +
    //       'Hours',
    //   platformChannelSpecifies,
    // );
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   0,
    //   addComponentName(),
    //   "LIMIT REACHED",
    //   tz.TZDateTime.now(tz.local).add(
    //     Duration(milliseconds: 10),
    //   ),
    //   platformChannelSpecifies,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    //   androidAllowWhileIdle: true,
    // );
  }
}
