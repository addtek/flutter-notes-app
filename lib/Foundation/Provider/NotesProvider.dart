import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:QuickNotes/Foundation/Models/Note.dart';
import 'package:QuickNotes/Foundation/Provider/INotesProvider.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zefyr/zefyr.dart';

class NotesProvider extends INotesProvider {
    List<Note> _searchableNotes;
    NotesProvider(){
      init();
    }
  @override 
  Future init()async{
    _searchableNotes= await this.getNotes();
    return null;
  }
  @override
  Future<List<Note>> getNotes() async {
    List<Note> notes = List<Note>();
    final directory = await getApplicationDocumentsDirectory();
    Directory notesDir = Directory('${directory.path}/notes/');
    var exists = notesDir.existsSync();
    if (!exists) {
      notesDir.createSync(recursive: true);
    }
    for (File file in await notesDir
        .list(recursive: false)
        .where((f) => f is File)
        .toList()) {
      try {
        var contents = file.readAsStringSync();
        if (contents.isEmpty) {
          continue;
        }
        var json = jsonDecode(contents);
        var doc = NotusDocument.fromJson(json);
        var noteName = basename(file.path).split('.')[0];
        var id = noteName.split('_')[0];
        var title = noteName.split('_')[1];
        var lastUpdated = DateTime.parse(noteName.split('_')[2]);
        notes.add(
          Note(
            id: int.parse(id),
            title: title,
            doc: doc,
            lastUpdated: lastUpdated,
          ),
        );
      } catch (e) {}
    }
    return notes;
  }

  @override
  Future saveNotes(List<Note> notes) async {
    final directory = await getApplicationDocumentsDirectory();
    for (var note in notes) {
      var formatter = DateFormat('yyyy-MM-dd');
      String formatted = formatter.format(note.lastUpdated);
      var file = File(
          '${directory.path}/notes/${note.id}_${note.title}_$formatted.txt');
      var existingPath = await _getFilePathWithId(note.id);
      if (existingPath.isEmpty) {
        file = await file.create(recursive: true);
        file.writeAsString(jsonEncode(note.doc.toJson()));
      } else if (!existingPath.contains(note.title) ||
          !existingPath.contains(formatted)) {
            
        File existingFile = File(existingPath);
        existingFile.deleteSync();
      } else {
        file.writeAsString(jsonEncode(note.doc.toJson()));
      }
    }
  }
  @override
    Future<List<Note>> getSearchResults(
      String searchTerm, List<String> booksToSearch) async {
        _searchableNotes= await this.getNotes();
    var notes = booksToSearch.isNotEmpty
        ? this._searchableNotes.where((b) => booksToSearch
            .any((note) => note.toLowerCase() == b.title.toLowerCase()))
        : this._searchableNotes;
    var notesList = notes.where((note) =>
        _contains(searchTerm.toLowerCase(), note.title.toLowerCase())).toList()..addAll(notes.where((note) =>
        _contains(searchTerm.toLowerCase(), note.doc.toPlainText().toLowerCase())));
    return notesList.toList();
  }

  static bool _contains(String query, String note) {
    int i = 2; // First index to check.
    int length = note.length;
    var C = query[query.length - 1];
    var B = query[query.length - 2];
    var A = query[query.length - 3];
    while (i < length) {
      if (note[i] == C) {
        if (note[i - 1] == B && note[i - 2] == A) {
          return true;
        }
        // Must be at least 3 character away.
        i += 3;
        continue;
      } else if (note[i] == B) {
        // Must be at least 1 characters away.
        i += 1;
        continue;
      } else if (note[i] == A) {
        // Must be at least 2 characters away.
        i += 2;
        continue;
      } else {
        // Must be at least 4 characters away.
        i += 3;
        continue;
      }
    }

    // Nothing found.
    return false;
  }

  Future<String> _getFilePathWithId(int id) async {
    final directory = await getApplicationDocumentsDirectory();
    Directory notesDir = Directory('${directory.path}/notes/');
    var file = await notesDir
        .list(recursive: false)
        .where((f) => f is File)
        .firstWhere((f) => int.parse(basename(f.path).split('_')[0]) == id,
            orElse: () => File(''));
    return file.path;
  }
}
