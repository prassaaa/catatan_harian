import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/note_model.dart';

class NoteService {
  static const String boxName = 'notes';
  final uuid = Uuid();

  // Mendapatkan semua catatan
  List<Note> getNotes() {
    final box = Hive.box<Note>(boxName);
    return box.values.toList();
  }

  // Menambahkan catatan baru
  Future<void> addNote(String title, String content) async {
    final box = Hive.box<Note>(boxName);
    final note = Note(
      id: uuid.v4(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );
    await box.add(note);
  }

  // Menghapus catatan
  Future<void> deleteNote(int index) async {
    final box = Hive.box<Note>(boxName);
    await box.deleteAt(index);
  }

  // Mengubah catatan
  Future<void> updateNote(int index, String title, String content) async {
    final box = Hive.box<Note>(boxName);
    Note note = box.getAt(index)!;
    note.title = title;
    note.content = content;
    await box.putAt(index, note);
  }

  // Ekspor ke JSON
  String exportToJson() {
    final notes = getNotes();
    final jsonList = notes.map((note) => note.toJson()).toList();
    return jsonEncode(jsonList);
  }
}