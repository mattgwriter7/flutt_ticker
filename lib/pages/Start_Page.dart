// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'dart:io';

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
  static Color _button_color = Colors.white12;          //  "start" button is grey at first
  static Color _button_label_color = Colors.white10;
  static bool _show_hud = false;
  static bool _hide_timer_container = true;
  static bool _showCurtain = true;
  static double _curtain_width = double.infinity;

  // (this page) init and dispose
  @override
  void initState() {
    super.initState();
    Utils.log( filename, 'initState()' );
    WidgetsBinding.instance.addPostFrameCallback((_) => _addPostFrameCallbackTriggered(context));

    //  init the Ticker << START THE MAGIC!! >>
    Provider.of<Ticker>(context, listen: false).initTicker();

    //  curtain
    Timer(Duration( milliseconds: 5000 ), () {
      _showCurtain = false;
      Timer(Duration( milliseconds: 500 ), () {
        if(mounted) {
          setState(() {
            _curtain_width = 0;  
          });
        }
      });      
    });
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
          /*
          appBar: AppBar(
            title: Text( 'Ticker' ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white12,
          ),
          */ 
          body: Stack(
            children : [ 
              Stack(
                children: [




                  //  real ui (concealed at start)
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Column(
                      children: [
              
              
              
              
              
              
              
                        //  CLOCK BOX (Top Half)
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 70),
                                Text( context.watch<Ticker>().show_day,
                                    style: TextStyle( fontSize: 28)),
                                Text( context.watch<Ticker>().show_date,
                                    style: TextStyle( fontSize: 20)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  //crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text( context.watch<Ticker>().show_time, style: TextStyle( fontSize: 64)),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(4,0,0,0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text( context.watch<Ticker>().show_clock_seconds, style: TextStyle( fontSize: 18, color: Colors.white54)),
                                          Text( context.watch<Ticker>().show_phase, style: TextStyle( fontSize: 32, color: Colors.white54)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ),
                        ),
              
              
              
              
              
              
              
                        //  TIMER BOX (Bottom Half)
                        Expanded(
                          child: Visibility(
                            visible: context.watch<Ticker>().timer_ready,
                            child: _hide_timer_container == false ? Container(
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
                                      style: TextStyle( fontSize: 72, color: context.watch<Ticker>().show_timer_color )),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(3,11,0,0),
                                        child: Text(context.watch<Ticker>().show_sec, 
                                        style: TextStyle( fontSize: 20)),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0,20,0,40),
                                    child: SizedBox(
                                      width: 200,
                                      height: 65,
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
                            )
                            :  
                            Material(
                              color: Colors.black,
                              child: InkWell(
                                customBorder: CircleBorder(),
                                onTap: () {
                                  Timer(Duration( milliseconds: Config.short_delay), () {
                                    setState(() {
                                      if(mounted) _hide_timer_container = false;
                                    });
                                  });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('tap to',
                                        style: TextStyle( color: Colors.white24)
                                      ),
                                      Text('show timer',
                                        style: TextStyle( color: Colors.white24)
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0,0,0,20),
                                        child: Icon(
                                          Icons.emergency,
                                          color: Colors.white24,
                                          size: 30.0,
                                        ),
                                      ),
                                                      
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),             
                      ],
                    ),
                  ),
              
              
              
              
              
              
              
              
                  //  TOP "LINKS" HUD
                  //  ( for "Quit App" and "Reset")
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
                              _hide_timer_container = true;              
                            });
                        }
                      ), 
                    ),
                  )              
                ],  
              ),


                  AnimatedOpacity(
                    opacity: _showCurtain ? 1.0 : 0,
                    duration: const Duration(milliseconds: 500),                    
                    child: Container(
                      color: Colors.black,
                      width: _curtain_width,
                      height: MediaQuery.of(context).size.height,
                      child: Animate(
                        effects: [ 
                          FadeEffect( delay: 1000.ms  ),
                          // ScaleEffect( delay: 250.ms, duration: 200.ms )
                        ],                         
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,0,0,10),
                              child: Text('One Button Apps', style: TextStyle( fontSize: 24)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,0,0,10),
                              child: Text('presents', style: TextStyle( fontSize: 24)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,0,0,10),
                              child: Text('TICKER', style: TextStyle( fontSize: 32)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),  



            ]
          ),
        ),
      ),
    );
  }
}