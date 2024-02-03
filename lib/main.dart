// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//  classes
import '../classes/Config.dart';
import '../classes/Utils.dart';

//  pages
import './pages/Start_Page.dart';
import './pages/End_Page.dart';
import 'providers/Ticker.dart';

//  Portrait mode is forced here...
//  See: https://stackoverflow.com/questions/49418332/flutter-how-to-prevent-device-orientation-changes-and-force-portrait
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);  
  runApp( MultiProvider (
    providers: [ ChangeNotifierProvider(create: (_) => Ticker()),],
    child: MyApp()) 
  );
}

class MyApp extends StatelessWidget {
  const MyApp({ super.key });

  // (this page) variables
  final String filename = 'main.dart';

  // (this page) methods
  void _buildTriggered() {
    Utils.log( filename, '== "${ Config.app_name }" ver ${ Config.app_version } ==');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    _buildTriggered();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: TextTheme(
            bodyText2: TextStyle(
              color: Colors.white,
            ),
          ),
        ),      
      initialRoute: 'Start_Page',
      routes: {
        'Start_Page': (context) => const Start_Page(),
        'End_Page': (context) => const End_Page(),
      },
    );
  }
}
