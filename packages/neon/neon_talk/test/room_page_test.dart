import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/testing.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_talk/l10n/localizations.dart';
import 'package:neon_talk/src/blocs/room.dart';
import 'package:neon_talk/src/pages/room.dart';
import 'package:neon_talk/src/theme.dart';
import 'package:neon_talk/src/widgets/message.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/spreed.dart' as spreed;
import 'package:rxdart/rxdart.dart';

import 'testing.dart';

void main() {
  late spreed.Room room;
  late TalkRoomBloc bloc;

  setUpAll(() {
    KeyboardVisibilityTesting.setVisibilityForTesting(true);
  });

  setUp(() {
    FakeNeonStorage.setup();
  });

  setUp(() {
    room = MockRoom();
    when(() => room.token).thenReturn('abcd');
    when(() => room.displayName).thenReturn('test');
    when(() => room.readOnly).thenReturn(0);
    when(() => room.isCustomAvatar).thenReturn(false);
    when(() => room.type).thenReturn(spreed.RoomType.group.value);

    bloc = MockRoomBloc();
    when(() => bloc.errors).thenAnswer((_) => StreamController<Object>().stream);
    when(() => bloc.room).thenAnswer((_) => BehaviorSubject.seeded(Result.success(room)));
    when(() => bloc.messages)
        .thenAnswer((_) => BehaviorSubject.seeded(Result.success(BuiltList<spreed.ChatMessageWithParent>())));
    when(() => bloc.lastCommonRead).thenAnswer((_) => BehaviorSubject.seeded(0));
  });

  testWidgets('Status message', (tester) async {
    when(() => room.statusMessage).thenReturn('status');

    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        appThemes: const [
          TalkTheme(),
        ],
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
        ],
        child: const TalkRoomPage(),
      ),
    );

    expect(find.text('status'), findsOne);
  });

  testWidgets('Errors', (tester) async {
    final controller = StreamController<Object>();
    when(() => bloc.errors).thenAnswer((_) => controller.stream);

    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        appThemes: const [
          TalkTheme(),
        ],
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
        ],
        child: const TalkRoomPage(),
      ),
    );

    controller.add(Exception());
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOne);
    await expectLater(find.byType(TestApp), matchesGoldenFile('goldens/room_page_error.png'));

    await controller.close();
  });

  testWidgets('Messages', (tester) async {
    final parentChatMessage = MockChatMessage();
    when(() => parentChatMessage.id).thenReturn(0);
    when(() => parentChatMessage.timestamp).thenReturn(0);
    when(() => parentChatMessage.actorId).thenReturn('test');
    when(() => parentChatMessage.actorType).thenReturn(spreed.ActorType.users);
    when(() => parentChatMessage.actorDisplayName).thenReturn('test');
    when(() => parentChatMessage.messageType).thenReturn(spreed.MessageType.comment);
    when(() => parentChatMessage.message).thenReturn('abc');
    when(() => parentChatMessage.reactions).thenReturn(BuiltMap());
    when(() => parentChatMessage.messageParameters).thenReturn(BuiltMap());

    final chatMessage1 = MockChatMessageWithParent();
    when(() => chatMessage1.id).thenReturn(1);
    when(() => chatMessage1.timestamp).thenReturn(0);
    when(() => chatMessage1.actorId).thenReturn('test');
    when(() => chatMessage1.actorType).thenReturn(spreed.ActorType.users);
    when(() => chatMessage1.actorDisplayName).thenReturn('test');
    when(() => chatMessage1.messageType).thenReturn(spreed.MessageType.comment);
    when(() => chatMessage1.message).thenReturn('abc');
    when(() => chatMessage1.reactions).thenReturn(BuiltMap());
    when(() => chatMessage1.parent).thenReturn(parentChatMessage);
    when(() => chatMessage1.messageParameters).thenReturn(BuiltMap());

    final chatMessage2 = MockChatMessageWithParent();
    when(() => chatMessage2.id).thenReturn(2);
    when(() => chatMessage2.timestamp).thenReturn(0);
    when(() => chatMessage2.actorId).thenReturn('test');
    when(() => chatMessage2.actorType).thenReturn(spreed.ActorType.users);
    when(() => chatMessage2.actorDisplayName).thenReturn('test');
    when(() => chatMessage2.messageType).thenReturn(spreed.MessageType.comment);
    when(() => chatMessage2.message).thenReturn('abc');
    when(() => chatMessage2.reactions).thenReturn(BuiltMap());
    when(() => chatMessage2.parent).thenReturn(parentChatMessage);
    when(() => chatMessage2.messageParameters).thenReturn(BuiltMap());

    when(() => bloc.messages).thenAnswer(
      (_) => BehaviorSubject.seeded(
        Result.success(
          BuiltList<spreed.ChatMessageWithParent>([
            chatMessage2,
            chatMessage1,
          ]),
        ),
      ),
    );

    when(() => bloc.reactions).thenAnswer((_) => BehaviorSubject.seeded(BuiltMap()));

    final account = MockAccount();
    when(() => account.client).thenReturn(NextcloudClient(Uri.parse('')));

    final accountsBloc = MockAccountsBloc();
    when(() => accountsBloc.activeAccount).thenAnswer((_) => BehaviorSubject.seeded(account));

    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        appThemes: const [
          TalkTheme(),
        ],
        providers: [
          NeonProvider<AccountsBloc>.value(value: accountsBloc),
          NeonProvider<TalkRoomBloc>.value(value: bloc),
        ],
        child: const TalkRoomPage(),
      ),
    );

    expect(find.byType(TalkMessage), findsExactly(4));
    expect(find.byType(TalkParentMessage), findsExactly(2));
    await expectLater(find.byType(TestApp), matchesGoldenFile('goldens/room_page_messages.png'));
  });

  testWidgets('Read-only', (tester) async {
    when(() => room.readOnly).thenReturn(1);

    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
        ],
        child: const TalkRoomPage(),
      ),
    );

    expect(find.byType(TypeAheadField), findsNothing);
    expect(find.byIcon(Icons.emoji_emotions_outlined), findsNothing);
    await expectLater(find.byType(TestApp), matchesGoldenFile('goldens/room_page_read_only.png'));
  });
}
