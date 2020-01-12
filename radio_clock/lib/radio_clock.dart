// Copyright 2020 Greenfrogs. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/line_painter.dart';
import 'package:digital_clock/scale_tick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

import 'scale_text.dart';

enum _Element {
  background,
  text,
  ticks,
  line,
}

final _lightTheme = {
  _Element.background: Colors.white,
  _Element.text: Colors.black,
  _Element.ticks: Color.fromRGBO(128, 128, 128, 0.85),
  _Element.line: Color.fromRGBO(255, 127, 0, 0.85),
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.ticks: Color.fromRGBO(245, 245, 245, 0.85),
  _Element.line: Color.fromRGBO(255, 127, 0, 0.85),
};

// A Radio Style Digital Clock
class RadioClock extends StatefulWidget {
  const RadioClock(this.model);

  final ClockModel model;

  @override
  _RadioClockState createState() => _RadioClockState();
}

class _RadioClockState extends State<RadioClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();

    // Remove UI elements (app bar, navigation bar)
    SystemChrome.setEnabledSystemUIOverlays([]);

    // Switch to landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void didUpdateWidget(RadioClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();

      // Update at 60Hz for a smooth animation
      _timer = Timer(
        Duration(milliseconds: 17),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final int minuteTicks = 7; // Max number of numbers to show for minutes/hours/days
    final int hourTicks = 5;
    final int dayTicks = 3;

    final colors = Theme.of(context).brightness == Brightness.light ? _lightTheme : _darkTheme;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 4; //Do not obscure ClockModel border

    // Ratio to the next minute, hour or day
    final double minuteOffset = -(_dateTime.second / 60 + _dateTime.millisecond / 1000 / 60);
    final double hourOffset = -(_dateTime.minute / 60 + _dateTime.second / 60 / 60);
    final double dayOffset = -(_dateTime.hour / 24 + _dateTime.minute / 60 / 24);

    // List of minutes to display
    List<String> minutes = new List<String>();
    for (DateTime dateTime = _dateTime.subtract(new Duration(minutes: ((minuteTicks + 2) / 2).floor()));
        dateTime.isBefore(_dateTime.add(new Duration(minutes: ((minuteTicks + 3) / 2).floor())));
        dateTime = dateTime.add(new Duration(minutes: 1))) {
      minutes.add(DateFormat('mm').format(dateTime));
    }

    // List of hours to display
    List<String> hours = new List<String>();
    for (DateTime dateTime = _dateTime.subtract(new Duration(hours: ((hourTicks + 2) / 2).floor()));
        dateTime.isBefore(_dateTime.add(new Duration(hours: ((hourTicks + 3) / 2).floor())));
        dateTime = dateTime.add(new Duration(hours: 1))) {
      hours.add(DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(dateTime));
    }

    List<String> days = new List<String>(); // The day in words (Wednesday)
    List<String> dates = new List<String>(); // The day in numbers (31, 01, ...)
    for (DateTime dateTime = _dateTime.subtract(new Duration(days: ((dayTicks + 2) / 2).floor()));
        dateTime.isBefore(_dateTime.add(new Duration(days: ((dayTicks + 3) / 2).floor())));
        dateTime = dateTime.add(new Duration(days: 1))) {
      days.add(DateFormat('EEEE').format(dateTime));
      dates.add(DateFormat('dd').format(dateTime));
    }

    // Works best on a 5:3 aspect ratio
    return Container(
      color: colors[_Element.background],
      child: Stack(
        children: <Widget>[
          ScaleText(Alignment(0, -0.9), dayTicks + 2, width / 2, dayOffset, TextStyle(color: colors[_Element.text], fontSize: height * 0.04, fontFamily: "Roboto"), dates),
          ScaleText(Alignment(0, -0.8), dayTicks + 2, width / 2, dayOffset, TextStyle(color: colors[_Element.text], fontSize: height * 0.08, fontFamily: "Roboto"), days),
          ScaleText(Alignment(0, 0), hourTicks + 2, width / 2, hourOffset, TextStyle(color: colors[_Element.text], fontSize: height * 0.18, fontFamily: "Roboto"), hours),
          ScaleTick(Alignment(0, 0), hourTicks + 2, width / 2, hourOffset + 0.5, colors[_Element.ticks], height * 0.04),
          ScaleTick(Alignment(0, 0), hourTicks + 2, width / 2, hourOffset + 0.25, colors[_Element.ticks], height * 0.02),
          ScaleTick(Alignment(0, 0), hourTicks + 2, width / 2, hourOffset - 0.25, colors[_Element.ticks], height * 0.02),
          ScaleText(Alignment(0, 0.85), minuteTicks + 2, width / 2, minuteOffset, TextStyle(color: colors[_Element.text], fontSize: height * 0.10, fontFamily: "Roboto"), minutes),
          ScaleTick(Alignment(0, 0.85), minuteTicks + 2, width / 2, minuteOffset + 0.5, colors[_Element.ticks], height * 0.02),
          CustomPaint(painter: LinePainter(Offset(width / 2, 0), Offset(width / 2, height), colors[_Element.line]))
        ],
      ),
    );
  }
}
