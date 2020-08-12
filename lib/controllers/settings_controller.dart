import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:whatsapp_helper/models/country.dart';

class SettingsController with ChangeNotifier {
  Country _country = Country('India', ['91'], 'IND', 'IN');
  Box settings;
  SettingsController(this.settings) {
    getSettings();
  }
  getSettings() {
    if (settings.get('defaultCountry') != null) {
      setSettings(settings.get('defaultCountry'));
    } else {
      setSettings(_country);
    }
  }

  setSettings(Country country) {
    settings.put('defaultCountry', country);
    _country = country;
    notifyListeners();
  }

  Country get country => _country;
}
