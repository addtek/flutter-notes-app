import 'package:QuickNotes/Foundation/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:QuickNotes/Feature/InheritedBlocs.dart';
import 'package:QuickNotes/Feature/Navigation/navigation_bloc.dart';
import 'package:QuickNotes/Feature/Notes/notes_bloc.dart';
import 'package:QuickNotes/Feature/Search/search_bloc.dart';
import 'package:QuickNotes/Feature/Settings/settings_bloc.dart';
import 'package:QuickNotes/utils/router.dart';
import 'package:QuickNotes/theme/styles.dart';
import 'package:provider/provider.dart';
import 'package:QuickNotes/Foundation/Provider/app_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  final settingsBloc = SettingsBloc();
  final notesBloc = NotesBloc();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context)
          .backgroundColor
          .withOpacity(0.8),
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Theme.of(context).primaryColor,
    ));
    return  Consumer<AppProvider>(
          builder:
              (BuildContext context, AppProvider appProvider, Widget child) {
            return InheritedBlocs(
                settingsBloc: settingsBloc,
                notesBloc: notesBloc,
                navigationBloc: NavigationBloc(),
                searchBloc: SearchBloc(NotesProvider()),
                child: MaterialApp(
                  color: Colors.grey[300],
                  key: appProvider.key,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: appProvider.navigatorKey,
                  title: AppTheme.appName,
                  theme: appProvider.theme,
                  darkTheme: AppTheme.darkTheme,
                  initialRoute: '/',
                  onGenerateRoute: (RouteSettings settings) {
                    return MaterialPageRoute(
                      builder: (BuildContext context) => makeRoute(
                        notesBloc: notesBloc,
                        routeName: settings.name,
                        arguments: settings.arguments,
                      ),
                      maintainState: true,
                      fullscreenDialog: false,
                    );
                  },
                ));
          },
        );
  }
}
