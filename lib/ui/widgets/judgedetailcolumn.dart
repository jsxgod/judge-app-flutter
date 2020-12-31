import 'package:flutter/material.dart';

class JudgeDetailColumn extends StatelessWidget {
  final Color textColor;
  const JudgeDetailColumn({
    Key key,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Name",
          style: Theme.of(context)
              .textTheme
              .title
              .apply(color: textColor ?? Colors.white, fontWeightDelta: 2),
        ),
        Text(
          "Event",
          style: Theme.of(context)
              .textTheme
              .subhead
              .apply(color: textColor ?? Colors.white),
        ),
      ],
    );
  }
}
