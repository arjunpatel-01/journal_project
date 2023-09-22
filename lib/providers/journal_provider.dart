import 'package:flutter/material.dart';
import 'package:journal_project/models/journal.dart';
import 'package:journal_project/services/sql_helper.dart';

class JournalProvider extends ChangeNotifier {
  bool isLoading = true;

  List<Journal> _journals = [];
  List<Journal> get journals => _journals;

  Future<void> getAllJournals() async {
    final response = await SQLHelper.getEntries();
    _journals = response;
    isLoading = false;
    notifyListeners();
  }
}
