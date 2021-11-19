import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:intl/intl.dart';

class ScreenSaver extends StatefulWidget {
  static const routeName = '/screen_saver';

  const ScreenSaver({Key? key}) : super(key: key);

  @override
  _ScreenSaverState createState() => _ScreenSaverState();
}

class _ScreenSaverState extends State<ScreenSaver> {
  late Timer timer;
  String time = '';
  bool flashDot = false;

  @override
  void initState() {
    print('initState()');
    super.initState();
    Wakelock.enable();

    timer = new Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    setState(() {
      time = flashDot ? DateFormat('H:mm').format(now) : DateFormat('H mm').format(now);
      flashDot = !flashDot;
    });
  }

  @override
  void dispose() {
    print('dispose()');
    super.dispose();
    timer.cancel();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies()');
    super.didChangeDependencies();

    // Ref.sharedPreferences.setString(Ref.DATE_PATTERN, 'DD/MM');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Container(
                color: Colors.black87,
                padding: EdgeInsets.all(30.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    time,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'DS-DIGIB',
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Monkey Management',
                      style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 24.0)),
                  Text('powered by Team 4', style: TextStyle(color: Colors.white54, fontSize: 16.0)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
