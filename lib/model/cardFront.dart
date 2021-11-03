import 'package:flutter/material.dart';

class CreditCardFront extends StatelessWidget {
  String? cardNum;
  String? cardName;
  String? cardExp;

  CreditCardFront({
    required this.cardNum,
    required this.cardName,
    required this.cardExp,
  });

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
          left: 20,
          top: 20,
          child: Image.asset('assets/images/MonkeyLogo.png', width: 90, height: 90),
        ),
        Positioned(
            left: 30,
            top: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(cardNum!,
                    style: TextStyle(fontSize: 24, color: Colors.white)),
                 
              ],
            )),
            Positioned(
            right: 130,
            top: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(cardExp!,
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ],
            )),
            Positioned(
            left: 20,
            top: 185,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(cardName!,
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                
              ],
            )),
      ]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: _buildStack(context),
    );
  }
}
