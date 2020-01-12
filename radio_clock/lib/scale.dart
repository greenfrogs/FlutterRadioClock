// Copyright 2020 Greenfrogs. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

// An abstract class for drawing an object at speicfic frequencies across a canvas with the childAlignment iterator.
abstract class Scale extends StatelessWidget {
  final Alignment alignment;
  final int count;
  final double radius;
  final double offset;

  Scale(this.alignment, this.count, this.radius, this.offset);

  Iterable<Alignment> childAlignment({overflow = 0}) sync* {
    double d = 2 / (count - 1 - overflow);
    for (int i = 0; i < count; i++) {
      yield new Alignment((-1 - d * overflow / 2) + i * d + offset / (count - 1 - overflow) * 2, 0);
    }
  }

  @override
  Widget build(BuildContext context);
}
