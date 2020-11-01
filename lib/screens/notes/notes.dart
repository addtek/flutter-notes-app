import 'package:QuickNotes/components/app_bar_title/title_component.dart';
import 'package:QuickNotes/utils/route_names.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:QuickNotes/Feature/InheritedBlocs.dart';
import 'package:QuickNotes/Feature/Navigation/navigation_feature.dart';
import 'package:flutter/material.dart';
import 'package:QuickNotes/Foundation/Provider/app_provider.dart';
import 'package:QuickNotes/theme/styles.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:QuickNotes/Feature/Notes/notes_feature.dart';
import 'package:QuickNotes/Feature/Search/search_feature.dart';
import 'package:QuickNotes/Foundation/foundation.dart';
import 'package:zefyr/zefyr.dart';

class NotesApp extends StatefulWidget {
  NotesApp({Key key, this.notesBloc}) : super(key: key);
  final notesBloc;
  @override
  _NotesAppState createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  DateTime currentBackPressTime;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController _scrollController =
      new ScrollController(); // set controller on scrolling
  bool _show = true;
  final exitSnackBar = SnackBar(
    content: Text('Press back again to exit'),
    duration: Duration(seconds: 3),
  );


  void showFloationButton() {
    setState(() {
      _show = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      _show = false;
    });
  }

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
          hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
          showFloationButton();
      }
    });
  }
  @override
  void initState(){
      super.initState();
          handleScroll();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Theme.of(context).backgroundColor.withOpacity(0.8),
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor:Theme.of(context).primaryColor,
      systemNavigationBarIconBrightness: MediaQuery.of(context).platformBrightness ==Brightness.light|| Provider.of<AppProvider>(context).theme == AppTheme.lightTheme?Brightness.dark:Brightness.light
    ));
    return StreamBuilder<AppPage>(
      stream: InheritedBlocs.of(context).navigationBloc.currentPage,
      builder: (context, currentPageSnapshot) {
        return WillPopScope(child:Scaffold(
          body:
           SafeArea(
              child: Scaffold(
                  key: _scaffoldKey,
                  floatingActionButton:Visibility(
                  visible: _show,
                  child: FloatingActionButton.extended(
                    isExtended: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      showCreateNoteDialog(context);
                    },
                    label:Text('Add Note',style:TextStyle(color: Theme.of(context).accentColor)),
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).accentColor,
                    ),
                  )),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  drawer: Drawer(
                    child: ListView(
                      children: <Widget>[
                        DrawerHeader(
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              
                            ],
                          )),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                Theme.of(context).backgroundColor,
                                Theme.of(context).backgroundColor
                              ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight)),
                        ),
                        ListTile(
                          dense: true,
                          leading: Container(
                            child: Icon(Icons.settings),
                          ),
                          title: Text("Settings"),
                          trailing: Container(
                              child: Icon(
                            Icons.arrow_forward_ios,
                            size: 14.0,
                          )),
                          onTap: () {
                            _scaffoldKey.currentState.openEndDrawer();
                            Navigator.pushNamed(
                              context,
                              Routes.settings,
                            );
                          },
                        ),
                        Divider(),
                        ListTile(
                          dense: true,
                          leading: Container(
                            child: Icon(Icons.playlist_add_check),
                          ),
                          title: Text("Terms  & Conditions"),
                          trailing: Container(
                              child: Icon(
                            Icons.arrow_forward_ios,
                            size: 14.0,
                          )),
                        ),
                        Divider(),
                        ListTile(
                          dense: true,
                          leading: Container(
                            child: Icon(Icons.info),
                          ),
                          title: Text("About"),
                          trailing: Container(
                              child: Icon(
                            Icons.arrow_forward_ios,
                            size: 14.0,
                          )),
                          onTap: () async => null,
                        ),
                        Divider(),
                        ListTile(
                          onTap: () {
                            _scaffoldKey.currentState.openEndDrawer();
                            final RenderBox box = context.findRenderObject();
                            Share.share(
                                "Dowload the Quick Note APP here: https://play.google.com/store/apps/details?id=com.addteknologies.QuickNotes",
                                subject:
                                    "Share Quick Note APP via",
                                sharePositionOrigin:
                                    box.localToGlobal(Offset.zero) & box.size);
                          },
                          dense: true,
                          leading: Container(
                            child: Icon(Icons.share),
                          ),
                          title: Text("Share App"),
                          trailing: Container(
                              child: Icon(
                            Icons.arrow_forward_ios,
                            size: 14.0,
                          )),
                        ),
                        
                      ],
                    ),
                  ),
                  body: new RefreshIndicator(
                    displacement: 20.00,
                    onRefresh: () async {
                    },
                    child: StreamBuilder<List<Note>>(
            stream: InheritedBlocs.of(context).notesBloc.savedNotes,
            initialData: [],
            builder: (context, snapshot) {
              var notes = snapshot.data;
              
              return NestedScrollView(
                      controller: _scrollController, 
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            floating: true,
                            pinned: true,
                            automaticallyImplyLeading: false,
                            expandedHeight: 300.0,
                            flexibleSpace: FlexibleSpaceBar(
                                centerTitle: false,
                                background:  Container(
                                    // color: Theme.of(context).backgroundColor,
                                    child: Center(
                                      child:Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context).size.width,
                                          
                                          child: Text("All notes",style: TextStyle(fontSize: 35,fontWeight: FontWeight.w300),),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context).size.width,
                                          
                                          child: Text("${notes.length} note${notes.length>1?"s":""}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w200),),
                                        ),
                                        
                                      ],
                                    )))),
                          bottom: AppBar(
                            elevation: 0.00,
                          automaticallyImplyLeading: false,
                            leading: IconButton(
                              icon: Icon(
                                Icons.menu,
                              ),
                              tooltip: "Menu",
                              onPressed: () =>
                                  _scaffoldKey.currentState.openDrawer(),
                            ),
                            title: ScrollAwareAppBarTitle(child:Text("All Notes")),
                            actions: <Widget>[
                              IconButton(
                              icon: Icon(
                                Icons.search,
                              ),
                              tooltip: "Search",
                              onPressed: (){
                                  _scaffoldKey.currentState.openEndDrawer();
                                  showSearch(
                                  context: context,
                                  delegate: BibleSearchDelegate(),
                                );}
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.more_vert,
                              ),
                              tooltip: "More",
                              onPressed: () =>null
                                  // _scaffoldKey.currentState.openDrawer(),
                            )
                            ],
                          ),
                          ),
                        ];
                      },
                      body: ScrollConfiguration(
                      behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
                      child:NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollStartNotification) {
                  hideFloationButton();
                } else if (scrollNotification is ScrollEndNotification) {
                  showFloationButton();
                }
                return true;
              },
              child:
                Container(
                  margin: EdgeInsets.only(top:20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          var note = notes[index];
                          return NoteTile(note: note);
                        },
                      ),
                )
              )),
                      
                    );})
                  )))
          ,
                ),onWillPop:onWillPop);
      },
      initialData: null,
    );
  }

  Future<bool> onWillPop() async {
    if (_scaffoldKey.currentState.isDrawerOpen) {
      return true;
    }
    DateTime now = DateTime.now();
    bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        currentBackPressTime == null ||
            now.difference(currentBackPressTime) > Duration(seconds: 3);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      currentBackPressTime = now;
      _scaffoldKey.currentState.showSnackBar(exitSnackBar);
      return false;
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return false;
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(() {});
  }
  Future showCreateNoteDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        
        TextEditingController _controller = TextEditingController();
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: WillPopScope(
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          height: 150.0,
                          width: 300.0,
                          child: new Form(
                              key: _formKey,
                              child: Stack(children: <Widget>[
                                Positioned(
                                  top: 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 300,
                                    height: 40,
                                    child: Text(
                                      "Add Note",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 40),
                                  child:  TextFormField(
                                  controller: _controller,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: "Note Title",
                                  ),
                                  validator: (value){
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Expanded(
                                            child: FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Cancel")),
                                          ),
                                          Expanded(
                                            child: FlatButton(
                                                onPressed: () {
                                         if (_formKey.currentState.validate()) {
                                                  Navigator.pop(context, _controller.text);
                                                }

                                                },
                                                child: Text("Create Note")),
                                          ),
                                        ]),
                                  ),
                                )
                              ])))),
                  onWillPop: () => Future.value(false)));
        }

    ).then((text)async{if (text != null) {
      var id =
          await InheritedBlocs.of(context).notesBloc.highestNoteId.first ?? 0;
      id++;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return NotePage(
              note: Note(
                  id: id,
                  title: text,
                  lastUpdated: DateTime.now(),
                  doc: NotusDocument(),
                  // doc: ""
                  ),
            );
          },
        ),
      );
    }});

  }

}