// Copyright 2020 Greenfrogs. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

// Draw a line from start to end with the specified color
class LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;

  LinePainter(this.start, this.end, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint();
    paint.color = this.color;
    paint.strokeWidth = 5;
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
