import 'package:flutter/material.dart';
import 'package:flutter_app/models/crew.dart';

class CarDetailColumn extends StatelessWidget {
  final Color textColor;
  final Crew crew;
  const CarDetailColumn({
    Key key,
    this.textColor,
    this.crew
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (crew == null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
          "Car Name",
          style: Theme.of(context)
              .textTheme
              .title
              .apply(color: textColor ?? Colors.white, fontWeightDelta: 2),
        ),
          Text(
            "Year of Production",
            style: Theme.of(context)
                .textTheme
                .subhead
                .apply(color: textColor ?? Colors.white),
          ),

          Text(
            "Driver Name",
            style: Theme.of(context)
                .textTheme
                .subhead
                .apply(color: textColor ?? Colors.white),
          ),
          Text(
            "Crew number",
            style: Theme.of(context)
                .textTheme
                .subhead
                .apply(color: textColor ?? Colors.white),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            crew.car,
            style: Theme.of(context)
                .textTheme
                .title
                .apply(color: textColor ?? Colors.white, fontWeightDelta: 2),
          ),
          Text(
            crew.yearOfProduction,
            style: Theme.of(context)
                .textTheme
                .subhead
                .apply(color: textColor ?? Colors.white),
          ),

          Text(
            crew.driverName,
            style: Theme.of(context)
                .textTheme
                .subhead
                .apply(color: textColor ?? Colors.white),
          ),
          Text(
            crew.number.toString(),
            style: Theme.of(context)
                .textTheme
                .subhead
                .apply(color: textColor ?? Colors.white),
          ),
        ],
      );
    }
  }
}
