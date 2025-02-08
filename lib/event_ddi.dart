library;

export 'src/core/ddi_event.dart' show DDIEvent, ddiEvent;
export 'src/extension/event_mode_extension.dart'
    if (dart.library.js_interop) 'src/extension/event_mode_extension_web.dart';
export 'src/features/event_lock.dart';
export 'src/mixin/ddi_event_sender.dart';
