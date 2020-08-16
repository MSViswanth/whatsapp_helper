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
import 'package:whatsapp_helper/enums/theme.dart';

class ThemeController with ChangeNotifier {
  Box settings;
  bool _isDark = false;
  ThemeController(this.settings) {
    getTheme();
  }
  ThemeData _themeData;

  getTheme() {
    if (settings.get('theme') != null) {
      setTheme(settings.get('theme'));
    } else {
      setTheme(AppTheme.Light);
    }
  }

  setTheme(AppTheme theme) {
    settings.put('theme', theme);
    _themeData = appThemeData[theme];
    if (theme == AppTheme.Dark) {
      _isDark = true;
    } else {
      _isDark = false;
    }

    notifyListeners();
  }

  final appThemeData = {
    AppTheme.Dark: ThemeData(
      brightness: Brightness.dark,
      accentColor: Colors.greenAccent[700],
    ),
    AppTheme.Light: ThemeData(
      brightness: Brightness.light,
      accentColor: Colors.greenAccent[700],
      primaryColor: Colors.green,
    ),
  };

  get isDark => _isDark;
  get theme => _themeData;
}
