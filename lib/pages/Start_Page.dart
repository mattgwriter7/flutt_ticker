// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

//  this page is Stateful (just to serve as an example)

//  classes
import '../classes/Config.dart';
import '../classes/Utils.dart';

class Start_Page extends StatefulWidget {
  const Start_Page({super.key});

  @override
  State<Start_Page> createState() => _Start_PageState();
}

class _Start_PageState extends State<Start_Page> {

  // (this page) variables
  final String filename = 'Start_Page.dart';

  // (this page) init and dispose
  @override
  void initState() {
    super.initState();
    Utils.log( filename, 'initState()' );
    WidgetsBinding.instance.addPostFrameCallback((_) => _addPostFrameCallbackTriggered(context));

    //  setupApp();
  }

  @override
  void dispose() {
    Utils.log( filename, 'dispose()');
    super.dispose();
  }

  // (this page) methods
  void _buildTriggered() {
    Utils.log( filename, '_buildTriggered()');
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
          ), 
          body: Container(
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
                        Text('WEDNESDAY',
                            style: TextStyle( fontSize: 28)),
                        Text('MAY 09 2024',
                            style: TextStyle( fontSize: 20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('9:29', style: TextStyle( fontSize: 64)),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10,0,0,10),
                              child: Text('PM', style: TextStyle( fontSize: 32)),
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
                            Text('27m',
                            style: TextStyle( fontSize: 72)),
                            Text('05',
                            style: TextStyle( fontSize: 20)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,30,0,40),
                          child: SizedBox(
                            width: 220,
                            height: 60,
                            child: ElevatedButton(
                              child: Text('start', style: TextStyle( fontSize: 28)),
                              onPressed: () {},
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
        ),
      ),
    );
  }
}