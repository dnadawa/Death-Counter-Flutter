import 'package:flutter/material.dart';

class CountDownText extends StatelessWidget {
  final String time;
  final String suffix;
  final Color color;

  const CountDownText({Key key, this.time, this.suffix, this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          time,
          style: TextStyle(
            color: color,
            fontSize: 70,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 80, 0),
          child: Text(
            suffix,
            style: TextStyle(color: color, fontSize: 25),
            textAlign: TextAlign.right,
          ),
        )
      ],
    );
  }
}
