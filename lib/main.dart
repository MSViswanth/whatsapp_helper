// Copyright (C) 2020 Viswanth
//
// This file is part of WhatsApp Helper.
//
// WhatsApp Helper is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// WhatsApp Helper is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with WhatsApp Helper.  If not, see <http://www.gnu.org/licenses/>.

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
        ),
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
