import 'package:flutter/material.dart';

class CreditCardBack extends StatelessWidget {
  String? cardCVV;

  CreditCardBack({required this.cardCVV});

  Widget _buildStack(context) => Stack(children: <Widget>[
        Container(
          child: ClipRRect(
            child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(16),
          ),
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
              color: Color(0xffa29bfe),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 5,
                  blurRadius: 18,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(16)),
        ),
        
        Positioned(
          width: 500,
          height: 45,
          top: 30,
          child: ColoredBox(color: Colors.black)
        ),
        Positioned(
          bottom: 80,
          right: 60,
          child: Text(
            cardCVV!,
            style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
          
      ]);

  @override
  Widget build(BuildContext context) {
     return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: _buildStack(context),
    );
  }
}