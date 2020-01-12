// Copyright 2020 Greenfrogs. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

// Draw a rect from start to end with the specified color
class RectPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;

  RectPainter(this.start, this.end, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint();
    paint.color = this.color;
    paint.strokeWidth = 5;
    canvas.drawRect(Rect.fromLTRB(start.dx, start.dy, end.dx, end.dy), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
