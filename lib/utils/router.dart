import 'package:QuickNotes/Feature/Notes/notes_bloc.dart';
import 'package:QuickNotes/screens/notes/notes.dart';
import 'package:flutter/material.dart';
import 'package:QuickNotes/screens/splash/splash.dart';


Widget makeRoute(
    {
    @required String routeName,
    @required NotesBloc notesBloc,
    dynamic arguments}) {
  final Widget child = _buildRoute(
      routeName: routeName,
      notesBloc: notesBloc,
      arguments: arguments);
  return child;
}

Widget _buildRoute({
  @required String routeName,
  @required NotesBloc notesBloc,
  dynamic arguments,
}) {
  switch (routeName) {
    case '/':
      return new SplashScreen();
      break;
    case '/main':
      return NotesApp(notesBloc:notesBloc);
      break;
    default:
      throw 'Route $routeName is not defined';
  }
}
