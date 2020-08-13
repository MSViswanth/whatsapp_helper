import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:hive/hive.dart';
import 'package:version/version.dart';
import 'package:whatsapp_helper/models/country.dart';
import 'package:http/http.dart' as http;

String baseUrl =
    "https://api.github.com/repos/Viswanth1038/whatsapp_helper/releases";

class SettingsController with ChangeNotifier {
  Country _country = Country('India', ['91'], 'IND', 'IN');
  Box settings;
  String _latest;
  String _projectVersion;
  Version _currentVersion;
  Version _latestVersion;
  Map _releaseMap;
  bool _updateAvailable = false;
  bool _checking = true;
  SettingsController(this.settings) {
    getSettings();
    getVersion();
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
  get projectVersion => _projectVersion;
  get updateAvailable => _updateAvailable;
  get latestVersion => _latest;
  get checking => _checking;
  get releaseMap => _releaseMap;

  getVersion() async {
    try {
      _projectVersion = await GetVersion.projectVersion;
      _currentVersion = Version.parse(_projectVersion);
    } on PlatformException {
      _projectVersion = 'Failed to get build number.';
    }
    notifyListeners();
  }

  parseUpdate() async {
    http.Response response;
    try {
      response = await http.get(baseUrl);
      List update = jsonDecode(response.body);
      _releaseMap = update.first;
      _latest = _releaseMap['tag_name'];
    } catch (e) {
      _checking = false;
      print(e);
    }

    _latestVersion = Version.parse(_latest.substring(1));
    if (_currentVersion < _latestVersion) {
      _updateAvailable = true;
      _checking = false;
    } else {
      _updateAvailable = false;
      _checking = false;
    }

    notifyListeners();
  }
}
