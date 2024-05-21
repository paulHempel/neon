import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/testing.dart';
import 'package:neon_framework/theme.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_talk/l10n/localizations.dart';
import 'package:neon_talk/l10n/localizations_en.dart';
import 'package:neon_talk/src/widgets/actor_avatar.dart';
import 'package:neon_talk/src/widgets/message.dart';
import 'package:neon_talk/src/widgets/reactions.dart';
import 'package:neon_talk/src/widgets/read_indicator.dart';
import 'package:neon_talk/src/widgets/rich_object/deck_card.dart';
import 'package:neon_talk/src/widgets/rich_object/fallback.dart';
import 'package:neon_talk/src/widgets/rich_object/file.dart';
import 'package:neon_talk/src/widgets/rich_object/mention.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/spreed.dart' as spreed;
import 'package:rxdart/rxdart.dart';

import 'testing.dart';

Widget wrapWidget(Widget child) => TestApp(
      localizationsDelegates: TalkLocalizations.localizationsDelegates,
      supportedLocales: TalkLocalizations.supportedLocales,
      child: child,
    );

void main() {
  setUpAll(() {
    FakeNeonStorage.setup();

    registerFallbackValue(Uri());
  });

  group('getActorDisplayName', () {
    final localizations = TalkLocalizationsEn();

    test('Guest without name', () {
      final chatMessage = MockChatMessage();
      when(() => chatMessage.actorDisplayName).thenReturn('');
      when(() => chatMessage.actorType).thenReturn(spreed.ActorType.guests);

      expect(getActorDisplayName(localizations, chatMessage), localizations.actorGuest);
    });

    test('Guest with name', () {
      final chatMessage = MockChatMessage();
      when(() => chatMessage.actorDisplayName).thenReturn('test');

      expect(getActorDisplayName(localizations, chatMessage), 'test');
    });
  });

  group('TalkMessagePreview', () {
    testWidgets('Group self', (tester) async {
      final chatMessage = MockChatMessage();
      when(() => chatMessage.actorId).thenReturn('test');
      when(() => chatMessage.message).thenReturn('message');
      when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

      await tester.pumpWidget(
        wrapWidget(
          TalkMessagePreview(
            actorId: 'test',
            roomType: spreed.RoomType.group,
            chatMessage: chatMessage,
          ),
        ),
      );
      expect(find.text('You: message', findRichText: true), findsOne);
    });

    testWidgets('Group other', (tester) async {
      final chatMessage = MockChatMessage();
      when(() => chatMessage.actorId).thenReturn('test');
      when(() => chatMessage.actorDisplayName).thenReturn('Test');
      when(() => chatMessage.message).thenReturn('message');
      when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

      await tester.pumpWidget(
        wrapWidget(
          TalkMessagePreview(
            actorId: 'abc',
            roomType: spreed.RoomType.group,
            chatMessage: chatMessage,
          ),
        ),
      );
      expect(find.text('Test: message', findRichText: true), findsOne);
    });

    testWidgets('One to one self', (tester) async {
      final chatMessage = MockChatMessage();
      when(() => chatMessage.actorId).thenReturn('test');
      when(() => chatMessage.message).thenReturn('message');
      when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

      await tester.pumpWidget(
        wrapWidget(
          TalkMessagePreview(
            actorId: 'test',
            roomType: spreed.RoomType.oneToOne,
            chatMessage: chatMessage,
          ),
        ),
      );
      expect(find.text('You: message', findRichText: true), findsOne);
    });

    testWidgets('One to one other', (tester) async {
      final chatMessage = MockChatMessage();
      when(() => chatMessage.actorId).thenReturn('test');
      when(() => chatMessage.message).thenReturn('message');
      when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

      await tester.pumpWidget(
        wrapWidget(
          TalkMessagePreview(
            actorId: 'abc',
            roomType: spreed.RoomType.oneToOne,
            chatMessage: chatMessage,
          ),
        ),
      );
      expect(find.text('message', findRichText: true), findsOne);
    });

    testWidgets('System', (tester) async {
      final chatMessage = MockChatMessage();
      when(() => chatMessage.actorId).thenReturn('test');
      when(() => chatMessage.message).thenReturn('message');
      when(() => chatMessage.messageType).thenReturn(spreed.MessageType.system);
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

      await tester.pumpWidget(
        wrapWidget(
          TalkMessagePreview(
            actorId: 'abc',
            roomType: spreed.RoomType.group,
            chatMessage: chatMessage,
          ),
        ),
      );
      expect(find.text('message', findRichText: true), findsOne);
    });

    testWidgets('Newline removed', (tester) async {
      final chatMessage = MockChatMessage();
      when(() => chatMessage.actorId).thenReturn('test');
      when(() => chatMessage.message).thenReturn('message\n123');
      when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

      await tester.pumpWidget(
        wrapWidget(
          TalkMessagePreview(
            actorId: 'abc',
            roomType: spreed.RoomType.oneToOne,
            chatMessage: chatMessage,
          ),
        ),
      );
      expect(find.text('message 123', findRichText: true), findsOne);
    });
  });

  group('TalkMessage', () {
    testWidgets('System', (tester) async {
      final chatMessage = MockChatMessage();
      when(() => chatMessage.messageType).thenReturn(spreed.MessageType.system);
      when(() => chatMessage.systemMessage).thenReturn('');
      when(() => chatMessage.message).thenReturn('');
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

      await tester.pumpWidget(
        wrapWidget(
          TalkMessage(
            chatMessage: chatMessage,
            lastCommonRead: null,
          ),
        ),
      );
      expect(find.byType(TalkSystemMessage), findsOne);
    });

    testWidgets('Comment', (tester) async {
      final account = MockAccount();
      when(() => account.id).thenReturn('');
      when(() => account.client).thenReturn(NextcloudClient(Uri.parse('')));

      final accountsBloc = MockAccountsBloc();
      when(() => accountsBloc.activeAccount).thenAnswer((_) => BehaviorSubject.seeded(account));

      final chatMessage = MockChatMessage();
      when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => chatMessage.timestamp).thenReturn(0);
      when(() => chatMessage.actorId).thenReturn('');
      when(() => chatMessage.actorType).thenReturn(spreed.ActorType.users);
      when(() => chatMessage.actorDisplayName).thenReturn('');
      when(() => chatMessage.message).thenReturn('');
      when(() => chatMessage.reactions).thenReturn(BuiltMap());
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

      await tester.pumpWidget(
        wrapWidget(
          NeonProvider<AccountsBloc>.value(
            value: accountsBloc,
            child: TalkMessage(
              chatMessage: chatMessage,
              lastCommonRead: null,
            ),
          ),
        ),
      );
      expect(find.byType(TalkCommentMessage), findsOne);
    });
  });

  group('TalkSystemMessage', () {
    testWidgets('Hide', (tester) async {
      final chatMessage = MockChatMessage();
      when(() => chatMessage.systemMessage).thenReturn('reaction');

      await tester.pumpWidget(
        wrapWidget(
          TalkSystemMessage(
            chatMessage: chatMessage,
            previousChatMessage: null,
          ),
        ),
      );
      expect(find.byType(SizedBox), findsOne);
      expect(find.byType(RichText), findsNothing);
      await expectLater(find.byType(TalkSystemMessage), matchesGoldenFile('goldens/message_system_message_hide.png'));
    });

    testWidgets('Show', (tester) async {
      final chatMessage = MockChatMessage();
      when(() => chatMessage.systemMessage).thenReturn('');
      when(() => chatMessage.message).thenReturn('test');
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

      await tester.pumpWidget(
        wrapWidget(
          TalkSystemMessage(
            chatMessage: chatMessage,
            previousChatMessage: null,
          ),
        ),
      );
      expect(find.byType(SizedBox), findsNothing);
      expect(find.byType(RichText), findsOne);
      await expectLater(find.byType(TalkSystemMessage), matchesGoldenFile('goldens/message_system_message_show.png'));
    });

    testWidgets('Grouping', (tester) async {
      final previousChatMessage = MockChatMessage();
      when(() => previousChatMessage.messageType).thenReturn(spreed.MessageType.system);

      final chatMessage = MockChatMessage();
      when(() => chatMessage.systemMessage).thenReturn('');
      when(() => chatMessage.message).thenReturn('test');
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

      await tester.pumpWidget(
        wrapWidget(
          TalkSystemMessage(
            chatMessage: chatMessage,
            previousChatMessage: previousChatMessage,
          ),
        ),
      );
      expect(find.byType(SizedBox), findsNothing);
      expect(find.byType(RichText), findsOne);
      await expectLater(
        find.byType(TalkSystemMessage),
        matchesGoldenFile('goldens/message_system_message_grouping.png'),
      );
    });
  });

  testWidgets('TalkParentMessage', (tester) async {
    final account = MockAccount();
    when(() => account.id).thenReturn('');
    when(() => account.client).thenReturn(NextcloudClient(Uri.parse('')));

    final accountsBloc = MockAccountsBloc();
    when(() => accountsBloc.activeAccount).thenAnswer((_) => BehaviorSubject.seeded(account));

    final chatMessage = MockChatMessage();
    when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
    when(() => chatMessage.timestamp).thenReturn(0);
    when(() => chatMessage.actorId).thenReturn('test');
    when(() => chatMessage.actorType).thenReturn(spreed.ActorType.users);
    when(() => chatMessage.actorDisplayName).thenReturn('test');
    when(() => chatMessage.message).thenReturn('abc');
    when(() => chatMessage.reactions).thenReturn(BuiltMap());
    when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

    await tester.pumpWidget(
      wrapWidget(
        NeonProvider<AccountsBloc>.value(
          value: accountsBloc,
          child: TalkParentMessage(
            parentChatMessage: chatMessage,
            lastCommonRead: null,
          ),
        ),
      ),
    );
    expect(find.byType(TalkCommentMessage), findsOne);
    await expectLater(find.byType(TalkParentMessage), matchesGoldenFile('goldens/message_parent_message.png'));
  });

  group('TalkCommentMessage', () {
    testWidgets('Default', (tester) async {
      final account = MockAccount();
      when(() => account.id).thenReturn('');
      when(() => account.username).thenReturn('test');
      when(() => account.client).thenReturn(NextcloudClient(Uri.parse('')));

      final accountsBloc = MockAccountsBloc();
      when(() => accountsBloc.activeAccount).thenAnswer((_) => BehaviorSubject.seeded(account));

      final previousChatMessage = MockChatMessage();
      when(() => previousChatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => previousChatMessage.timestamp).thenReturn(0);
      when(() => previousChatMessage.actorId).thenReturn('test');

      final chatMessage = MockChatMessage();
      when(() => chatMessage.timestamp).thenReturn(0);
      when(() => chatMessage.actorId).thenReturn('test');
      when(() => chatMessage.actorType).thenReturn(spreed.ActorType.users);
      when(() => chatMessage.actorDisplayName).thenReturn('test');
      when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => chatMessage.message).thenReturn('abc');
      when(() => chatMessage.reactions).thenReturn(BuiltMap({'😀': 1, '😊': 23}));
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());
      when(() => chatMessage.id).thenReturn(0);

      await tester.pumpWidget(
        wrapWidget(
          NeonProvider<AccountsBloc>.value(
            value: accountsBloc,
            child: TalkCommentMessage(
              chatMessage: chatMessage,
              lastCommonRead: 0,
              previousChatMessage: previousChatMessage,
            ),
          ),
        ),
      );
      expect(find.byType(TalkActorAvatar), findsNothing);
      expect(find.text('12:00 AM'), findsNothing);
      expect(find.text('test'), findsNothing);
      expect(find.text('abc', findRichText: true), findsOne);
      expect(find.byType(TalkReactions), findsOne);
      expect(find.byType(TalkReadIndicator), findsOne);
      await expectLater(
        find.byType(TalkCommentMessage),
        matchesGoldenFile('goldens/message_comment_message_self.png'),
      );
    });

    testWidgets('Default', (tester) async {
      final account = MockAccount();
      when(() => account.id).thenReturn('');
      when(() => account.username).thenReturn('other');
      when(() => account.client).thenReturn(NextcloudClient(Uri.parse('')));

      final accountsBloc = MockAccountsBloc();
      when(() => accountsBloc.activeAccount).thenAnswer((_) => BehaviorSubject.seeded(account));

      final previousChatMessage = MockChatMessage();
      when(() => previousChatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => previousChatMessage.timestamp).thenReturn(0);
      when(() => previousChatMessage.actorId).thenReturn('test');

      final chatMessage = MockChatMessage();
      when(() => chatMessage.timestamp).thenReturn(0);
      when(() => chatMessage.actorId).thenReturn('test');
      when(() => chatMessage.actorType).thenReturn(spreed.ActorType.users);
      when(() => chatMessage.actorDisplayName).thenReturn('test');
      when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => chatMessage.message).thenReturn('abc');
      when(() => chatMessage.reactions).thenReturn(BuiltMap({'😀': 1, '😊': 23}));
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());
      when(() => chatMessage.id).thenReturn(0);

      await tester.pumpWidget(
        wrapWidget(
          NeonProvider<AccountsBloc>.value(
            value: accountsBloc,
            child: TalkCommentMessage(
              chatMessage: chatMessage,
              lastCommonRead: 0,
              previousChatMessage: previousChatMessage,
            ),
          ),
        ),
      );
      expect(find.byType(TalkActorAvatar), findsNothing);
      expect(find.text('12:00 AM'), findsNothing);
      expect(find.text('test'), findsNothing);
      expect(find.text('abc', findRichText: true), findsOne);
      expect(find.byType(TalkReactions), findsOne);
      expect(find.byType(TalkReadIndicator), findsNothing);
      await expectLater(
        find.byType(TalkCommentMessage),
        matchesGoldenFile('goldens/message_comment_message_other.png'),
      );
    });

    testWidgets('Deleted', (tester) async {
      final account = MockAccount();
      when(() => account.id).thenReturn('');
      when(() => account.client).thenReturn(NextcloudClient(Uri.parse('')));

      final accountsBloc = MockAccountsBloc();
      when(() => accountsBloc.activeAccount).thenAnswer((_) => BehaviorSubject.seeded(account));

      final previousChatMessage = MockChatMessage();
      when(() => previousChatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => previousChatMessage.timestamp).thenReturn(0);
      when(() => previousChatMessage.actorId).thenReturn('test');

      final chatMessage = MockChatMessage();
      when(() => chatMessage.timestamp).thenReturn(0);
      when(() => chatMessage.actorId).thenReturn('test');
      when(() => chatMessage.actorType).thenReturn(spreed.ActorType.users);
      when(() => chatMessage.actorDisplayName).thenReturn('test');
      when(() => chatMessage.messageType).thenReturn(spreed.MessageType.commentDeleted);
      when(() => chatMessage.message).thenReturn('abc');
      when(() => chatMessage.reactions).thenReturn(BuiltMap());
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

      await tester.pumpWidget(
        wrapWidget(
          NeonProvider<AccountsBloc>.value(
            value: accountsBloc,
            child: TalkCommentMessage(
              chatMessage: chatMessage,
              lastCommonRead: null,
              previousChatMessage: previousChatMessage,
            ),
          ),
        ),
      );
      expect(find.text('abc', findRichText: true), findsOne);
      expect(find.byIcon(AdaptiveIcons.cancel), findsOne);
      await expectLater(
        find.byType(TalkCommentMessage),
        matchesGoldenFile('goldens/message_comment_message_deleted.png'),
      );
    });

    testWidgets('As parent', (tester) async {
      final account = MockAccount();
      when(() => account.id).thenReturn('');
      when(() => account.client).thenReturn(NextcloudClient(Uri.parse('')));

      final accountsBloc = MockAccountsBloc();
      when(() => accountsBloc.activeAccount).thenAnswer((_) => BehaviorSubject.seeded(account));

      final chatMessage = MockChatMessage();
      when(() => chatMessage.timestamp).thenReturn(0);
      when(() => chatMessage.actorId).thenReturn('test');
      when(() => chatMessage.actorDisplayName).thenReturn('test');
      when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => chatMessage.message).thenReturn('abc');
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

      await tester.pumpWidget(
        wrapWidget(
          NeonProvider<AccountsBloc>.value(
            value: accountsBloc,
            child: TalkCommentMessage(
              chatMessage: chatMessage,
              lastCommonRead: null,
              isParent: true,
            ),
          ),
        ),
      );
      expect(find.byType(TalkActorAvatar), findsNothing);
      expect(find.text('12:00 AM'), findsNothing);
      expect(find.text('test'), findsOne);
      expect(find.text('abc', findRichText: true), findsOne);
      expect(find.byType(TalkReactions), findsNothing);
      await expectLater(
        find.byType(TalkCommentMessage),
        matchesGoldenFile('goldens/message_comment_message_as_parent.png'),
      );
    });

    testWidgets('With parent', (tester) async {
      final account = MockAccount();
      when(() => account.id).thenReturn('');
      when(() => account.client).thenReturn(NextcloudClient(Uri.parse('')));

      final accountsBloc = MockAccountsBloc();
      when(() => accountsBloc.activeAccount).thenAnswer((_) => BehaviorSubject.seeded(account));

      final previousChatMessage = MockChatMessage();
      when(() => previousChatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => previousChatMessage.timestamp).thenReturn(0);
      when(() => previousChatMessage.actorId).thenReturn('test');

      final parentChatMessage = MockChatMessage();
      when(() => parentChatMessage.timestamp).thenReturn(0);
      when(() => parentChatMessage.actorId).thenReturn('test');
      when(() => parentChatMessage.actorDisplayName).thenReturn('test');
      when(() => parentChatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => parentChatMessage.message).thenReturn('abc');
      when(() => parentChatMessage.messageParameters).thenReturn(BuiltMap());

      final chatMessage = MockChatMessageWithParent();
      when(() => chatMessage.timestamp).thenReturn(0);
      when(() => chatMessage.actorId).thenReturn('test');
      when(() => chatMessage.actorType).thenReturn(spreed.ActorType.users);
      when(() => chatMessage.actorDisplayName).thenReturn('test');
      when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => chatMessage.message).thenReturn('abc');
      when(() => chatMessage.reactions).thenReturn(BuiltMap());
      when(() => chatMessage.parent).thenReturn(parentChatMessage);
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

      await tester.pumpWidget(
        wrapWidget(
          NeonProvider<AccountsBloc>.value(
            value: accountsBloc,
            child: TalkCommentMessage(
              chatMessage: chatMessage,
              lastCommonRead: null,
              previousChatMessage: previousChatMessage,
            ),
          ),
        ),
      );
      expect(find.byType(TalkParentMessage), findsOne);
      await expectLater(
        find.byType(TalkCommentMessage).first,
        matchesGoldenFile('goldens/message_comment_message_with_parent.png'),
      );
    });

    group('Separate messages', () {
      testWidgets('Actor', (tester) async {
        final account = MockAccount();
        when(() => account.id).thenReturn('');
        when(() => account.client).thenReturn(NextcloudClient(Uri.parse('')));

        final accountsBloc = MockAccountsBloc();
        when(() => accountsBloc.activeAccount).thenAnswer((_) => BehaviorSubject.seeded(account));

        final previousChatMessage = MockChatMessage();
        when(() => previousChatMessage.messageType).thenReturn(spreed.MessageType.comment);
        when(() => previousChatMessage.timestamp).thenReturn(0);
        when(() => previousChatMessage.actorId).thenReturn('123');

        final chatMessage = MockChatMessage();
        when(() => chatMessage.timestamp).thenReturn(0);
        when(() => chatMessage.actorId).thenReturn('test');
        when(() => chatMessage.actorType).thenReturn(spreed.ActorType.users);
        when(() => chatMessage.actorDisplayName).thenReturn('test');
        when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
        when(() => chatMessage.message).thenReturn('abc');
        when(() => chatMessage.reactions).thenReturn(BuiltMap({'😀': 1, '😊': 23}));
        when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

        await tester.pumpWidget(
          wrapWidget(
            NeonProvider<AccountsBloc>.value(
              value: accountsBloc,
              child: TalkCommentMessage(
                chatMessage: chatMessage,
                lastCommonRead: null,
                previousChatMessage: previousChatMessage,
              ),
            ),
          ),
        );
        expect(find.byType(TalkActorAvatar), findsOne);
        expect(find.text('12:00 AM'), findsOne);
        expect(find.text('test'), findsOne);
        expect(find.text('abc', findRichText: true), findsOne);
        expect(find.byType(TalkReactions), findsOne);
        await expectLater(
          find.byType(TalkCommentMessage),
          matchesGoldenFile('goldens/message_comment_message_separate_actor.png'),
        );
      });

      testWidgets('Time', (tester) async {
        final account = MockAccount();
        when(() => account.id).thenReturn('');
        when(() => account.client).thenReturn(NextcloudClient(Uri.parse('')));

        final accountsBloc = MockAccountsBloc();
        when(() => accountsBloc.activeAccount).thenAnswer((_) => BehaviorSubject.seeded(account));

        final previousChatMessage = MockChatMessage();
        when(() => previousChatMessage.messageType).thenReturn(spreed.MessageType.comment);
        when(() => previousChatMessage.timestamp).thenReturn(0);
        when(() => previousChatMessage.actorId).thenReturn('test');

        final chatMessage = MockChatMessage();
        when(() => chatMessage.timestamp).thenReturn(300);
        when(() => chatMessage.actorId).thenReturn('test');
        when(() => chatMessage.actorType).thenReturn(spreed.ActorType.users);
        when(() => chatMessage.actorDisplayName).thenReturn('test');
        when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
        when(() => chatMessage.message).thenReturn('abc');
        when(() => chatMessage.reactions).thenReturn(BuiltMap({'😀': 1, '😊': 23}));
        when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

        await tester.pumpWidget(
          wrapWidget(
            NeonProvider<AccountsBloc>.value(
              value: accountsBloc,
              child: TalkCommentMessage(
                chatMessage: chatMessage,
                lastCommonRead: null,
                previousChatMessage: previousChatMessage,
              ),
            ),
          ),
        );
        expect(find.byType(TalkActorAvatar), findsOne);
        expect(find.text('12:05 AM'), findsOne);
        expect(find.text('test'), findsOne);
        expect(find.text('abc', findRichText: true), findsOne);
        expect(find.byType(TalkReactions), findsOne);
        await expectLater(
          find.byType(TalkCommentMessage),
          matchesGoldenFile('goldens/message_comment_message_separate_time.png'),
        );
      });

      testWidgets('System message', (tester) async {
        final account = MockAccount();
        when(() => account.id).thenReturn('');
        when(() => account.client).thenReturn(NextcloudClient(Uri.parse('')));

        final accountsBloc = MockAccountsBloc();
        when(() => accountsBloc.activeAccount).thenAnswer((_) => BehaviorSubject.seeded(account));

        final previousChatMessage = MockChatMessage();
        when(() => previousChatMessage.messageType).thenReturn(spreed.MessageType.system);
        when(() => previousChatMessage.timestamp).thenReturn(0);
        when(() => previousChatMessage.actorId).thenReturn('test');

        final chatMessage = MockChatMessage();
        when(() => chatMessage.timestamp).thenReturn(0);
        when(() => chatMessage.actorId).thenReturn('test');
        when(() => chatMessage.actorType).thenReturn(spreed.ActorType.users);
        when(() => chatMessage.actorDisplayName).thenReturn('test');
        when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
        when(() => chatMessage.message).thenReturn('abc');
        when(() => chatMessage.reactions).thenReturn(BuiltMap({'😀': 1, '😊': 23}));
        when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

        await tester.pumpWidget(
          wrapWidget(
            NeonProvider<AccountsBloc>.value(
              value: accountsBloc,
              child: TalkCommentMessage(
                chatMessage: chatMessage,
                lastCommonRead: null,
                previousChatMessage: previousChatMessage,
              ),
            ),
          ),
        );
        expect(find.byType(TalkActorAvatar), findsOne);
        expect(find.text('12:00 AM'), findsOne);
        expect(find.text('test'), findsOne);
        expect(find.text('abc', findRichText: true), findsOne);
        expect(find.byType(TalkReactions), findsOne);
        await expectLater(
          find.byType(TalkCommentMessage),
          matchesGoldenFile('goldens/message_comment_message_separate_system_message.png'),
        );
      });
    });
  });

  group('buildRichObjectParameter', () {
    for (final isPreview in [true, false]) {
      group(isPreview ? 'As preview' : 'Complete', () {
        group('Mention', () {
          for (final type in [
            spreed.RichObjectParameter_Type.user,
            spreed.RichObjectParameter_Type.call,
            spreed.RichObjectParameter_Type.guest,
            spreed.RichObjectParameter_Type.userGroup,
            spreed.RichObjectParameter_Type.group,
          ]) {
            testWidgets(type.value, (tester) async {
              final userDetails = MockUserDetails();
              when(() => userDetails.groups).thenReturn(BuiltList());

              final userDetailsBloc = MockUserDetailsBloc();
              when(() => userDetailsBloc.userDetails)
                  .thenAnswer((_) => BehaviorSubject.seeded(Result.success(userDetails)));

              final account = MockAccount();
              when(() => account.username).thenReturn('username');
              when(() => account.client).thenReturn(NextcloudClient(Uri()));
              when(() => account.completeUri(any()))
                  .thenAnswer((invocation) => invocation.positionalArguments[0]! as Uri);

              final accountsBloc = MockAccountsBloc();
              when(() => accountsBloc.activeAccount).thenAnswer((_) => BehaviorSubject.seeded(account));
              when(() => accountsBloc.activeUserDetailsBloc).thenReturn(userDetailsBloc);

              await tester.pumpWidget(
                TestApp(
                  providers: [
                    NeonProvider<AccountsBloc>.value(value: accountsBloc),
                  ],
                  child: RichText(
                    text: buildRichObjectParameter(
                      parameter: spreed.RichObjectParameter(
                        (b) => b
                          ..type = type
                          ..id = ''
                          ..name = 'name'
                          ..iconUrl = '',
                      ),
                      textStyle: null,
                      isPreview: isPreview,
                    ),
                  ),
                ),
              );

              expect(find.byType(TalkRichObjectMention), findsOne);
              expect(find.text('name'), findsOne);
            });
          }
        });

        testWidgets('File', (tester) async {
          await tester.pumpWidget(
            TestApp(
              child: RichText(
                text: buildRichObjectParameter(
                  parameter: spreed.RichObjectParameter(
                    (b) => b
                      ..type = spreed.RichObjectParameter_Type.file
                      ..id = ''
                      ..name = 'name',
                  ),
                  textStyle: null,
                  isPreview: isPreview,
                ),
              ),
            ),
          );

          expect(find.byType(TalkRichObjectFile), isPreview ? findsNothing : findsOne);
          expect(find.text('name'), findsOne);
        });

        testWidgets('Deck card', (tester) async {
          await tester.pumpWidget(
            TestApp(
              child: RichText(
                text: buildRichObjectParameter(
                  parameter: spreed.RichObjectParameter(
                    (b) => b
                      ..type = spreed.RichObjectParameter_Type.deckCard
                      ..id = ''
                      ..name = 'name'
                      ..boardname = 'boardname'
                      ..stackname = 'stackname',
                  ),
                  textStyle: null,
                  isPreview: isPreview,
                ),
              ),
            ),
          );

          expect(find.byType(TalkRichObjectDeckCard), isPreview ? findsNothing : findsOne);
          expect(find.text('name'), findsOne);
        });

        testWidgets('Fallback', (tester) async {
          await tester.pumpWidget(
            TestApp(
              child: RichText(
                text: buildRichObjectParameter(
                  parameter: spreed.RichObjectParameter(
                    (b) => b
                      ..type = spreed.RichObjectParameter_Type.addressbook
                      ..id = ''
                      ..name = 'name',
                  ),
                  textStyle: null,
                  isPreview: isPreview,
                ),
              ),
            ),
          );

          expect(find.byType(TalkRichObjectFallback), isPreview ? findsNothing : findsOne);
          expect(find.text('name'), findsOne);
        });
      });
    }
  });

  group('buildChatMessage', () {
    test('Preview without newlines', () {
      final chatMessage = MockChatMessage();
      when(() => chatMessage.message).thenReturn('123\n456');
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());

      var span = buildChatMessage(chatMessage: chatMessage).children!.single as TextSpan;
      expect(span.text, '123\n456');

      span = buildChatMessage(chatMessage: chatMessage, isPreview: true).children!.single as TextSpan;
      expect(span.text, '123 456');
    });

    group('Unused parameters', () {
      group('Discard', () {
        for (final type in ['actor', 'user']) {
          test(type, () {
            final chatMessage = MockChatMessage();
            when(() => chatMessage.message).thenReturn('test');
            when(() => chatMessage.messageParameters).thenReturn(
              BuiltMap({
                type: spreed.RichObjectParameter(
                  (b) => b
                    ..type = spreed.RichObjectParameter_Type.user
                    ..id = ''
                    ..name = '',
                ),
              }),
            );

            final spans = buildChatMessage(chatMessage: chatMessage).children!;
            expect((spans.single as TextSpan).text, 'test');
          });
        }
      });

      test('Display', () {
        final chatMessage = MockChatMessage();
        when(() => chatMessage.message).thenReturn('test');
        when(() => chatMessage.messageParameters).thenReturn(
          BuiltMap({
            'file': spreed.RichObjectParameter(
              (b) => b
                ..type = spreed.RichObjectParameter_Type.file
                ..id = ''
                ..name = '',
            ),
          }),
        );

        final spans = buildChatMessage(chatMessage: chatMessage).children!;
        expect(spans, hasLength(3));
        expect((spans[0] as WidgetSpan).child, isA<TalkRichObjectFile>());
        expect((spans[1] as TextSpan).text, '\n');
        expect((spans[2] as TextSpan).text, 'test');
      });
    });

    test('Used parameters', () {
      final chatMessage = MockChatMessage();
      when(() => chatMessage.message).thenReturn('123 {actor1} 456 {actor2} 789');
      when(() => chatMessage.messageParameters).thenReturn(
        BuiltMap({
          'actor1': spreed.RichObjectParameter(
            (b) => b
              ..type = spreed.RichObjectParameter_Type.user
              ..id = ''
              ..name = '',
          ),
          'actor2': spreed.RichObjectParameter(
            (b) => b
              ..type = spreed.RichObjectParameter_Type.user
              ..id = ''
              ..name = '',
          ),
        }),
      );

      final spans = buildChatMessage(chatMessage: chatMessage).children!;
      expect(spans, hasLength(5));
      expect((spans[0] as TextSpan).text, '123 ');
      expect((spans[1] as WidgetSpan).child, isA<TalkRichObjectMention>());
      expect((spans[2] as TextSpan).text, ' 456 ');
      expect((spans[3] as WidgetSpan).child, isA<TalkRichObjectMention>());
      expect((spans[4] as TextSpan).text, ' 789');
    });
  });
}
