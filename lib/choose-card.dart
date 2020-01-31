import 'dart:async';
import 'dart:math';

import 'package:death_counter/flip.dart';
import 'package:death_counter/toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseCard extends StatefulWidget {
  final int remaining;

  const ChooseCard({Key key, this.remaining}) : super(key: key);
  @override
  _ChooseCardState createState() => _ChooseCardState();
}

class _ChooseCardState extends State<ChooseCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 45),
          Text(
            'Select Your Card',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
          ),
          SizedBox(height: 15),
          Row(
            children: <Widget>[
              Expanded(
                child: RotatableCard(
                  remaining: widget.remaining,
                ),
              ),
              Expanded(
                child: RotatableCard(
                  remaining: widget.remaining,
                ),
              ),
            ],
          ),
          RotatableCard(
            remaining: widget.remaining,
          ),
        ],
      ),
    );
  }
}

class RotatableCard extends StatefulWidget {
  final int remaining;

  const RotatableCard({Key key, this.remaining}) : super(key: key);
  @override
  _RotatableCardState createState() => _RotatableCardState();
}

class _RotatableCardState extends State<RotatableCard> {
  var x;
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      onCardPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var rnd = Random();
        setState(() {
          x = rnd.nextInt(2);
          print(x);
        });

        int days;

        if (x == 1) {
          var rnd = Random();
          var y = 2592000 + rnd.nextInt(28944000);

          setState(() {
            days = widget.remaining + y;
          });

          prefs.setInt('days', days);
          prefs.setInt('new', days);
          var hours = y ~/ 3600;
          var mins = (y % 3600) ~/ 60;

          print('seconds -> $days \t hors -> $hours \t mins $mins');
          await ToastBar(
                  text: 'Your time extended by $hours Hours and $mins Minutes!',
                  color: Colors.blue)
              .show();

          //RestartWidget.restartApp(context);
          Timer(Duration(seconds: 1), () {
            Navigator.pop(context);
          });

          print('clicked' + days.toString());
        } else {
          var rnd = Random();
          var y = 3600 + rnd.nextInt(7200);

          setState(() {
            days = widget.remaining - y;
          });
          prefs.setInt('days', days);
          prefs.setInt('new', days);

          var hours = y ~/ 3600;
          var mins = (y % 3600) ~/ 60;
          await ToastBar(
                  text: 'Your time reduced by $hours Hours and $mins Minutes!',
                  color: Colors.red)
              .show();

          // RestartWidget.restartApp(context);
          Timer(Duration(seconds: 1), () {
            Navigator.pop(context);
          });
        }
      },
      front: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset('images/logo.png'),
          ),
        ),
        margin: EdgeInsets.all(12),
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 5)),
      ),
      back: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: x == 1
                ? Image.asset(
                    'images/angel.png',
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'images/devil.png',
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        margin: EdgeInsets.all(12),
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 5)),
      ),
    );
  }
}
