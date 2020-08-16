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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_helper/controllers/settings_controller.dart';
import 'package:whatsapp_helper/models/country.dart';

class CountriesScreen extends StatefulWidget {
  @override
  _CountriesScreenState createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  List<Country> _countries;

  parseJson() async {
    String countryJson = await rootBundle.loadString('assets/Country.json');

    _countries = (json.decode(countryJson) as List)
        .map((i) => Country.fromJson(i))
        .toList();
    setState(() {});
  }

  @override
  void initState() {
    parseJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _countries != null
          ? ListView.builder(
              itemBuilder: (context, index) {
                // print(_countries[index].alpha2Code.toLowerCase());
                return ListTile(
                    leading: Image.asset(
                      'assets/flags/${_countries[index].alpha2Code.toLowerCase()}.png',
                      width: 24,
                    ),
                    title: Text(_countries[index].name),
                    trailing: Text(_countries[index].callingCodes.first != ''
                        ? '+' + _countries[index].callingCodes.first
                        : ''),
                    onTap: () {
                      Provider.of<SettingsController>(context, listen: false)
                          .setSettings(_countries[index]);
                      Navigator.pop(context);
                    });
              },
              itemCount: _countries.length,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
