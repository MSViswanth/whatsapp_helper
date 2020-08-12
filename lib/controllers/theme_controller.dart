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
