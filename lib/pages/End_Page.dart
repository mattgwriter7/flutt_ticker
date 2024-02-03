// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

//  classes
import '../classes/Config.dart';
import '../classes/Utils.dart';

class End_Page extends StatelessWidget {
  const End_Page({super.key});

  // (this page) variables
  final String filename = 'End_Page.dart';  

  // (this page) methods
  void _buildTriggered() {
    Utils.log( filename, '_buildTriggered()');
  }  

 @override
  Widget build(BuildContext context) {
    
    _buildTriggered();
    
    return WillPopScope(
      onWillPop: () async {
        Utils.log( filename, 'pop()!');
        return true;  //  this allows the back button to work (if true)
      },  
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text( filename ),
            centerTitle: true,
          ), 
          body: Container(
            width: double.infinity,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children : 
                [ 
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,15),
                    child: Text( filename ),
                  ),
                  ElevatedButton(
                    child: const Text( '<< Start_Page' ),
                    onPressed: () {
                      Utils.log( filename, 'pop()!');
                      Navigator.of(context).pop();         
                      return;
                    },
                  ),                  
                ],
            ),  
          ),
        ),
      ),
    );
  }
}