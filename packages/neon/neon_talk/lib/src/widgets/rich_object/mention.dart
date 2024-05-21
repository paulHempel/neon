import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/theme.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_framework/widgets.dart';
import 'package:nextcloud/spreed.dart' as spreed;

/// Displays a mention chip from a rich object.
class TalkRichObjectMention extends StatelessWidget {
  /// Create a new Talk rich object mention.
  const TalkRichObjectMention({
    required this.parameter,
    required this.textStyle,
    super.key,
  });

  /// The parameter to display.
  final spreed.RichObjectParameter parameter;

  /// The TextStyle to applied to all text elements in this rich object.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final Widget child;
    final bool highlight;

    switch (parameter.type) {
      case spreed.RichObjectParameter_Type.user:
        final accountsBloc = NeonProvider.of<AccountsBloc>(context);
        final account = accountsBloc.activeAccount.value!;

        highlight = account.username == parameter.id;
        child = NeonUserAvatar(
          username: parameter.id,
          showStatus: false,
        );
      case spreed.RichObjectParameter_Type.call:
        highlight = true;
        child = CircleAvatar(
          child: ClipOval(
            child: NeonUriImage(
              uri: Uri.parse(parameter.iconUrl!),
            ),
          ),
        );
      case spreed.RichObjectParameter_Type.guest:
        // TODO: Add highlighting when the mention is about the current guest user.
        highlight = false;
        child = CircleAvatar(
          child: Icon(AdaptiveIcons.person),
        );
      case spreed.RichObjectParameter_Type.userGroup || spreed.RichObjectParameter_Type.group:
        final accountsBloc = NeonProvider.of<AccountsBloc>(context);
        final userDetailsBloc = accountsBloc.activeUserDetailsBloc;
        final groups = userDetailsBloc.userDetails.valueOrNull?.data?.groups ?? BuiltList();

        highlight = groups.contains(parameter.id);
        child = CircleAvatar(
          child: Icon(AdaptiveIcons.group),
        );
      default:
        child = throw UnimplementedError('Unknown mention type: $parameter'); // coverage:ignore-line
    }

    Color? backgroundColor;
    Color? foregroundColor;
    if (highlight) {
      backgroundColor = Theme.of(context).colorScheme.primary;
      foregroundColor = Theme.of(context).colorScheme.onPrimary;
    }

    return Chip(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsetsDirectional.only(end: 4, start: -4),
      avatar: Padding(
        padding: const EdgeInsets.all(6),
        child: child,
      ),
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.minimumDensity,
        vertical: VisualDensity.minimumDensity,
      ),
      labelStyle: textStyle,
      label: Text(
        parameter.name,
        style: TextStyle(
          color: foregroundColor,
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }
}
