import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_framework/widgets.dart';
import 'package:neon_talk/src/blocs/room.dart';
import 'package:neon_talk/src/theme.dart';
import 'package:neon_talk/src/widgets/message.dart';
import 'package:neon_talk/src/widgets/message_input.dart';
import 'package:neon_talk/src/widgets/room_avatar.dart';
import 'package:nextcloud/spreed.dart' as spreed;

/// Displays the room with a chat message list.
class TalkRoomPage extends StatefulWidget {
  /// Creates a new Talk room page.
  const TalkRoomPage({
    super.key,
  });

  @override
  State<TalkRoomPage> createState() => _TalkRoomPageState();
}

class _TalkRoomPageState extends State<TalkRoomPage> {
  late final TalkRoomBloc bloc;
  late final StreamSubscription<Object> errorsSubscription;

  @override
  void initState() {
    super.initState();

    bloc = NeonProvider.of<TalkRoomBloc>(context);

    errorsSubscription = bloc.errors.listen((error) {
      NeonError.showSnackbar(context, error);
    });
  }

  @override
  void dispose() {
    unawaited(errorsSubscription.cancel());
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResultBuilder.behaviorSubject(
      subject: bloc.room,
      builder: (context, result) {
        final room = result.requireData;

        Widget title = Text(room.displayName);

        final statusMessage = room.statusMessage;
        if (statusMessage != null) {
          title = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              Text(
                statusMessage,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          );
        }

        final appBar = AppBar(
          title: Row(
            children: <Widget>[
              TalkRoomAvatar(
                room: room,
              ),
              title,
              NeonError(
                result.error,
                onRetry: bloc.refresh,
                type: NeonErrorType.iconOnly,
              ),
              Flexible(
                child: NeonLinearProgressIndicator(
                  visible: result.isLoading,
                ),
              ),
            ]
                .intersperse(
                  const SizedBox(
                    width: 10,
                  ),
                )
                .toList(),
          ),
        );

        Widget body = StreamBuilder(
          stream: bloc.lastCommonRead,
          builder: (context, lastCommonReadSnapshot) => ResultBuilder.behaviorSubject(
            subject: bloc.messages,
            builder: (context, messagesResult) {
              final sliver = SliverList.builder(
                itemCount: messagesResult.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final message = messagesResult.requireData[index];

                  spreed.ChatMessageWithParent? previousMessage;
                  if (messagesResult.requireData.length > index + 1) {
                    previousMessage = messagesResult.requireData[index + 1];
                  }

                  return Center(
                    child: ConstrainedBox(
                      constraints: Theme.of(context).extension<TalkTheme>()!.messageConstraints,
                      child: TalkMessage(
                        chatMessage: message,
                        lastCommonRead: lastCommonReadSnapshot.data,
                        previousChatMessage: previousMessage,
                      ),
                    ),
                  );
                },
              );

              return NeonListView.custom(
                scrollKey: 'talk-room-${room.token}',
                reverse: true,
                isLoading: messagesResult.isLoading,
                error: messagesResult.error,
                onRefresh: bloc.refresh,
                sliver: SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  sliver: sliver,
                ),
              );
            },
          ),
        );

        if (room.readOnly == 0) {
          body = Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: body,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Center(
                  child: ConstrainedBox(
                    constraints: Theme.of(context).extension<TalkTheme>()!.messageConstraints,
                    child: const TalkMessageInput(),
                  ),
                ),
              ),
            ],
          );
        }

        return Scaffold(
          appBar: appBar,
          body: body,
        );
      },
    );
  }
}
