// ignore_for_file: inference_failure_on_instance_creation

import 'package:event_ddi/event_ddi.dart';
import 'package:event_ddi/src/data/event.dart';
import 'package:event_ddi/src/data/history.dart';
import 'package:event_ddi/src/enum/event_mode.dart';
import 'package:test/test.dart';

import '../clazz_mock/event_sender.dart';

void eventValidationTest() {
  group('DDI Event Validation tests', () {
    test('Validate data class', () async {
      void eventFunction(int value) => 0;
      void eventSep(int value) => 0;

      final ev = Event<int>(
          event: eventFunction,
          type: int,
          canUnsubscribe: true,
          priority: 0,
          mode: EventMode.normal);
      final evBase = Event<int>(
          event: eventFunction,
          type: int,
          canUnsubscribe: true,
          priority: 0,
          mode: EventMode.normal);
      final evS = Event<int>(
          event: eventSep,
          type: int,
          canUnsubscribe: true,
          priority: 0,
          mode: EventMode.normal);

      expect(ev == evBase, isTrue);
      expect(ev == evS, isFalse);
      expect(evS == evBase, isFalse);

      expect(ev.hashCode == evBase.hashCode, isTrue);
      expect(ev.hashCode == evS.hashCode, isFalse);
      expect(evS.hashCode == evBase.hashCode, isFalse);
    });

    test('Validate history class', () async {
      final ev = History<int>();

      expect(ev.redoStack.isEmpty, isTrue);
      expect(ev.undoStack.isEmpty, isTrue);

      ev.undoStack.add(1);
      ev.redoStack.add(1);

      expect(ev.undoStack.isEmpty, isFalse);
      expect(ev.redoStack.isEmpty, isFalse);
    });

    test('Fire event using EventSender mixin', () {
      int localValue = 0;
      void eventFunction(int value) => localValue += value;

      ddiEvent.subscribe<int>(eventFunction);

      expect(localValue, 0);

      final EventSender eventSender = EventSender()..run();

      expect(localValue, 1);
      expect(eventSender.state, localValue);

      ddiEvent.unsubscribe<int>(eventFunction);

      expect(ddiEvent.isRegistered<int>(), isFalse);

      eventSender.run();

      expect(localValue, 1);
    });
  });
}
