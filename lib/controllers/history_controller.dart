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
import 'package:whatsapp_helper/models/person.dart';

class HistoryController with ChangeNotifier {
  var history = Hive.box('history');
  List<Person> _people = <Person>[];
  HistoryController() {
    getHistory();
  }
  getHistory() {
    if (history.get('history') != null) {
      List historys = history.get('history');
      setHistory(historys.cast<Person>());
    } else {
      setHistory(_people);
    }
  }

  setHistory(List<Person> people) {
    history.put('history', people);
    _people = people;
    notifyListeners();
  }

  addPerson(Person person) {
    _people.insert(0, person);
    history.put('history', _people);
    notifyListeners();
  }

  removePerson(Person person) {
    _people.remove(person);
    history.put('history', _people);
    notifyListeners();
  }

  clearHistory() {
    _people.clear();
    history.put('history', _people);
    notifyListeners();
  }

  List<Person> get people => _people;
}
