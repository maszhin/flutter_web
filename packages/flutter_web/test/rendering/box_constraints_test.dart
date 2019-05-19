// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/rendering.dart';
import '../flutter_test_alternative.dart';

void main() {
  test('BoxConstraints toString', () {
    expect(const BoxConstraints.expand().toString(), contains('biggest'));
    expect(const BoxConstraints().toString(), contains('unconstrained'));
    expect(const BoxConstraints.tightFor(width: 50.0).toString(),
        contains('w=50'));
  });

  test('BoxConstraints copyWith', () {
    const BoxConstraints constraints = BoxConstraints(
        minWidth: 3.0, maxWidth: 7.0, minHeight: 11.0, maxHeight: 17.0);
    BoxConstraints copy = constraints.copyWith();
    expect(copy, equals(constraints));
    copy = constraints.copyWith(
        minWidth: 13.0, maxWidth: 17.0, minHeight: 111.0, maxHeight: 117.0);
    expect(copy.minWidth, 13.0);
    expect(copy.maxWidth, 17.0);
    expect(copy.minHeight, 111.0);
    expect(copy.maxHeight, 117.0);
    expect(copy, isNot(equals(constraints)));
    expect(copy.hashCode, isNot(equals(constraints.hashCode)));
  });

  test('BoxConstraints operators', () {
    const BoxConstraints constraints = BoxConstraints(
        minWidth: 3.0, maxWidth: 7.0, minHeight: 11.0, maxHeight: 17.0);
    BoxConstraints copy = constraints * 2.0;
    expect(copy.minWidth, 6.0);
    expect(copy.maxWidth, 14.0);
    expect(copy.minHeight, 22.0);
    expect(copy.maxHeight, 34.0);
    expect(copy / 2.0, equals(constraints));
    copy = constraints ~/ 2.0;
    expect(copy.minWidth, 1.0);
    expect(copy.maxWidth, 3.0);
    expect(copy.minHeight, 5.0);
    expect(copy.maxHeight, 8.0);
    copy = constraints % 3.0;
    expect(copy.minWidth, 0.0);
    expect(copy.maxWidth, 1.0);
    expect(copy.minHeight, 2.0);
    expect(copy.maxHeight, 2.0);
  });

  test('BoxConstraints lerp', () {
    expect(BoxConstraints.lerp(null, null, 0.5), isNull);
    const BoxConstraints constraints = BoxConstraints(
        minWidth: 3.0, maxWidth: 7.0, minHeight: 11.0, maxHeight: 17.0);
    BoxConstraints copy = BoxConstraints.lerp(null, constraints, 0.5);
    expect(copy.minWidth, 1.5);
    expect(copy.maxWidth, 3.5);
    expect(copy.minHeight, 5.5);
    expect(copy.maxHeight, 8.5);
    copy = BoxConstraints.lerp(constraints, null, 0.5);
    expect(copy.minWidth, 1.5);
    expect(copy.maxWidth, 3.5);
    expect(copy.minHeight, 5.5);
    expect(copy.maxHeight, 8.5);
    copy = BoxConstraints.lerp(
        const BoxConstraints(
            minWidth: 13.0, maxWidth: 17.0, minHeight: 111.0, maxHeight: 117.0),
        constraints,
        0.2);
    expect(copy.minWidth, 11.0);
    expect(copy.maxWidth, 15.0);
    expect(copy.minHeight, 91.0);
    expect(copy.maxHeight, 97.0);
  });

  test('BoxConstraints lerp with unbounded width', () {
    const BoxConstraints constraints1 = BoxConstraints(
      minWidth: double.infinity,
      maxWidth: double.infinity,
      minHeight: 10.0,
      maxHeight: 20.0,
    );
    const BoxConstraints constraints2 = BoxConstraints(
      minWidth: double.infinity,
      maxWidth: double.infinity,
      minHeight: 20.0,
      maxHeight: 30.0,
    );
    const BoxConstraints constraints3 = BoxConstraints(
      minWidth: double.infinity,
      maxWidth: double.infinity,
      minHeight: 15.0,
      maxHeight: 25.0,
    );
    expect(BoxConstraints.lerp(constraints1, constraints2, 0.5), constraints3);
  });

  test('BoxConstraints lerp with unbounded height', () {
    const BoxConstraints constraints1 = BoxConstraints(
      minWidth: 10.0,
      maxWidth: 20.0,
      minHeight: double.infinity,
      maxHeight: double.infinity,
    );
    const BoxConstraints constraints2 = BoxConstraints(
      minWidth: 20.0,
      maxWidth: 30.0,
      minHeight: double.infinity,
      maxHeight: double.infinity,
    );
    const BoxConstraints constraints3 = BoxConstraints(
      minWidth: 15.0,
      maxWidth: 25.0,
      minHeight: double.infinity,
      maxHeight: double.infinity,
    );
    expect(BoxConstraints.lerp(constraints1, constraints2, 0.5), constraints3);
  });

  test('BoxConstraints lerp from bounded to unbounded', () {
    const BoxConstraints constraints1 = BoxConstraints(
      minWidth: double.infinity,
      maxWidth: double.infinity,
      minHeight: double.infinity,
      maxHeight: double.infinity,
    );
    const BoxConstraints constraints2 = BoxConstraints(
      minWidth: 20.0,
      maxWidth: 30.0,
      minHeight: double.infinity,
      maxHeight: double.infinity,
    );
    const BoxConstraints constraints3 = BoxConstraints(
      minWidth: double.infinity,
      maxWidth: double.infinity,
      minHeight: 20.0,
      maxHeight: 30.0,
    );
    expect(() => BoxConstraints.lerp(constraints1, constraints2, 0.5),
        throwsA(isInstanceOf<AssertionError>()));
    expect(() => BoxConstraints.lerp(constraints1, constraints3, 0.5),
        throwsA(isInstanceOf<AssertionError>()));
    expect(() => BoxConstraints.lerp(constraints2, constraints3, 0.5),
        throwsA(isInstanceOf<AssertionError>()));
  });

  test('BoxConstraints normalize', () {
    const BoxConstraints constraints = BoxConstraints(
        minWidth: 3.0, maxWidth: 2.0, minHeight: 11.0, maxHeight: 18.0);
    final BoxConstraints copy = constraints.normalize();
    expect(copy.minWidth, 3.0);
    expect(copy.maxWidth, 3.0);
    expect(copy.minHeight, 11.0);
    expect(copy.maxHeight, 18.0);
  });
}
