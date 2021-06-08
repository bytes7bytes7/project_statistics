import 'package:flutter/material.dart';

class BookmarkClipper extends CustomClipper<Path> {
  BookmarkClipper({
    @required this.ratio,
    @required this.offset,
  });

  final double ratio;
  final double offset;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.width * ratio);
    path.lineTo(size.width * ratio, 0);
    path.lineTo(size.width * ratio + offset, 0);
    path.lineTo(0, size.width * ratio + offset);
    path.lineTo(0, size.height * ratio);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    /*
    Return true if you need to change orientation
     */
    return true;
  }
}
