// Copyright 2020 Greenfrogs. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'scale.dart';

// Draws the text object at specific frequencies
class ScaleText extends Scale {
  TextStyle textStyle;
  List<String> text;
  double height;

  ScaleText(Alignment alignment, int count, double radius, double offset, this.textStyle, this.text, this.height)
      : super(alignment, count, radius, offset);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = new List();

    int i = 0;
    for (Alignment align in super.childAlignment(overflow: 2)) {
      Text textWidget = new Text(text[i++], textAlign: TextAlign.center, style: textStyle, overflow: TextOverflow.clip);
      widgets.add(new Transform.translate(offset: Offset(align.x * super.radius, 0), child: Center(child: textWidget)));
    }

    return Transform.translate(
        offset: Offset(
            super.alignment.x * super.radius, (super.alignment.y + 1) * height / 2 - (textStyle.fontSize * 0.75)),
        child: Container(
          height: textStyle.fontSize * 1.5,
          child: Stack(
            children: widgets,
          ),
        ));
  }
}
