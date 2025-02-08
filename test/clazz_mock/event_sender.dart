import 'package:event_ddi/event_ddi.dart';

class EventSender with DDIEventSender<int> {
  void run() => fire(1);
}
