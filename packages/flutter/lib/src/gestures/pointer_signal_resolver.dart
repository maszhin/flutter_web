// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

import 'events.dart';

/// The callback to register with a [PointerSignalResolver] to express
/// interest in a pointer signal event.
typedef PointerSignalResolvedCallback = void Function(PointerSignalEvent event);

/// An resolver for pointer signal events.
///
/// Objects interested in a [PointerSignalEvent] should register a callback to
/// be called if they should handle the event. The resolver's purpose is to
/// ensure that the same pointer signal is not handled by multiple objects in
/// a hierarchy.
///
/// Pointer signals are immediate, so unlike a gesture arena it always resolves
/// at the end of event dispatch. The first callback registered will be the one
/// that is called.
class PointerSignalResolver {
  PointerSignalResolvedCallback _firstRegisteredCallback;

  PointerSignalEvent _currentEvent;

  /// Registers interest in handling [event].
  void register(
      PointerSignalEvent event, PointerSignalResolvedCallback callback) {
    assert(event != null);
    assert(callback != null);
    assert(_currentEvent == null || _currentEvent == event);
    if (_firstRegisteredCallback != null) {
      return;
    }
    _currentEvent = event;
    _firstRegisteredCallback = callback;
  }

  /// Resolves the event, calling the first registered callback if there was
  /// one.
  ///
  /// Called after the framework has finished dispatching the pointer signal
  /// event.
  void resolve(PointerSignalEvent event) {
    if (_firstRegisteredCallback == null) {
      assert(_currentEvent == null);
      return;
    }
    assert(_currentEvent == event);
    try {
      _firstRegisteredCallback(event);
    } catch (exception, stack) {
      FlutterError.reportError(FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'gesture library',
          context: 'while resolving a PointerSignalEvent',
          informationCollector: (StringBuffer information) {
            information.writeln('Event:');
            information.write('  $event');
          }));
    }
    _firstRegisteredCallback = null;
    _currentEvent = null;
  }
}
