
import 'package:QuickNotes/Foundation/Models/Note.dart';

abstract class INotesProvider {
  Future<List<Note>> getNotes();

  Future saveNotes(List<Note> notes);
    Future<List<Note>> getSearchResults(
      String searchTerm, List<String> booksToSearch);

  Future init();
}
