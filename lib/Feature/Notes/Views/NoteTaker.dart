import 'dart:convert';
import 'package:QuickNotes/Foundation/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

import '../../InheritedBlocs.dart';

class NotePage extends StatefulWidget {
  final Note note;
  final Function showRefReader;

  const NotePage({Key key, this.note,this.showRefReader}) : super(key: key);
  @override
  NotePageState createState() => NotePageState(note: note,showRefReader:this.showRefReader);
}

class NotePageState extends State<NotePage> {
  final Note note;
  ZefyrController _controller;
  FocusNode _focusNode;
  final Function showRefReader;
  NotePageState({this.note,this.showRefReader});
  Delta originalDelta;
  bool hasUnsavedChanges=false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
     _controller = ZefyrController(note.doc);
    _focusNode = FocusNode();
    originalDelta = _controller.document.toDelta();
    _controller.addListener(
      () async{
        var delta = _controller.document.toDelta();
          var json = delta.toJson();
        if (delta != originalDelta &&
            _controller.lastChangeSource == ChangeSource.local) {
          String text = jsonEncode(json);
         if(text.length>0){
          if(mounted)setState(() {
            hasUnsavedChanges= true;
          });
            }
          else if(mounted)setState(() {
            hasUnsavedChanges= false;
          });
             var delta = _controller.document.toDelta();
          originalDelta = delta;
          note.lastUpdated = DateTime.now();
          // var rule =  ResolveInlineFormatRule();
            var index =  _allStringMatches(text,RegExp(r"(?:\d\s*)?[A-Z]?[a-z]+\s*\d+(?:[:-]\d+)?(?:\s*-\s*\d+)?(?::\d+|(?:\s*[A-Z]?[a-z]+\s*\d+:\d+))?"));
          if (index.length > 0) {
            index.forEach((element) { 
            //   var preVerse = text.replaceAll(element,
            //     " \"}, {\"insert\":\"$element\",\"attributes\": {\"a\":\"https://bible.com\"}}, {\"insert\":\"");
            // var post = jsonDecode(preVerse);
            // var doc = NotusDocument.fromJson(post);
            // var delta = Delta.fromJson(post); 
            // print(delta);
            var change = _controller.document.format(
                getVerseIndex(element),
                getVerseLength(element),
                NotusAttribute.link.fromString("https://bible.com"));
             _controller.formatText(getVerseIndex(element), getVerseLength(element),
                NotusAttribute.link.fromString("https://bible.com")); 
                
            _controller.compose(change);
            });
          }
          // InheritedBlocs.of(context).notesBloc.addUpdateNote.add(note); 
        
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ZefyrThemeData(
      attributeTheme: AttributeTheme(),
      toolbarTheme: ToolbarTheme.fallback(context).copyWith(
        color: Theme.of(context).scaffoldBackgroundColor,
        toggleColor: Colors.grey.shade900,
        iconColor: Theme.of(context).accentColor,
        disabledIconColor: Colors.grey.shade500,
      ),
    ); 
    return WillPopScope(
      onWillPop: ()async{
        if(hasUnsavedChanges){
        bool  shouldClose= await showDialog<bool>(context: context,
           builder:(context){
          return AlertDialog(title:Text("Unsaved Changes") ,content: Text("You have unsaved changes\nWhat would you like to do?"),
           actions: <Widget>[
             FlatButton(child: Text('Cancel'),onPressed:(){ Navigator.pop(context,false);} ,),
             FlatButton(child: Text('Save and Exit'),onPressed:(){saveChanges();Navigator.pop(context,true);} ,),
             FlatButton(child: Text('Discard'),onPressed:(){Navigator.pop(context,true);} ,)
           ],);
           }
          ).then((value) => value);
        return Future.value(shouldClose);
        }
        return Future.value(true);
      },
      child: Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        title: Text(note.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveChanges,
          ),
          IconButton(
            icon: Icon(Icons.view_agenda),
            onPressed: () async {
             
              
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: 
         ZefyrScaffold(
          child: ZefyrTheme(
            data: theme,
            child: ZefyrEditor(
              controller: _controller,
              focusNode: _focusNode,
            ),
          ),
        ), 
      ),
    ));
  }
 saveChanges(){
   var delta = _controller.document.toDelta();
        if (delta != originalDelta &&
            _controller.lastChangeSource == ChangeSource.local) {
          originalDelta = delta;
          note.lastUpdated = DateTime.now();
            _controller.compose(originalDelta); 
        }
    InheritedBlocs.of(context).notesBloc.addUpdateNote.add(note); 
         if(mounted)setState(() {
            hasUnsavedChanges= false;
          });
      var snackBar = SnackBar(
      duration: Duration(seconds: 5),
      // backgroundColor: Theme.of(context).primaryColor,
      content: Text('Note Saved!'),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar,);
 }
  int getVerseIndex(String text) {
    return text.indexOf(text);
  }
Iterable<String> _allStringMatches(String text, RegExp regExp) => 
    regExp.allMatches(text).map((m) => m.group(0));
  int getVerseLength(String text) {
    return ("John 2:1-3").length;
  }
}
