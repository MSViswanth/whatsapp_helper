import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 2)
class Person {
  @HiveField(0)
  String phoneNumber;
  @HiveField(1)
  DateTime time;
  Person(
    this.phoneNumber,
    this.time,
  );
}
