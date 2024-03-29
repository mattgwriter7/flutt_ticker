// ignore_for_file: file_names

//  packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

//  classes
import '../classes/Utils.dart';

class Ticker with ChangeNotifier {

  // (this file) variables
  final String filename = 'Ticker.dart';

  //  private variables
  static int            _ms = 1000;                         //  how many milliseconds is the interval?

  static int            _tick = 0;
  static String         _clock_day = '';
  static String         _clock_date = '';
  static String         _clock_time = '';
  static String         _clock_phase = '';
  static String         _clock_sec = '';
  static int            _timer_sec = 0;
  static int            _timer_min = 0;
  static Color          _timer_color = Colors.white12;

  static bool           _timer_ready = false;
  static bool           _timer_started = false;
  static bool           _timer_never_started = true;





  // Ticker Provider getters 
  get show_seconds => _tick.toString();
  get show_day => _clock_day;
  get show_date => _clock_date;
  get show_time => _clock_time;
  get show_clock_seconds => _clock_sec;
  get show_phase => _clock_phase;
  get show_sec => gatherSeconds();
  get show_min => gatherMinutes();
  get timer_ready => _timer_ready;
  get show_timer_color => _timer_color;
  get timer_started => _timer_started;





  //  Ticker Provider setters and methods
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
    //  this needs a little massaging before being used by UI
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
    //  this needs a little massaging before being used by UI
    String str = '';
    late int modified_minutes;
    late int modified_hours;
    String minutes_str = '';

    if( _timer_sec == 0 && _timer_min == 0 ) { 
      str = '0';
    }
    else {
      if( _timer_min < 91 ) {
        str = _timer_min.toString();
      }
      else {
        //  get hours and minutes
        modified_hours = (_timer_min / 60).floor();
        modified_minutes = _timer_min % 60;
        //  add a zero if minutes less than 10
        if ( modified_minutes < 10 ) { 
          minutes_str = '0' + modified_minutes.toString();
        }
        else {
          minutes_str = modified_minutes.toString();  
        }  
        str = modified_hours.toString() + 'h' + minutes_str;
      }
      _timer_color = Colors.white;
    }
    return str;
  }


  //  -----------------------------------------------------------------------


  void initTicker() {
    //  this is called by initState of Start_Page.dart
    //  to start an 1 sec interval (even before the start button
    //  is pressed) in order to show the current date and time
    Utils.log( filename, 'initTicker()' );
    // runs every 1 second
    Timer.periodic(new Duration(milliseconds: _ms ), (timer) {
      tick();
    });    
  }
  
  void updateClock() {
    //  this updates the clock UI
    DateTime dt = DateTime.now();
    _clock_date = DateFormat("MMMM dd, yyyy").format(dt);
    _clock_day = DateFormat("EEEEE").format(dt);
    _clock_time = DateFormat("h:mm").format(dt);
    _clock_sec = DateFormat("ss").format(dt);
    _clock_phase = DateFormat("a").format(dt);
    //  uncomment next line to only show clock seconds sometimes...
    //  if ( timer_started == true || _timer_never_started == true ) _clock_sec = '';
    
    //  make sure to show the timer, too (so it will "pop in" at
    //  the start when the clock UI appears)
    _timer_ready = true;
    return;
  }

  void updateTimer() {
    //  this gets called only if the start button is active
    _timer_sec++;
    if( _timer_sec > 59 ) {
      _timer_sec = 0;
      _timer_min++;
    }
  }

  void tick() {
    //  THIS IS THE HEART OF THE TICKER CLASS:
    //  Every sec there is one tick (whether timer running or not)
    _tick++;
    //  the clock UI gets updated even if timer not running
    updateClock();
    //  but the timer UI only gets updated if timer is running
    if( _timer_started ) updateTimer();
    //  every tick, notifyListeners() to make sure UI is updated
    notifyListeners();
  }

}