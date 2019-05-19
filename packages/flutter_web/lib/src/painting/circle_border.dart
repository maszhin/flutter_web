// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:flutter_ui/ui.dart';

import 'borders.dart';

/// A border that fits a circle within the available space.
///
/// Typically used with [ShapeDecoration] to draw a circle.
///
/// The [dimensions] assume that the border is being used in a square space.
/// When applied to a rectangular space, the border paints in the center of the
/// rectangle.
///
/// See also:
///
///  * [BorderSide], which is used to describe each side of the box.
///  * [Border], which, when used with [BoxDecoration], can also
///    describe a circle.
class CircleBorder extends ShapeBorder {
  /// Create a circle border.
  ///
  /// The [side] argument must not be null.
  // TODO(yjbanov): const asserts are broken in dart2js.
  const CircleBorder({this.side = BorderSide.none}); // : assert(side != null);

  /// The style of this border.
  final BorderSide side;

  @override
  EdgeInsetsGeometry get dimensions {
    return new EdgeInsets.all(side.width);
  }

  @override
  ShapeBorder scale(double t) => new CircleBorder(side: side.scale(t));

  @override
  ShapeBorder lerpFrom(ShapeBorder a, double t) {
    if (a is CircleBorder)
      return new CircleBorder(side: BorderSide.lerp(a.side, side, t));
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder lerpTo(ShapeBorder b, double t) {
    if (b is CircleBorder)
      return new CircleBorder(side: BorderSide.lerp(side, b.side, t));
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return new Path()
      ..addOval(new Rect.fromCircle(
        center: rect.center,
        radius: math.max(0.0, rect.shortestSide / 2.0 - side.width),
      ));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return new Path()
      ..addOval(new Rect.fromCircle(
        center: rect.center,
        radius: rect.shortestSide / 2.0,
      ));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        canvas.drawCircle(rect.center, (rect.shortestSide - side.width) / 2.0,
            side.toPaint());
    }
  }

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;
    final CircleBorder typedOther = other;
    return side == typedOther.side;
  }

  @override
  int get hashCode => side.hashCode;

  @override
  String toString() {
    return '$runtimeType($side)';
  }
}
