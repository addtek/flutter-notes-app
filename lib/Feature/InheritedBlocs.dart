import 'package:QuickNotes/Feature/Navigation/navigation_feature.dart';
import 'package:QuickNotes/Feature/Notes/notes_feature.dart';
import 'package:QuickNotes/Feature/Search/search_feature.dart';
import 'package:QuickNotes/Feature/Settings/settings_feature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InheritedBlocs extends InheritedWidget {
  InheritedBlocs(
      {Key key,
      this.searchBloc,
      this.settingsBloc,
      this.notesBloc,
      this.navigationBloc,
      this.child})
      : super(key: key, child: child);

  final Widget child;
  final SettingsBloc settingsBloc;
  final NotesBloc notesBloc;
  final NavigationBloc navigationBloc;
  final SearchBloc searchBloc;

  static InheritedBlocs of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedBlocs>();
  }

  @override
  bool updateShouldNotify(InheritedBlocs oldWidget) {
    return true;
  }

}
