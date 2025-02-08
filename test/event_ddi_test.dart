import 'event_test/event_filter_test.dart';
import 'event_test/event_lock_test.dart';
import 'event_test/event_test.dart';
import 'event_test/event_undo_redo_test.dart';
import 'event_test/event_validade_test.dart';
import 'event_test/timer_events_test.dart';

void main() {
  eventValidationTest();
  eventTest();
  eventFilterTest();
  eventLockTest();
  eventDurationTests();
  eventUndoRedoTest();
}
