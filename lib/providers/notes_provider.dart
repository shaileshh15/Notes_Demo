import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  Box<Note>? _notesBox;

  List<Note> get notes => _notesBox?.values.toList() ?? [];

  Future<void> init() async {
    _notesBox = await Hive.openBox<Note>('notes');
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await _notesBox?.add(note);
    notifyListeners();
  }

  Future<void> updateNote(int index, Note note) async {
    await _notesBox?.putAt(index, note);
    notifyListeners();
  }

  Future<void> deleteNote(int index) async {
    await _notesBox?.deleteAt(index);
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _notesBox?.clear();
    notifyListeners();
  }
}




















































