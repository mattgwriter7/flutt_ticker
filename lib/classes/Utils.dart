// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/foundation.dart';

//  Presenting the "Utils" class (version 1.0)
//  This class is for logging stuff.
//  It does console logs (with a timestamp and
//  a ">>" which is used to filter stuff out
//  in the debug console), and also builds a
//  running_log String (to dump everything 
//  at once, as needed)...

class Utils {

  // (this page) variables
  static const String filename = 'Utils.dart';
  //  the first timestamp
  static final int original_timestamp = DateTime.now().millisecondsSinceEpoch;
  //  running Log String
  static String running_log = '';  //  this is a capture of what console.log has printed
  
  //  ==============================
  //  return current timestamp in ms
  //  ==============================
  static int timeStampNow () {
    return DateTime.now().millisecondsSinceEpoch;
  }
  
  //  ==============================
  //  return the ms difference in this timestamp
  //  and the original one
  //  ==============================  
  static String showTimeDiff ( [bool allowHtml = false ]) {
    String val = '';
    int diff = timeStampNow() - original_timestamp;
    double minute = 0;
    if ( diff < 60000 ) {
      double seconds = diff * .001;
      val = '${seconds.toStringAsFixed(1)}s';
    }
    else {
      minute = diff/60000;
      double remainder = diff%60000;
      remainder = remainder*.001;
      val = '${minute.toInt()}m ${remainder.toStringAsFixed(1)}s';
    }
    //  if value has a minus, remove it!
    if ( val == '-0.0s' ) {
      val = '0.0s';
    }
    return val;
  }

  //  =============
  //  == The LOG ==
  //  =============
  //  This takes 2 paramaters.
  //    1. filename is the calling file
  //    2. message is the message to log
  //  NOTE: If the file name is blacklisted it
  //        will not be shown 
  static void log( String filename, String message ) {
    if ( !blacklist.contains( filename )) {
      if ( kDebugMode ) {
        print('(${ showTimeDiff() }) >> ($filename) $message');
      }
      running_log += "(${ showTimeDiff() }) >> ($filename) $message\r\n";
    }
  }
  
  //  BLACKLIST (do not show logging info from these files)
  static List<String> blacklist = [
    //  'Start_Page.dart',
  ];

}
  