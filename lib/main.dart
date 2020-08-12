import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_helper/controllers/history_controller.dart';
import 'package:whatsapp_helper/controllers/settings_controller.dart';
import 'package:whatsapp_helper/controllers/theme_controller.dart';
import 'package:whatsapp_helper/enums/theme.dart';
import 'package:whatsapp_helper/models/country.dart';
import 'package:whatsapp_helper/models/person.dart';
import 'package:whatsapp_helper/views/home_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AppThemeAdapter());
  Hive.registerAdapter(CountryAdapter());
  Hive.registerAdapter(PersonAdapter());
  final Box settings = await Hive.openBox('settings');
  final Box history = await Hive.openBox('history');

  runApp(MyApp(
    settings: settings,
    history: history,
  ));
}

class MyApp extends StatelessWidget {
  final Box settings;
  final Box history;
  MyApp({this.settings, this.history});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeController(settings),
        ),
        ChangeNotifierProvider(
          create: (context) => HistoryController(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsController(settings),
        )
      ],
      child: Consumer3<ThemeController, HistoryController, SettingsController>(
        builder: (context, themeController, historyController,
                settingsController, child) =>
            MaterialApp(
          title: 'WhatsApp Helper',
          home: HomePage(),
          theme: themeController.theme,
        ),
      ),
    );
  }
}
