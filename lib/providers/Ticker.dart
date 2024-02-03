// ignore_for_file: file_names

//  packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

//  classes
import '../classes/Config.dart';
import '../classes/Utils.dart';

class Ticker with ChangeNotifier {

  // (this page) variables
  final String filename = 'Ticker.dart';

  //  private variables
  static int            _tick = 0;
  static String         _clock_day = '';
  static String         _clock_date = '';
  static String         _clock_time = '';
  static String         _clock_phase = '';

  // Provider getters 
  get show_seconds => _tick.toString();
  get show_day => _clock_day;
  get show_date => _clock_date;
  get show_time => _clock_time;
  get show_phase => _clock_phase;


  //  setters
  void initTicker() {
    Utils.log( filename, 'initTicker()' );
    // runs every 1 second
    Timer.periodic(new Duration(seconds: 1), (timer) {
      tick();
    });    
  }
  
  void updateClock() {
    var dt = DateTime.now();
    _clock_date = DateFormat("MMMM dd, yyyy").format(dt);
    _clock_day = DateFormat("EEEEE").format(dt);
    _clock_time = DateFormat("hh:mm").format(dt);
    _clock_phase = DateFormat("a").format(dt);
    return;
  }

  void tick() {
    _tick++;
    updateClock();
    notifyListeners();
  }

}