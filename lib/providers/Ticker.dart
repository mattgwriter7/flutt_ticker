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
  static int            _ms = 1000;         //  how many milliseconds is the interval?

  static int            _tick = 0;
  static String         _clock_day = '';
  static String         _clock_date = '';
  static String         _clock_time = '';
  static String         _clock_phase = '';

  static int            _timer_sec = 0;
  static int            _timer_min = 0;
  static Color          _timer_color = Colors.white12;

  static bool           _timer_started = false;
  static bool           _timer_never_started = true;


  // Provider getters 
  get show_seconds => _tick.toString();
  get show_day => _clock_day;
  get show_date => _clock_date;
  get show_time => _clock_time;
  get show_phase => _clock_phase;
  get show_sec => gatherSeconds();
  get show_min => gatherMinutes();
  get show_timer_color => _timer_color;
  get timer_started => _timer_started;

  //  setters
  void resetTimer() {
    _timer_sec = 0;
    _timer_min = 0;
    _timer_color = Colors.white12;

    _timer_started = false;
    _timer_never_started = true;
    return;
  }

  void startTimer () { 
    if ( _timer_never_started ) {
      _timer_never_started = false;
      _timer_color = Colors.white;
    }
    _timer_started = true; 
  }
  void stopTimer () { _timer_started = false; }

  String gatherSeconds() {
    String str = '';
    if( _timer_never_started ) { 
      str = '';
    }
    else {
      if ( _timer_sec < 10 ) {
        str = '0' + _timer_sec.toString();
      }
      else {
        str = _timer_sec.toString();
      }
    }
    return str;
  }

  String gatherMinutes() {
    String str = '';
    if( _timer_sec == 0 && _timer_min == 0 ) { 
      str = '0';
    }
    else {
      str = _timer_min.toString();
      //  WILLFIX:  Should I add logic so if time > 1 hour then
      //            "h" and "m" get added for minutes/seconds?
      _timer_color = Colors.white;
    }
    return str;
  }


  void initTicker() {
    Utils.log( filename, 'initTicker()' );
    // runs every 1 second
    Timer.periodic(new Duration(milliseconds: _ms ), (timer) {
      tick();
    });    
  }
  
  void updateClock() {
    DateTime dt = DateTime.now();
    _clock_date = DateFormat("MMMM dd, yyyy").format(dt);
    _clock_day = DateFormat("EEEEE").format(dt);
    _clock_time = DateFormat("h:mm").format(dt);
    _clock_phase = DateFormat("a").format(dt);
    return;
  }

  void updateTimer() {
    _timer_sec++;
    if( _timer_sec > 59 ) {
      _timer_sec = 0;
      _timer_min++;
    }
  }

  void tick() {
    _tick++;
    updateClock();
    if( _timer_started ) updateTimer();
    notifyListeners();
  }

}