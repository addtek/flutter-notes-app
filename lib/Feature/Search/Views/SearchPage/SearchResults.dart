// import 'package:QuickNotes/Feature/InheritedBlocs.dart';
// import 'package:QuickNotes/Foundation/Models/ChapterElements/Verse.dart';
import 'package:QuickNotes/Feature/Notes/notes_feature.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({Key key, @required this.results, this.controller})
      : super(key: key);

  final UnmodifiableListView results;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller:
            this.controller == null ? ScrollController() : this.controller,
        itemCount: results.length,
        itemBuilder: (BuildContext context, int index) {
          var note = results[index];
          return Container(
            decoration: BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(color: Colors.white10),
              ),
            ),
            child: NoteTile(note: note),
          );
        },
      ),
    );
  }
}
