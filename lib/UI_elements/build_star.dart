import 'package:flutter/material.dart';

class BuildStarRaiting extends StatelessWidget {
  double rating;
  final color_star = const Color(0xFFEFCF01);

  BuildStarRaiting(this.rating);

  List<Widget> _buildStars(double rate, BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    int r1 = (rate / 2).toInt();
    double r2 = rate / 2 - r1;
    print(r1);
    print(r2);
    List<Widget> stars = [];
    for (int i = 1; i <= 5; ++i) {
      if (i <= r1) {
        stars.add(Container(
          height: deviceheight *0.04,
          child: FittedBox(
            child: Icon(
              Icons.star,
              color: color_star,
            ),
          ),
        ));
      } else if (i - r1 <= 1 && r2 >= 0.5) {
        stars.add(Container(
          height: deviceheight *0.04,
          child: FittedBox(
            child: Icon(
              Icons.star_half,
              color: color_star,
            ),
          ),
        ));
      } else {
        stars.add(Container(
          height: deviceheight *0.04,
          child: FittedBox(
            child: Icon(
              Icons.star_border,
              color: color_star,
            ),
          ),
        ));
      }
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildStars(rating, context),
      ),
    );
  }
}
