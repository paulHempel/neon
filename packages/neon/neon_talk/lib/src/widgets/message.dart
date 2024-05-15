import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:intl/intl.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/theme.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_talk/l10n/localizations.dart';
import 'package:neon_talk/src/blocs/room.dart';
import 'package:neon_talk/src/widgets/actor_avatar.dart';
import 'package:neon_talk/src/widgets/reactions.dart';
import 'package:neon_talk/src/widgets/read_indicator.dart';
import 'package:neon_talk/src/widgets/rich_object/deck_card.dart';
import 'package:neon_talk/src/widgets/rich_object/fallback.dart';
import 'package:neon_talk/src/widgets/rich_object/file.dart';
import 'package:neon_talk/src/widgets/rich_object/mention.dart';
import 'package:nextcloud/spreed.dart' as spreed;
import 'package:nextcloud/utils.dart';
import 'package:timezone/timezone.dart' as tz;

final _timeFormat = DateFormat.jm();

/// Returns the display name of the actor of the [chatMessage].
///
/// In case the actor is a guest and has no display name set a default display name will be returned.
String getActorDisplayName(TalkLocalizations localizations, spreed.$ChatMessageInterface chatMessage) {
  final actorDisplayName = chatMessage.actorDisplayName;

  if (actorDisplayName.isEmpty && chatMessage.actorType == spreed.ActorType.guests) {
    return localizations.actorGuest;
  }

  return actorDisplayName;
}

/// Renders the [chatMessage] as a rich [TextSpan].
TextSpan buildChatMessage({
  required spreed.$ChatMessageInterface chatMessage,
  bool isPreview = false,
  TextStyle? style,
}) {
  var message = chatMessage.message;
  if (isPreview) {
    message = message.replaceAll('\n', ' ');
  }

  final unusedParameters = <String, spreed.RichObjectParameter>{};

  var parts = [message];
  for (final entry in chatMessage.messageParameters.entries) {
    final newParts = <String>[];

    var found = false;
    for (final part in parts) {
      final p = part.split('{${entry.key}}');
      newParts.addAll(p.intersperse('{${entry.key}}'));
      if (p.length > 1) {
        found = true;
      }
    }

    if (!found) {
      unusedParameters[entry.key] = entry.value;
    }

    parts = newParts;
  }

  final children = <InlineSpan>[];

  for (final entry in unusedParameters.entries) {
    if (entry.key == 'actor' || entry.key == 'user') {
      continue;
    }

    children
      ..add(
        buildRichObjectParameter(
          parameter: entry.value,
          textStyle: style,
          isPreview: isPreview,
        ),
      )
      ..add(const TextSpan(text: '\n'));
  }

  for (final part in parts) {
    var match = false;
    for (final entry in chatMessage.messageParameters.entries) {
      if ('{${entry.key}}' == part) {
        children.add(
          buildRichObjectParameter(
            parameter: entry.value,
            textStyle: style,
            isPreview: isPreview,
          ),
        );
        match = true;
        break;
      }
    }

    if (!match) {
      children.add(
        TextSpan(
          text: part,
        ),
      );
    }
  }

  return TextSpan(
    style: style,
    children: children,
  );
}

/// Renders a rich object [parameter] to be interactive.
InlineSpan buildRichObjectParameter({
  required spreed.RichObjectParameter parameter,
  required TextStyle? textStyle,
  required bool isPreview,
}) {
  Widget child;

  const mentionTypes = ['user', 'call', 'guest', 'user-group', 'group'];
  if (mentionTypes.contains(parameter.type)) {
    child = TalkRichObjectMention(
      parameter: parameter,
      textStyle: textStyle,
    );
  } else {
    if (isPreview) {
      child = Text(parameter.name);
    } else {
      switch (parameter.type) {
        case 'file':
          child = TalkRichObjectFile(
            parameter: parameter,
            textStyle: textStyle,
          );
        case 'deck-card':
          child = TalkRichObjectDeckCard(
            parameter: parameter,
          );
        default:
          child = TalkRichObjectFallback(
            parameter: parameter,
            textStyle: textStyle,
          );
      }
    }
  }

  return WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: child,
  );
}

/// Displays a preview of the [chatMessage] including the display name of the sender.
class TalkMessagePreview extends StatelessWidget {
  /// Creates a new Talk message preview.
  const TalkMessagePreview({
    required this.actorId,
    required this.roomType,
    required this.chatMessage,
    super.key,
  });

  /// ID of the current actor.
  final String actorId;

  /// Type of the room
  final spreed.RoomType roomType;

  /// {@macro TalkMessage.chatMessage}
  final spreed.$ChatMessageInterface chatMessage;

  @override
  Widget build(BuildContext context) {
    String? actorName;
    if (chatMessage.messageType != spreed.MessageType.system) {
      if (chatMessage.actorId == actorId) {
        actorName = TalkLocalizations.of(context).actorSelf;
      } else if (!roomType.isSingleUser) {
        actorName = getActorDisplayName(TalkLocalizations.of(context), chatMessage);
      }
    }

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        children: [
          if (actorName != null)
            TextSpan(
              text: '$actorName: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          buildChatMessage(
            chatMessage: chatMessage,
            isPreview: true,
          ),
        ],
      ),
    );
  }
}

/// Displays a Talk chat message in the right way based on the message type.
class TalkMessage extends StatelessWidget {
  /// Creates a new Talk message.
  const TalkMessage({
    required this.chatMessage,
    required this.lastCommonRead,
    this.previousChatMessage,
    this.isParent = false,
    super.key,
  });

  /// {@template TalkMessage.chatMessage}
  /// The chat message to display.
  /// {@endtemplate}
  final spreed.$ChatMessageInterface chatMessage;

  /// {@macro TalkRoomBloc.lastCommonRead}
  final int? lastCommonRead;

  /// {@template TalkMessage.previousChatMessage}
  /// The previous chat message.
  /// {@endtemplate}
  final spreed.$ChatMessageInterface? previousChatMessage;

  /// {@template TalkMessage.isParent}
  /// Whether the displayed chat message is a parent chat message that was replied to.
  /// {@endtemplate}
  final bool isParent;

  @override
  Widget build(BuildContext context) {
    if (chatMessage.messageType == spreed.MessageType.system) {
      return TalkSystemMessage(
        chatMessage: chatMessage,
        previousChatMessage: previousChatMessage,
      );
    }

    return TalkCommentMessage(
      chatMessage: chatMessage,
      lastCommonRead: lastCommonRead,
      previousChatMessage: previousChatMessage,
      isParent: isParent,
    );
  }
}

/// Displays a system chat message.
class TalkSystemMessage extends StatelessWidget {
  /// Creates a new Talk system message.
  const TalkSystemMessage({
    required this.chatMessage,
    required this.previousChatMessage,
    super.key,
  });

  /// {@macro TalkMessage.chatMessage}
  final spreed.$ChatMessageInterface chatMessage;

  /// {@macro TalkMessage.previousChatMessage}
  final spreed.$ChatMessageInterface? previousChatMessage;

  // Keep this in sync with https://github.com/nextcloud/spreed/blob/24b1dc8f8d6fa30b0c6dec95f27b69ca59314633/src/store/conversationsStore.js#L706
  static const _ignoredMessages = {
    'reaction',
    'reaction_revoked',
    'reaction_deleted',
    'message_deleted',
    'poll_voted',
  };

  @override
  Widget build(BuildContext context) {
    if (_ignoredMessages.contains(chatMessage.systemMessage)) {
      return const SizedBox.shrink();
    }

    final groupMessages = previousChatMessage?.messageType == spreed.MessageType.system;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: groupMessages ? 2.5 : 10),
      child: Center(
        child: RichText(
          text: buildChatMessage(
            chatMessage: chatMessage,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ),
    );
  }
}

/// Displays a parent chat message that was replied to.
class TalkParentMessage extends StatelessWidget {
  /// Creates a new Talk parent message.
  const TalkParentMessage({
    required this.parentChatMessage,
    required this.lastCommonRead,
    super.key,
  });

  /// The parent chat message.
  ///
  /// Do not pass the child chat message.
  final spreed.$ChatMessageInterface parentChatMessage;

  /// {@macro TalkRoomBloc.lastCommonRead}
  final int? lastCommonRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondaryContainer,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TalkMessage(
        chatMessage: parentChatMessage,
        lastCommonRead: lastCommonRead,
        isParent: true,
      ),
    );
  }
}

/// Displays a comment chat message including voice messages, recorded audio and video and reactions.
class TalkCommentMessage extends StatefulWidget {
  /// Creates a new Talk comment message.
  const TalkCommentMessage({
    required this.chatMessage,
    required this.lastCommonRead,
    this.previousChatMessage,
    this.isParent = false,
    super.key,
  });

  /// {@macro TalkMessage.chatMessage}
  final spreed.$ChatMessageInterface chatMessage;

  /// {@macro TalkRoomBloc.lastCommonRead}
  final int? lastCommonRead;

  /// {@macro TalkMessage.previousChatMessage}
  final spreed.$ChatMessageInterface? previousChatMessage;

  /// {@macro TalkMessage.isParent}
  final bool isParent;

  @override
  State<TalkCommentMessage> createState() => _TalkCommentMessageState();
}

class _TalkCommentMessageState extends State<TalkCommentMessage> {
  bool hoverState = false;
  bool menuOpen = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final date = DateTimeUtils.fromSecondsSinceEpoch(
      tz.UTC,
      widget.chatMessage.timestamp,
    );
    tz.TZDateTime? previousDate;
    if (widget.previousChatMessage != null) {
      previousDate = DateTimeUtils.fromSecondsSinceEpoch(
        tz.UTC,
        widget.previousChatMessage!.timestamp,
      );
    }

    final separateMessages = widget.chatMessage.actorId != widget.previousChatMessage?.actorId ||
        widget.previousChatMessage?.messageType == spreed.MessageType.system ||
        previousDate == null ||
        date.difference(previousDate) > const Duration(minutes: 3);

    Widget? displayName;
    Widget? avatar;
    Widget? time;
    if (separateMessages) {
      displayName = Text(
        getActorDisplayName(TalkLocalizations.of(context), widget.chatMessage),
        style: textTheme.labelSmall,
      );

      if (!widget.isParent) {
        avatar = TalkActorAvatar(
          actorId: widget.chatMessage.actorId,
          actorType: widget.chatMessage.actorType,
        );

        time = Text(
          _timeFormat.format(date),
          style: textTheme.labelSmall,
        );
      }
    }

    Widget? parent;
    if (widget.chatMessage
        case spreed.ChatMessageWithParent(
          parent: final p,
          messageType: != spreed.MessageType.commentDeleted,
        ) when p != null && !widget.isParent) {
      parent = TalkParentMessage(
        parentChatMessage: p,
        lastCommonRead: widget.lastCommonRead,
      );
    }

    double topMargin;
    if (widget.isParent) {
      topMargin = 5;
    } else if (separateMessages) {
      topMargin = 20;
    } else {
      topMargin = 0;
    }

    Widget text = RichText(
      maxLines: widget.isParent ? 1 : null,
      overflow: widget.isParent ? TextOverflow.ellipsis : TextOverflow.visible,
      text: buildChatMessage(
        chatMessage: widget.chatMessage,
        isPreview: widget.isParent,
        style: widget.isParent || widget.chatMessage.messageType == spreed.MessageType.commentDeleted
            ? textTheme.bodySmall
            : textTheme.bodyMedium,
      ),
    );
    if (widget.chatMessage.messageType == spreed.MessageType.commentDeleted) {
      text = Row(
        children: [
          Icon(
            AdaptiveIcons.cancel,
            size: textTheme.bodySmall!.fontSize,
          ),
          const SizedBox(
            width: 2.5,
          ),
          text,
        ],
      );
    }

    final accountsBloc = NeonProvider.of<AccountsBloc>(context);
    final account = accountsBloc.activeAccount.value!;

    return Container(
      margin: EdgeInsets.only(
        top: topMargin,
        bottom: 5,
      ),
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            hoverState = true;
          });
        },
        onExit: (_) {
          setState(() {
            hoverState = false;
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.isParent)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(
                  width: 40,
                  child: avatar,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (displayName != null) displayName,
                  if (parent != null) parent,
                  text,
                  if (!widget.isParent && widget.chatMessage.reactions.isNotEmpty)
                    TalkReactions(
                      reactions: widget.chatMessage.reactions,
                    ),
                ]
                    .intersperse(
                      const SizedBox(
                        height: 5,
                      ),
                    )
                    .toList(),
              ),
            ),
            if (time != null || !widget.isParent)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (time != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, left: 10),
                      child: time,
                    ),
                  if (!widget.isParent &&
                      widget.lastCommonRead != null &&
                      account.username == widget.chatMessage.actorId)
                    Padding(
                      padding: const EdgeInsets.only(top: 2.5, left: 10),
                      child: TalkReadIndicator(
                        chatMessage: widget.chatMessage,
                        lastCommonRead: widget.lastCommonRead!,
                      ),
                    ),
                ],
              ),
            if (!widget.isParent)
              SizedBox.square(
                dimension: 40,
                child: hoverState || menuOpen ? _buildPopupMenuButton(widget.chatMessage) : null,
              ),
          ],
        ),
      ),
    );
  }

  Widget? _buildPopupMenuButton(spreed.$ChatMessageInterface chatMessage) {
    final children = [
      // All comment messages should always be replyable, so this is just a safeguard in case it ever changes.
      if (chatMessage.isReplyable)
        MenuItemButton(
          child: Text(TalkLocalizations.of(context).roomMessageReply),
          onPressed: () {
            setState(() {
              menuOpen = false;
            });

            NeonProvider.of<TalkRoomBloc>(context).setReplyChatMessage(chatMessage);
          },
        ),
    ];

    if (children.isEmpty) {
      return null;
    }

    return MenuAnchor(
      menuChildren: children,
      onOpen: () {
        setState(() {
          menuOpen = true;
        });
      },
      onClose: () {
        setState(() {
          menuOpen = false;
        });
      },
      builder: (context, controller, child) => IconButton(
        onPressed: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        },
        icon: const Icon(Icons.more_vert),
      ),
    );
  }
}
