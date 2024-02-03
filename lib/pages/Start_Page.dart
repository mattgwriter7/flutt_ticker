// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:async';
import 'dart:io';

//  this page is Stateful (just to serve as an example)

//  classes
import '../classes/Config.dart';
import '../classes/Utils.dart';
import '../providers/Ticker.dart';

class Start_Page extends StatefulWidget {
  const Start_Page({super.key});

  @override
  State<Start_Page> createState() => _Start_PageState();
}

class _Start_PageState extends State<Start_Page> {

  // (this page) variables
  final String filename = 'Start_Page.dart';
  static String _button_label = 'start';
  static Color _button_color = Colors.white12;
  static Color _button_label_color = Colors.white10;
  static bool _show_hud = false;

  // (this page) init and dispose
  @override
  void initState() {
    super.initState();
    Utils.log( filename, 'initState()' );
    WidgetsBinding.instance.addPostFrameCallback((_) => _addPostFrameCallbackTriggered(context));

    //  init Ticker
    Provider.of<Ticker>(context, listen: false).initTicker();
  }

  @override
  void dispose() {
    Utils.log( filename, 'dispose()');
    super.dispose();
  }

  // (this page) methods
  void _buildTriggered() {
    //  Utils.log( filename, '_buildTriggered()');
  }

  // addPostFrameCallback" is called after build completed 
  void _addPostFrameCallbackTriggered( context ) {
    Utils.log( filename, '_addPostFrameCallbackTriggered() (build completed)');
  }

  @override
  Widget build(BuildContext context) {
    
    _buildTriggered();
    
    return WillPopScope(
      onWillPop: () async {
        Utils.log( filename, 'pop() forbidden!');
        return false;  //  this allows the back button to work (if true)
      },      
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text( 'Ticker' ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white12,
          ), 
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                color: Colors.transparent,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 60),
                            Text( context.watch<Ticker>().show_day,
                                style: TextStyle( fontSize: 28)),
                            Text( context.watch<Ticker>().show_date,
                                style: TextStyle( fontSize: 20)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text( context.watch<Ticker>().show_time, style: TextStyle( fontSize: 64)),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5,0,0,8),
                                  child: Text( context.watch<Ticker>().show_phase, style: TextStyle( fontSize: 32, color: Colors.white54)),
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text( context.watch<Ticker>().show_min,
                                style: TextStyle( fontSize: 96, color: context.watch<Ticker>().show_timer_color )),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(3,15,0,0),
                                  child: Text(context.watch<Ticker>().show_sec, 
                                  style: TextStyle( fontSize: 20)),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,30,0,40),
                              child: SizedBox(
                                width: 220,
                                height: 60,
                                child: ElevatedButton(
                                  child: Text( _button_label, style: TextStyle( fontSize: 28)),
                                  onPressed: () {
                                    String stamp = 'timer at ${context.read<Ticker>().show_min}m${context.read<Ticker>().show_sec}s';
                                    if ( stamp == 'timer at 0ms' ) stamp = 'timer (for 1st time)';
                                    if ( !context.read<Ticker>().timer_started ) {
                                      Utils.log( filename, 'START $stamp');
                                      context.read<Ticker>().startTimer();
                                      setState(() {
                                        _button_label = 'stop';
                                        _button_color = Colors.green;
                                        _button_label_color = Colors.white;
                                        _show_hud = false;
                                        //  make screen stay awake!
                                        Wakelock.enable();
                                      });
                                    }
                                    else {
                                      Utils.log( filename, 'STOP timer');
                                      context.read<Ticker>().stopTimer();
                                      setState(() {
                                        _button_label = 'start';
                                        _button_color = Colors.white12;
                                        _button_label_color = Colors.white10;
                                        _show_hud = true;
                                        //  allow screen to sleep
                                        Wakelock.disable();
                                      });
                                    }
                                  },
                                  // _button_color
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _button_color, 
                                    foregroundColor: _button_label_color,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                    ),             
                  ],
                ),
              ),








              //  TOP "LINKS" HUD
              //  ( for "Quot App" and "Reset")
              Visibility(
                visible: _show_hud,
                child: Positioned(
                  left: 10,
                  top: 10,
                  child: TextButton.icon(
                    icon: const Icon( Icons.cancel, color: Colors.white), // Your icon here
                    label: Text('Quit App', style: TextStyle( color: Colors.white, decoration: TextDecoration.underline, )),
                    onPressed: (){
                      Timer(Duration( milliseconds: Config.short_delay), () {
                        //  exit app (after short delay) based on
                        //  https://stackoverflow.com/questions/45109557/flutter-how-to-programmatically-exit-the-app
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        } 
                        else if (Platform.isIOS) {
                          exit(0);
                        }
                      }); 
                    }
                  ), 
                ),
              ),

              Visibility(
                visible: _show_hud,
                child: Positioned(
                  right: 10,
                  top: 10,
                  child: TextButton.icon(
                    icon: const Icon( Icons.refresh, color: Colors.white), // Your icon here
                    label: Text('Reset', style: TextStyle( color: Colors.white, decoration: TextDecoration.underline, )),
                    onPressed: (){
                        //  reset the timer quickly (no delay)
                        context.read<Ticker>().resetTimer();
                        setState(() {
                          _button_label = 'start';
                          _button_color = Colors.white12;
                          _button_label_color = Colors.white10;
                          _show_hud = false;                          
                        });
                    }
                  ), 
                ),
              )              
            ],  
          ),
        ),
      ),
    );
  }
}