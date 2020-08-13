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
