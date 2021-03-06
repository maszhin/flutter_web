// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter.examples.gallery/gallery/app.dart';

void main() {
  testWidgets('Gallery starts', (WidgetTester tester) async {
    await tester.pumpWidget(GalleryApp());
  });
}
