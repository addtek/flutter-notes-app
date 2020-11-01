import 'package:zefyr/zefyr.dart';

class Note {
  String title;
  DateTime lastUpdated;
  final int id;
  NotusDocument doc;
  Note({this.id, this.title, this.doc, this.lastUpdated});
}
