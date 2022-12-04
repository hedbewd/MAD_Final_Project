import 'package:flutter/material.dart';
import '/src/app.dart';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import '/model/alarm.dart';
import '/provider/alarm_list_provider.dart';
import '/provider/permission_provider.dart';
import '/service/alarm_file_handler.dart';
import '/service/alarm_polling_worker.dart';
import '/provider/alarm_state.dart';
import '/view/alarm_observer.dart';
import '/view/home_screen.dart';
import '/view/permission_request_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();

  final AlarmState alarmState = AlarmState();
  final List<Alarm> alarms = await AlarmFileHandler().read() ?? [];
  final SharedPreferences preference = await SharedPreferences.getInstance();

  AlarmPollingWorker().createPollingWorker(alarmState);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => alarmState),
      ChangeNotifierProvider(create: (context) => AlarmListProvider(alarms)),
      /*ChangeNotifierProvider(
        create: (context) => PermissionProvider(preference),
      ),*/
    ],
    child: const MyApp(),
  ));
}

  class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Flutter Android Alarm Demo',
        theme: ThemeData(useMaterial3: true),
        home: App()/*const PermissionRequestScreen(
          child: AlarmObserver(child: HomeScreen()),
        ),*/
      );
    }
}