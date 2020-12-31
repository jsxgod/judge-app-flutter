import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 25,
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(.3), BlendMode.srcOver),
                    image: NetworkImage(
                      "https://cdn.pixabay.com/photo/2016/02/13/13/11/cuba-1197800_960_720.jpg",
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border: null, shape: BoxShape.circle),
                          child: Icon(
                            Icons.directions_car,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 9.0,
                        ),
                        Text(
                          "OLDTIMERS",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .apply(color: Colors.white, fontWeightDelta: 2),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
