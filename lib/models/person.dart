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
