import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intersperse/intersperse.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/theme.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_framework/widgets.dart';
import 'package:neon_notifications/l10n/localizations.dart';
import 'package:neon_notifications/src/blocs/notifications.dart';
import 'package:nextcloud/ids.dart';
import 'package:nextcloud/notifications.dart' as notifications;
import 'package:timezone/timezone.dart' as tz;

class NotificationsMainPage extends StatefulWidget {
  const NotificationsMainPage({
    super.key,
  });

  @override
  State<NotificationsMainPage> createState() => _NotificationsMainPageState();
}

class _NotificationsMainPageState extends State<NotificationsMainPage> {
  late NotificationsBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = NeonProvider.of<NotificationsBlocInterface>(context) as NotificationsBloc;

    bloc.errors.listen((error) {
      NeonError.showSnackbar(context, error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: StreamBuilder(
        stream: bloc.unreadCounter,
        builder: (context, snapshot) {
          final unreadCount = snapshot.data ?? 0;
          return FloatingActionButton(
            onPressed: unreadCount > 0 ? bloc.deleteAllNotifications : null,
            tooltip: NotificationsLocalizations.of(context).notificationsDismissAll,
            child: const Icon(MdiIcons.checkAll),
          );
        },
      ),
      body: ResultBuilder.behaviorSubject(
        subject: bloc.notifications,
        builder: (context, notifications) => NeonListView(
          scrollKey: 'notifications-notifications',
          isLoading: notifications.isLoading,
          error: notifications.error,
          onRefresh: bloc.refresh,
          itemCount: notifications.data?.length ?? 0,
          itemBuilder: (context, index) => _buildNotification(context, notifications.data![index]),
        ),
      ),
    );
  }

  Widget _buildNotification(
    BuildContext context,
    notifications.Notification notification,
  ) {
    final app = NeonProvider.of<BuiltSet<AppImplementation>>(context).tryFind(notification.app);

    return ListTile(
      title: Text(notification.subject),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (notification.message.isNotEmpty)
            Text(
              notification.message,
              overflow: TextOverflow.ellipsis,
            ),
          RelativeTime(
            date: tz.TZDateTime.parse(tz.UTC, notification.datetime),
          ),
          if (notification.actions.isNotEmpty)
            Row(
              children: notification.actions.map(_buildAction).toList(),
            ),
        ]
            .intersperse(
              const SizedBox(
                height: 5,
              ),
            )
            .toList(),
      ),
      leading: app != null
          ? app.buildIcon(
              size: largeIconSize,
            )
          : SizedBox.fromSize(
              size: const Size.square(largeIconSize),
              child: NeonUriImage(
                uri: Uri.parse(notification.icon!),
                size: const Size.square(largeIconSize),
                svgColorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                account: NeonProvider.of<Account>(context),
              ),
            ),
      onTap: () async {
        if (notification.app == AppIDs.notifications) {
          return;
        }
        if (app != null) {
          // TODO: use go_router once implemented
          NeonProvider.of<AppsBloc>(context).setActiveApp(app.id);
        } else {
          await showUnimplementedDialog(
            context: context,
            title: NotificationsLocalizations.of(context).notificationAppNotImplementedYet,
          );
        }
      },
      onLongPress: () {
        bloc.deleteNotification(notification.notificationId);
      },
    );
  }

  Widget _buildAction(notifications.NotificationAction action) {
    return ElevatedButton(
      onPressed: () {
        context.go(action.link);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: action.primary ? Theme.of(context).colorScheme.onPrimary : null,
        backgroundColor: action.primary ? Theme.of(context).colorScheme.primary : null,
      ),
      child: Text(action.label),
    );
  }
}
