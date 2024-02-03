// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

//  classes
import '../classes/Config.dart';
import '../classes/Utils.dart';

//  pages
import './pages/Start_Page.dart';
import './pages/End_Page.dart';

//  This code is literally from the "flutter create" boilerplate,
//  but I removed the counter app (and kept the underlying structure),
//  and some unecessary comments and variables...

void main() {
  runApp(const MyApp());
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
      debugShowCheckedModeBanner: true,
      initialRoute: 'Start_Page',
      routes: {
        'Start_Page': (context) => const Start_Page(),
        'End_Page': (context) => const End_Page(),
      },
    );
  }
}
