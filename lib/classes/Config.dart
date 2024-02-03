// ignore_for_file: file_names, constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';


//  Presenting the "Config" class (version 1.0)
//  This class is for "global variables" used by
//  the app.

class Config {
  
  static const  String    app_name                  = "flutt_start_3";
  static const  String    app_version               = "1.0.alpha";
  
  //  timeouts and delays
  static int              server_timeout            = 10;     // seconds
  static int              short_delay               = 500;    // milliseconds
  static int              long_delay                = 1500;   // milliseconds

  //  CUSTOM STUFF! (from here on this is stuff unique to this App)
  //  ... nuthin' here yet

}