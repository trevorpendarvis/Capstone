import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  static const routeName = '/splash_screen';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Just a sec ...",
          style: TextStyle(
            fontSize: 36.0,
            color: Colors.black38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
