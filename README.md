# Event DDI Package



<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

[![pub package](https://img.shields.io/pub/v/event_ddi.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/event_ddi)
[![CI](https://img.shields.io/github/actions/workflow/status/Willian199/event_ddi/dart.yml?branch=master&logo=github-actions&logoColor=white)](https://github.com/Willian199/event_ddi/actions)
[![Coverage Status](https://coveralls.io/repos/github/Willian199/event_ddi/badge.svg?branch=master)](https://coveralls.io/github/Willian199/event_ddi?branch=master)
[![Last Commits](https://img.shields.io/github/last-commit/Willian199/event_ddi?logo=git&logoColor=white)](https://github.com/Willian199/event_ddi/commits/master)
[![Issues](https://img.shields.io/github/issues/Willian199/event_ddi?logo=github&logoColor=white)](https://github.com/Willian199/event_ddi/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/Willian199/event_ddi?logo=github&logoColor=white)](https://github.com/Willian199/event_ddi/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/Willian199/event_ddi?logo=github&logoColor=white)](https://github.com/Willian199/event_ddi)
[![License](https://img.shields.io/github/license/Willian199/event_ddi?logo=open-source-initiative&logoColor=green)](https://github.com/Willian199/event_ddi/blob/master/LICENSE)


A Dart package designed for event management. It provides tools to create, destroy, and listen to events, making it easier to decouple different parts of your application and handle communication efficiently.

## Features

- Event Management: Create, manage, and destroy events effortlessly.

- Flexible Subscriptions: Support for synchronous, asynchronous, and isolate-based event subscriptions.

- Streamlined Communication: Decouple components by leveraging powerful event-based communication.

- Replay and Undo: Support for event replay and undo functionalities.

- Qualifiers: Use qualifiers to distinguish between different event types.

## Packages

- [Flutter DDI](https://pub.dev/packages/flutter_ddi) - This package is designed to facilitate the dependency injection process in your Flutter application.
- [Dart DDI](https://pub.dev/packages/dart_ddi) - This package is a robust and flexible dependency injection mechanism.

## Projects

- [Budgetopia](https://github.com/Willian199/budgetopia) - An intuitive personal finance app that helps users track expenses.


## Creating and Managing Events
The Events follow a straightforward flow. Functions or methods `subscribe` to specific events using the subscribe method of the `DDIEvent` class. Events are fired using the `fire` or `fireWait` methods, triggering the execution of all subscribed callbacks. Subscribed callbacks are then executed, handling the event data and performing any specified tasks. Subscriptions can be removed using the `unsubscribe` function.

### Subscribing an Event
When subscribing to an event, you have the option to choose from three different types of subscriptions:

- `DDIEvent.instance.subscribe` It's the common type, working as a simples callback.
- `DDIEvent.instance.subscribeAsync` Runs the callback as a Future.
- `DDIEvent.instance.subscribeIsolate` Runs as a Isolate.

#### Subscribe
The common subscription type, `subscribe`, functions as a simple callback. It allows you to respond to events in a synchronous manner, making it suitable for most scenarios.

Obs: If you register an event that uses async and await, it Won't be possible to wait even using `fireWait`. For this scenario, use `subscribeAsync`.

Parameters:

- `event:` The callback function to be executed when the event is fired.
- `qualifier:` Optional qualifier name to distinguish between different events of the same type.
- `canRegister:` A FutureOr<bool> function that if returns true, allows the subscription to proceed.
- `canUnsubscribe:` Indicates if the event can be unsubscribe. Ignored if `autoRun` is used.
- `priority:` Priority of the subscription relative to other subscriptions (lower values indicate higher priority). Ignored if `autoRun` is used.
- `unsubscribeAfterFire:` If true, the subscription will be automatically removed after the first time the event is fired. Ignored if `autoRun` is used.
- `lock`: Indicates if the event should be locked. Running only one event simultaneously. Cannot be used in combination with `autoRun`.
- `onError`: The callback function to be executed when an error occurs.
- `onComplete`: The callback function to be executed when the event is completed. It's called even if an error occurs.
- `expirationDuration`: The duration after which the subscription will be automatically removed.
- `retryInterval`: Adds the ability to automatically retry the event after the interval specified.
- `defaultValue`: The default value to be used when the event is fired. Required if `retryInterval` is used.
- `maxRetry`: The maximum number of times the subscription will be automatically fired if `retryInterval` is used.
     * Can be used in combination with `autoRun` and `onError`.
     * If `maxRetry` is 0 and `autoRun` is true, will run forever.
     * If `maxRetry` is greater than 0 and `autoRun` is true, the subscription will be removed when the maximum number of retries is reached.
     * If `maxRetry` is greater than 0, `autoRun` is false and `onError` is used, the subscription will stop retrying when the maximum number is reached.
     * If `expirationDuration` is used, the subscription will be removed when the first rule is met, either when the expiration duration is reached or when the maximum number of retries is reached.
- `autoRun`: If true, the event will run automatically when the subscription is created.
     * Only one event is allowed.
     * `canUnsubscribe` is ignored.
     * `unsubscribeAfterFire` is ignored.
     * `priority` is ignored.
     * Cannot be used in combination with `lock`.
     * Requires the `defaultValue` parameter.
     * If `maxRetry` is 0, will run forever.
- `filter`: Allows you to filter events based on their value. Only events when the filter returns true will be fired.

```dart
void myEvent(String message) {
    print('Event received: $message');
}

DDIEvent.instance.subscribe<String>(
  myEvent,
  qualifier: 'exampleEvent',
  canRegister: () => true,
  canUnsubscribe: true,
  priority: 0
  unsubscribeAfterFire: false,
  lock: false,
  onError: (Object? error, StackTrace stacktrace, String valor){},
  onComplete: (){},
  expirationDuration: const Duration(seconds: 5),
  retryInterval: const Duration(seconds: 4),
  defaultValue: 'defaultValue',
  maxRetry: 1,
  autoRun: false,
  filter: (value) => true,
);
```

#### Subscribe Async
The `subscribeAsync` type runs the callback as a Future, allowing for asynchronous event handling. Making it suitable for scenarios where asynchronous execution is needed without waiting for completion.
Note that it not be possible to await this type of subscription.

Obs: If you want to await for the event to be completed, fire it using `fireWait`.

Parameters are the same as for `subscribe`.

```dart
void myEvent(String message) {
    print('Event received: $message');
}

DDIEvent.instance.subscribeAsync<String>(
  myEvent,
  qualifier: 'exampleEvent',
  canRegister: () => true,
  canUnsubscribe: true,
  unsubscribeAfterFire: false,
  lock: false,
  onError: (Object? error, StackTrace stacktrace, String valor){},
  onComplete: (){},
  expirationDuration: const Duration(seconds: 5),
  retryInterval: const Duration(seconds: 4),
  defaultValue: 'defaultValue',
  maxRetry: 1,
  autoRun: false,
  filter: (value) => true,
);
```

#### Subscribe Isolate
The `subscribeIsolate` type runs the callback in a separate isolate, enabling concurrent event handling. This is particularly useful for scenarios where you want to execute the event in isolation, avoiding potential interference with the main application flow.

Parameters are the same as for `subscribe`.

```dart
void myEvent(String message) {
    print('Event received: $message');
}

DDIEvent.instance.subscribeIsolate<String>(
  myEvent,
  qualifier: 'exampleEvent',
  canRegister: () => true,
  canUnsubscribe: true,
  unsubscribeAfterFire: false,
  lock: false,
  onError: (Object? error, StackTrace stacktrace, String valor){},
  onComplete: (){},
  expirationDuration: const Duration(seconds: 5),
  retryInterval: const Duration(seconds: 4),
  defaultValue: 'defaultValue',
  maxRetry: 1,
  autoRun: false,
  filter: (value) => true,
);
```

### Unsubscribing an Event

To unsubscribe from an event, use the `unsubscribe` function:

```dart
DDIEvent.instance.unsubscribe<String>(
  myEvent,
  qualifier: 'exampleEvent',
);
```

### Firing an Event

To fire an event, use the `fire` or `fireWait` function. Using `fireWait` makes it possible to wait for all events to complete.

- `qualifier:` Optional qualifier name to distinguish between different events of the same type.
- `canReplay:` A boolean that indicates if the value can `undo`. The max history allowed is 5 events.

```dart
DDIEvent.instance.fire('Hello, Dart DDI!', qualifier: 'exampleEvent', canReplay: false);

await DDIEvent.instance.fireWait('Hello, Dart DDI!', qualifier: 'exampleEvent', canReplay: true);
```

### Undo an Event

The `undo` method reverts the last fired event if it was marked with canReplay: true. The max history allowed is 5 events.

```dart
DDIEvent.instance.undo<EventType>(qualifier: 'exampleEvent');
```

### Redo an Event

The `redo` method re-executes the last `undone` event if it exists. This allows users to redo actions that were previously undone.

- Requires to call `undo` first.
- After `fire` or `fireWait`, the `redo` history is cleared.

```dart
DDIEvent.instance.redo<EventType>(qualifier: 'exampleEvent');
```

### Clear Event History

The `clearHistory` method clears the entire history of fired events, removing the ability to `undo` or `redo` any prior events.

```dart
DDIEvent.instance.clearHistory<EventType>(qualifier: 'exampleEvent');
```

### Get Current Value

The `getValue` method retrieves the current value of the last event fired. This can be helpful for accessing the state of the last event without firing it again.`

```dart
final EventType value = DDIEvent.instance.getValue<EventType>(qualifier: 'exampleEvent');
```

### `DDIEventSender` Mixins

The `DDIEventSender` mixins are designed to simplify the process of sending events values to listeners. They provide a convenient method fire to send the specified value to an event or stream.

#### Example Usage:
```dart
class MyEvent with DDIEventSender<String> {
  void businessLogic() {
    fire('Hello World');
  }
}
```

## Events Considerations

When using the Event System, consider the following:

`Event Granularity`: Design events with appropriate granularity to ensure they represent meaningful actions or states in the application.

`Modularity`: Keep events and their handlers modular and self-contained.

`Single Responsibility`: Ensure each event and its handler have a single responsibility.

`Possible Problems`: Be cautious of potential issues such as race conditions and excessive use of isolate-based event handling, which may impact performance.

`Unnecessary Locking`: Applying locks to events unnecessarily may hinder the application's responsiveness. Use locking only when essential to prevent conflicting event executions.

`Event Looping`: Carefully manage scenarios where events trigger further events, as this can lead to infinite loops or excessive event cascades.

See the considerations about [Qualifiers](#considerations).

## Use Cases

`Application Lifecycle`: Manage events related to the application's lifecycle.

`Data Synchronization`: Handle data synchronization events between local and remote data sources.

`Background Task`: Coordinate background tasks and events for efficient task execution.

`Custom Event Bus`: Build a custom event bus for inter-component communication, allowing different parts of the application to communicate without tight coupling.

`Notifications`: Implement notifications for updates in various parts of the application, such as new messages, alerts, or data changes.
