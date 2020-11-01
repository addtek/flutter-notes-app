import 'package:QuickNotes/Feature/InheritedBlocs.dart';
import 'package:QuickNotes/Foundation/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import 'NoteTaker.dart';

class NoteTile extends StatefulWidget {
  const NoteTile({
    Key key,
    @required this.note,
  }) : super(key: key);

  final Note note;

  @override
  _NoteTileState createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  var _selected = false;
  final _slideKey = GlobalKey();
  final SlidableController slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    var lastUpdated = widget.note.lastUpdated.toLocal();
    return Container(
      margin: EdgeInsets.only(bottom:15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25))
        ,color: Colors.white),
      height: 120.00,
      child: Slidable.builder(
      key: _slideKey,
      controller: slidableController,
      // delegate: SlidableDrawerDelegate(),
      actionPane: _getDelegate(widget.note.id),
      actionExtentRatio: 0.25,
      actionDelegate: SlideActionBuilderDelegate(
          actionCount: 2,
          builder: (context, index, animation, renderingMode) {
            if (index == 0) {
              return new IconSlideAction(
                caption: 'Archive',
                color: Colors.blue.withOpacity(animation.value),
                icon: Icons.archive,
                onTap: () => null,
              );
            } else {
              return new IconSlideAction(
                caption: 'Share',
                color: Colors.indigo.withOpacity(animation.value),
                icon: Icons.share,
                onTap: () => shareSavedNote(),
              );
            }
          }
      ),
      child: ListTile(
        isThreeLine: true,
        leading: Icon(Icons.lens,size: 10.0,),
        selected: _selected,
        onLongPress: () {
          setState(() {
            _selected = !_selected;
          });
        },
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return NotePage(
                    note: widget.note,
                  );
                },
              ),
            ),
        title: Container(child: Text(widget.note.title),height: 20,margin: EdgeInsets.only(top:10),),
        subtitle:Container(
          height: 70,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Container(width: MediaQuery.of(context).size.width/2,child: Text(widget.note.doc.toPlainText(),overflow: TextOverflow.ellipsis,maxLines: 2,),),
          Text(DateFormat('dd MMM yyyy').format(lastUpdated)),
        ],),),
      ),
      secondaryActionDelegate: SlideActionBuilderDelegate(
          actionCount: 1,
          builder: (context, index, animation, renderingMode) {
            return IconSlideAction(
              caption: 'Delete',
              color: Colors.redAccent.shade700,
              icon: Icons.delete,
              onTap: () => showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Delete'),
                content: Text('Item will be deleted'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      Slidable.of(context).close();
      
                    },
                  ),
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      InheritedBlocs.of(context).notesBloc.deleteSavedNote(widget.note.id);
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
              ),
              closeOnTap:true
            );
          }),
    ) ,
    );
  
  }
    Widget _getDelegate(int index) {
    switch (index % 4) {
      case 0:
        return new SlidableBehindActionPane();
      case 1:
        return new SlidableStrechActionPane();
      case 2:
        return new SlidableScrollActionPane();
      case 3:
        return new SlidableDrawerActionPane();
      default:
        return null;
    }
  }
  void shareSavedNote() async {
   final RenderBox box = context.findRenderObject();
        Share.share(widget.note.doc.toPlainText(),
                    subject: widget.note.title,
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) &
                            box.size);
  }
  
}
