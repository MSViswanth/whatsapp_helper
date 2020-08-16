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

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

class CountriesList {
  List<Country> countries;
  CountriesList({this.countries});
  factory CountriesList.fromJson(List<dynamic> json) {
    List<Country> countries = List<Country>();
    countries = json.map((i) => Country.fromJson(i)).toList();
    return CountriesList(
      countries: countries,
    );
  }
}

@JsonSerializable()
@HiveType(typeId: 1)
class Country {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<String> callingCodes;
  @HiveField(2)
  String alpha3Code;
  @HiveField(3)
  String alpha2Code;
  Country(
    this.name,
    this.callingCodes,
    this.alpha3Code,
    this.alpha2Code,
  );
  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);
  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
