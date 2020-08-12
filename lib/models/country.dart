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
