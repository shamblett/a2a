/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

@TestOn('vm')
library;

import 'package:test/test.dart';

import 'package:a2a/src/server/a2a_server.dart';

void main() {
  const taskId = 'Test Task Id';
  const contextId = 'Test Context Id';
  const messageId = 'Message-12345';
  const artifactId = 'Artifact-3456';
  final testTask = A2ATask()
    ..contextId = contextId
    ..id = taskId
    ..history = []
    ..artifacts = []
    ..status = (A2ATaskStatus()..state = A2ATaskState.unknown);

  final testMessage = (A2AMessage()
    ..taskId = taskId
    ..contextId = contextId
    ..messageId = messageId);

  final testTaskUpdate = A2ATaskStatusUpdateEvent()
    ..status = (A2ATaskStatus()
      ..state = A2ATaskState.unknown
      ..message = testMessage)
    ..contextId = contextId
    ..taskId = taskId
    ..end = false;

  final testArtifact = A2AArtifact()..artifactId = artifactId;

  final testArtifactUpdate = A2ATaskArtifactUpdateEvent()
    ..taskId = taskId
    ..contextId = contextId
    ..artifact = testArtifact;

  final rq = A2ARequestContext(testMessage, testTask, [], taskId, contextId);

  test('Construction', () {
    final ev = A2ADefaultExecutionEventBus();
    final ec = A2AExecutorConstructor(rq, ev);
    expect(ec.contextId, contextId);
    expect(ec.taskId, taskId);
    expect(ec.userMessage.messageId, messageId);
    expect(ec.existingTask?.id, taskId);
    expect(ec.referencedTasks, []);
    expect(ec.isTaskCancelled, isFalse);
  });
  group('Parts', () {
    test('Text', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      final part = ec.createTextPart('The text', metadata: {'First': 1});
      expect(part.text, 'The text');
      expect(part.metadata, {'First': 1});
    });
    test('Data', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      final part = ec.createDataPart({'The data': 15}, metadata: {'First': 1});
      expect(part.data, {'The data': 15});
      expect(part.metadata, {'First': 1});
    });
    test('File - Bytes', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      final part = ec.createBytesFilePart(
        'The bytes',
        name: 'The name',
        metadata: {'First': 1},
        mimetype: 'Mime',
      );
      expect(part.file is A2AFileWithBytes, isTrue);
      final bPart = part.file as A2AFileWithBytes;
      expect(bPart.bytes, 'The bytes');
      expect(bPart.name, 'The name');
      expect(bPart.mimeType, 'Mime');
      expect(part.metadata, {'First': 1});
    });
    test('File - Url', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      final part = ec.createUrlFilePart(
        'The uri',
        name: 'The name',
        metadata: {'First': 1},
        mimetype: 'Mime',
      );
      expect(part.file is A2AFileWithUri, isTrue);
      final bPart = part.file as A2AFileWithUri;
      expect(bPart.uri, 'The uri');
      expect(bPart.name, 'The name');
      expect(bPart.mimeType, 'Mime');
      expect(part.metadata, {'First': 1});
    });
  });
  group('Publish', () {
    test('Cancel Task', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      ec.cancelTask = '1234';
      expect(ec.isTaskCancelled, isFalse);
      ec.cancelTask = taskId;
      expect(ec.isTaskCancelled, isTrue);
    });
    test('Initial Task Update - default', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATask, isTrue);
        final update = event as A2ATask;
        expect(update.contextId, contextId);
        expect(update.id, taskId);
        expect(update.status?.state, A2ATaskState.submitted);
      }));
      ec.publishInitialTaskUpdate();
    });
    test('Initial Task Update - user supplied', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATask, isTrue);
        final update = event as A2ATask;
        expect(update.contextId, contextId);
        expect(update.id, taskId);
        expect(update.status?.state, A2ATaskState.unknown);
      }));
      ec.initialTaskUpdate = testTask;
      ec.publishInitialTaskUpdate();
    });
    test('Working Task Update - default', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATaskStatusUpdateEvent, isTrue);
        final update = event as A2ATaskStatusUpdateEvent;
        expect(update.contextId, contextId);
        expect(update.taskId, taskId);
        expect(update.status?.state, A2ATaskState.working);
      }));
      ec.publishWorkingTaskUpdate();
    });
    test('Working Task Update - user supplied', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATaskStatusUpdateEvent, isTrue);
        final update = event as A2ATaskStatusUpdateEvent;
        expect(update.contextId, contextId);
        expect(update.taskId, taskId);
        expect(update.status?.state, A2ATaskState.unknown);
      }));
      ec.workingTaskUpdate = testTaskUpdate;
      ec.publishWorkingTaskUpdate();
    });
    test('Final Task Update - default', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      final message = ec.createMessage(
        'Message id',
        extensions: ['An extension'],
        metadata: {'First': 1},
        parts: [A2ATextPart()..text = 'The text'],
      );
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATaskStatusUpdateEvent, isTrue);
        final update = event as A2ATaskStatusUpdateEvent;
        expect(update.contextId, contextId);
        expect(update.taskId, taskId);
        expect(update.status?.state, A2ATaskState.completed);
        expect(update.end, isTrue);
        expect((update.status?.message as A2AMessage).messageId, 'Message id');
      }));
      ec.publishFinalTaskUpdate(message: message);
    });
    test('Final Task Update - user supplied', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATaskStatusUpdateEvent, isTrue);
        final update = event as A2ATaskStatusUpdateEvent;
        expect(update.contextId, contextId);
        expect(update.taskId, taskId);
        expect(update.status?.state, A2ATaskState.unknown);
        expect((update.status?.message as A2AMessage).messageId, messageId);
      }));
      ec.finalTaskUpdate = testTaskUpdate;
      ec.publishFinalTaskUpdate();
    });
    test('Failed Task Update - default', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      final message = ec.createMessage(
        'Message id',
        extensions: ['An extension'],
        metadata: {'First': 1},
        parts: [A2ATextPart()..text = 'The text'],
      );
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATaskStatusUpdateEvent, isTrue);
        final update = event as A2ATaskStatusUpdateEvent;
        expect(update.contextId, contextId);
        expect(update.taskId, taskId);
        expect(update.status?.state, A2ATaskState.failed);
        expect(update.end, isTrue);
        expect((update.status?.message as A2AMessage).messageId, 'Message id');
      }));
      ec.publishFailedTaskUpdate(message: message);
    });
    test('Failed Task Update - user supplied', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATaskStatusUpdateEvent, isTrue);
        final update = event as A2ATaskStatusUpdateEvent;
        expect(update.contextId, contextId);
        expect(update.taskId, taskId);
        expect(update.status?.state, A2ATaskState.unknown);
        expect((update.status?.message as A2AMessage).messageId, messageId);
      }));
      ec.failedTaskUpdate = testTaskUpdate;
      ec.publishFailedTaskUpdate();
    });
    test('Cancel Task Update - default', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATaskStatusUpdateEvent, isTrue);
        final update = event as A2ATaskStatusUpdateEvent;
        expect(update.contextId, contextId);
        expect(update.taskId, taskId);
        expect(update.status?.state, A2ATaskState.canceled);
        expect(update.end, isTrue);
      }));
      ec.publishCancelTaskUpdate();
    });
    test('Cancel Task Update - user supplied', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATaskStatusUpdateEvent, isTrue);
        final update = event as A2ATaskStatusUpdateEvent;
        expect(update.contextId, contextId);
        expect(update.taskId, taskId);
        expect(update.status?.state, A2ATaskState.unknown);
      }));
      ec.cancelTaskUpdate = testTaskUpdate;
      ec.publishCancelTaskUpdate();
    });
    test('Input Required Task Update - default', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      final message = ec.createMessage(
        'Message id',
        extensions: ['An extension'],
        metadata: {'First': 1},
        parts: [A2ATextPart()..text = 'The text'],
      );
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATaskStatusUpdateEvent, isTrue);
        final update = event as A2ATaskStatusUpdateEvent;
        expect(update.contextId, contextId);
        expect(update.taskId, taskId);
        expect(update.status?.state, A2ATaskState.inputRequired);
        expect(update.end, isFalse);
        expect((update.status?.message as A2AMessage).messageId, 'Message id');
      }));
      ec.publishInputRequiredTaskUpdate(message: message);
    });
    test('Input Required Task Update - user supplied', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATaskStatusUpdateEvent, isTrue);
        final update = event as A2ATaskStatusUpdateEvent;
        expect(update.contextId, contextId);
        expect(update.taskId, taskId);
        expect(update.status?.state, A2ATaskState.unknown);
        expect((update.status?.message as A2AMessage).messageId, messageId);
      }));
      ec.inputRequiredTaskUpdate = testTaskUpdate;
      ec.publishInputRequiredTaskUpdate();
    });
    test('Task Update - user supplied state', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATaskStatusUpdateEvent, isTrue);
        final update = event as A2ATaskStatusUpdateEvent;
        expect(update.contextId, contextId);
        expect(update.taskId, taskId);
        expect(update.end, isTrue);
        expect(update.status?.state, A2ATaskState.authRequired);
        expect((update.status?.message as A2AMessage).messageId, messageId);
      }));
      ec.publishTaskUpdate(
        A2ATaskState.authRequired,
        message: testMessage,
        end: true,
      );
    });
    test('Artifact Update - default', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      final artifact = ec.createArtifact(
        'The id',
        name: 'The name',
        description: 'The description',
        extensions: ['An extension'],
        metadata: {'First': 1},
        parts: [A2ATextPart()..text = 'The text'],
      );
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATaskArtifactUpdateEvent, isTrue);
        final update = event as A2ATaskArtifactUpdateEvent;
        expect(update.contextId, contextId);
        expect(update.taskId, taskId);
        expect(update.artifact == artifact, isTrue);
        expect(update.lastChunk, isTrue);
        expect(update.append, isTrue);
      }));
      ec.publishArtifactUpdate(artifact, append: true, lastChunk: true);
    });
    test('Artifact Update - user supplied', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      final artifact = ec.createArtifact(
        'The id',
        name: 'The name',
        description: 'The description',
        extensions: ['An extension'],
        metadata: {'First': 1},
        parts: [A2ATextPart()..text = 'The text'],
      );
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATaskArtifactUpdateEvent, isTrue);
        final update = event as A2ATaskArtifactUpdateEvent;
        expect(update.contextId, contextId);
        expect(update.taskId, taskId);
        expect(update.artifact == artifact, isFalse);
      }));
      ec.artifactUpdate = testArtifactUpdate;
      ec.publishArtifactUpdate(artifact, append: true, lastChunk: true);
    });
    test('User object', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2AMessage, isTrue);
      }));
      ec.publishUserObject(A2AMessage());
    });
  });
  group('Misc', () {
    test('Delay', () async {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      expect(await ec.delay(500), isFalse);
      ec.cancelTask = taskId;
      expect(await ec.delay(500), isTrue);
    });
    test('Uuid', () async {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      expect(ec.v4Uuid.length, 36);
    });
    test('Create Artifact', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      final artifact = ec.createArtifact(
        'The id',
        name: 'The name',
        description: 'The description',
        extensions: ['An extension'],
        metadata: {'First': 1},
        parts: [A2ATextPart()..text = 'The text'],
      );
      expect(artifact.metadata, {'First': 1});
      expect(artifact.extensions, ['An extension']);
      expect(artifact.description, 'The description');
      expect(artifact.artifactId, 'The id');
      expect(artifact.name, 'The name');
      expect((artifact.parts.first as A2ATextPart).text, 'The text');
    });
    test('Create Message', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      final message = ec.createMessage(
        'Message id',
        extensions: ['An extension'],
        metadata: {'First': 1},
        parts: [A2ATextPart()..text = 'The text'],
      );
      expect(message.metadata, {'First': 1});
      expect(message.extensions, ['An extension']);
      expect(message.messageId, 'Message id');
      expect((message.parts?.first as A2ATextPart).text, 'The text');
      expect(message.role, 'agent');
    });
    test('Has Task been cancelled  - cancelled', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      bool evCalled = false;
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        expect(event is A2ATaskStatusUpdateEvent, isTrue);
        evCalled = true;
      }));
      ec.cancelTask = taskId;
      final res = ec.hasTaskBeenCancelled();
      expect(res, isTrue);
      expect(evCalled, isTrue);
    });
    test('Has Task been cancelled - not cancelled', () {
      final ev = A2ADefaultExecutionEventBus();
      final ec = A2AExecutorConstructor(rq, ev);
      bool evCalled = false;
      ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
        evCalled = true;
      }));
      final res = ec.hasTaskBeenCancelled();
      expect(res, isFalse);
      expect(evCalled, isFalse);
    });
  });
}
