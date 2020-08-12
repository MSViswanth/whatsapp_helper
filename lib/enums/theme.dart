import 'package:hive/hive.dart';

part 'theme.g.dart';

@HiveType(typeId: 0)
enum AppTheme {
  @HiveField(0)
  Light,
  @HiveField(1)
  Dark,
}
