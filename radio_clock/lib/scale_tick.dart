// Copyright 2020 Greenfrogs. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:digital_clock/line_painter.dart';
import 'package:flutter/material.dart';

import 'scale.dart';

// Draws the tick object at specific frequencies
class ScaleTick extends Scale {
  final Color color;
  final double length;

  ScaleTick(Alignment alignment, int count, double radius, double offset, this.color, this.length)
      : super(alignment, count, radius, offset);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = new List();

    for (Alignment align in super.childAlignment(overflow: 2)) {
      CustomPaint paintWidget =
          CustomPaint(painter: LinePainter(Offset(0, -this.length / 2), Offset(0, this.length / 2), this.color));
      widgets
          .add(new Transform.translate(offset: Offset(align.x * super.radius, 0), child: Center(child: paintWidget)));
    }

    return Transform.translate(
      offset: Offset(super.alignment.x * super.radius, super.alignment.y * MediaQuery.of(context).size.height / 2),
      child: Stack(
        children: widgets,
      ),
    );
  }
}
