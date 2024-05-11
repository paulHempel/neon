import 'dart:async';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/blocs/user_details.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/router.dart';
import 'package:neon_framework/src/settings/widgets/custom_settings_tile.dart';
import 'package:neon_framework/src/settings/widgets/option_settings_tile.dart';
import 'package:neon_framework/src/settings/widgets/settings_category.dart';
import 'package:neon_framework/src/settings/widgets/settings_list.dart';
import 'package:neon_framework/src/theme/dialog.dart';
import 'package:neon_framework/src/utils/account_options.dart';
import 'package:neon_framework/src/utils/adaptive.dart';
import 'package:neon_framework/src/widgets/dialog.dart';
import 'package:neon_framework/widgets.dart';
import 'package:nextcloud/provisioning_api.dart' as provisioning_api;
import 'package:url_launcher/url_launcher.dart';

/// Account settings page.
///
/// Displays settings for an [Account]. Settings are specified as `Option`s.
@internal
class AccountSettingsPage extends StatefulWidget {
  /// Creates a new account settings page for the given [account].
  const AccountSettingsPage({
    required this.bloc,
    required this.account,
    super.key,
  });

  /// The bloc managing the accounts and their settings.
  final AccountsBloc bloc;

  /// The account to display the settings for.
  final Account account;

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  late final options = widget.bloc.getOptionsFor(widget.account);
  late final userDetailsBloc = widget.bloc.getUserDetailsBlocFor(widget.account);
  late final name = widget.account.humanReadableID;
  late final StreamSubscription<Object> errorSubscription;

  @override
  void initState() {
    super.initState();

    errorSubscription = userDetailsBloc.errors.listen((error) {
      NeonError.showSnackbar(context, error);
    });
  }

  @override
  void dispose() {
    unawaited(errorSubscription.cancel());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(name),
      actions: [
        IconButton(
          onPressed: () async {
            final decision = await showAdaptiveDialog<AccountDeletion>(
              context: context,
              builder: (context) => NeonAccountDeletionDialog(
                account: widget.account,
              ),
            );

            switch (decision) {
              case null:
                break;
              case AccountDeletion.remote:
                await launchUrl(
                  widget.account.serverURL.replace(
                    path: '${widget.account.serverURL.path}/index.php/settings/user/drop_account',
                  ),
                );
              case AccountDeletion.local:
                final isActive = widget.bloc.activeAccount.valueOrNull == widget.account;

                options.reset();
                widget.bloc.removeAccount(widget.account);

                if (!context.mounted) {
                  return;
                }

                if (isActive) {
                  const HomeRoute().go(context);
                } else {
                  Navigator.of(context).pop();
                }
            }
          },
          tooltip: NeonLocalizations.of(context).accountOptionsRemove,
          icon: const Icon(Icons.logout),
        ),
        IconButton(
          onPressed: () async {
            final content =
                '${NeonLocalizations.of(context).settingsResetForConfirmation(name)} ${NeonLocalizations.of(context).settingsResetForExplanation}';
            final decision = await showAdaptiveDialog<bool>(
              context: context,
              builder: (context) => NeonConfirmationDialog(
                icon: const Icon(Icons.restart_alt),
                title: NeonLocalizations.of(context).settingsReset,
                content: Text(content),
              ),
            );

            if (decision ?? false) {
              options.reset();
            }
          },
          tooltip: NeonLocalizations.of(context).settingsResetFor(name),
          icon: const Icon(MdiIcons.cogRefresh),
        ),
      ],
    );

    final body = ResultBuilder.behaviorSubject(
      subject: userDetailsBloc.userDetails,
      builder: (context, userDetails) {
        final categories = <Widget>[_buildGeneralSection(context, options)];

        if (userDetails.hasError) {
          categories.add(
            NeonError(
              userDetails.error,
              type: NeonErrorType.listTile,
              onRetry: userDetailsBloc.refresh,
            ),
          );
        }
        if (userDetails.hasData) {
          categories
            ..add(_buildStorageSection(context, userDetails.requireData))
            ..add(_buildProfileSection(context, userDetailsBloc, userDetails.requireData));
        }

        return SettingsList(
          categories: categories,
        );
      },
    );

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: NeonDialogTheme.of(context).constraints,
            child: body,
          ),
        ),
      ),
    );
  }

  Widget _buildStorageSection(
    BuildContext context,
    provisioning_api.UserDetails userDetails,
  ) {
    return SettingsCategory(
      title: Text(NeonLocalizations.of(context).accountOptionsCategoryStorageInfo),
      tiles: [
        CustomSettingsTile(
          title: LinearProgressIndicator(
            value: userDetails.quota.relative / 100,
            minHeight: isCupertino(context) ? 15 : null,
            borderRadius: BorderRadius.circular(isCupertino(context) ? 5 : 3),
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          subtitle: Text(
            NeonLocalizations.of(context).accountOptionsQuotaUsedOf(
              filesize(userDetails.quota.used, 1),
              filesize(userDetails.quota.total, 1),
              userDetails.quota.relative.toString(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    UserDetailsBloc userDetailsBloc,
    provisioning_api.UserDetails userDetails,
  ) {
    final localizations = NeonLocalizations.of(context);

    final tiles = <Widget>[];
    for (final property in [
      (
        key: 'displayname',
        value: userDetails.displayname,
        scope: userDetails.displaynameScope!,
        label: localizations.accountOptionsProfileFullName,
        keyboardType: null,
      ),
      (
        key: 'email',
        value: userDetails.email,
        scope: userDetails.emailScope!,
        label: localizations.accountOptionsProfileEmail,
        keyboardType: TextInputType.emailAddress,
      ),
      (
        key: 'phone',
        value: userDetails.phone,
        scope: userDetails.phoneScope!,
        label: localizations.accountOptionsProfilePhoneNumber,
        keyboardType: TextInputType.phone,
      ),
      (
        key: 'address',
        value: userDetails.address,
        scope: userDetails.addressScope!,
        label: localizations.accountOptionsProfileLocation,
        keyboardType: TextInputType.streetAddress,
      ),
      (
        key: 'language',
        value: userDetails.language,
        scope: null,
        label: localizations.accountOptionsProfileLanguage,
        keyboardType: null,
      ),
      (
        key: 'locale',
        value: userDetails.locale,
        scope: null,
        label: localizations.accountOptionsProfileLocale,
        keyboardType: null,
      ),
      (
        key: 'website',
        value: userDetails.website,
        scope: userDetails.websiteScope!,
        label: localizations.accountOptionsProfileWebsite,
        keyboardType: TextInputType.url,
      ),
      (
        key: 'twitter',
        value: userDetails.twitter,
        scope: userDetails.twitterScope!,
        label: localizations.accountOptionsProfileTwitter,
        keyboardType: null,
      ),
      (
        key: 'fediverse',
        value: userDetails.fediverse,
        scope: userDetails.fediverseScope!,
        label: localizations.accountOptionsProfileFediverse,
        keyboardType: null,
      ),
      (
        key: 'organisation',
        value: userDetails.organisation,
        scope: userDetails.organisationScope!,
        label: localizations.accountOptionsProfileOrganisation,
        keyboardType: null,
      ),
      (
        key: 'role',
        value: userDetails.role,
        scope: userDetails.roleScope!,
        label: localizations.accountOptionsProfileRole,
        keyboardType: null,
      ),
      (
        key: 'about',
        value: userDetails.biography,
        scope: userDetails.biographyScope!,
        label: localizations.accountOptionsProfileAbout,
        keyboardType: null,
      ),
    ]) {
      final scope = property.scope;
      Widget? scopeButton;
      if (scope != null) {
        scopeButton = IconButton(
          icon: Icon(
            switch (scope) {
              'v2-local' || 'private' => Icons.lock,
              'v2-federated' || 'contacts' => Icons.groups,
              'v2-published' || 'public' => Icons.web,
              'v2-private' => Icons.phone_android,
              _ => throw UnimplementedError('Unknown scope $scope'),
            },
          ),
          onPressed: () {},
        );
      }

      tiles.add(
        CustomSettingsTile(
          title: TextField(
            controller: TextEditingController(
              text: property.value,
            ),
            decoration: InputDecoration(
              labelText: property.label,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixIcon: scopeButton,
            ),
            keyboardType: property.keyboardType,
            onChanged: (value) {
              userDetailsBloc.updateProperty(property.key, value);
            },
          ),
        ),
      );
    }

    return SettingsCategory(
      title: Text(NeonLocalizations.of(context).accountOptionsCategoryProfile),
      tiles: tiles,
    );
  }

  Widget _buildGeneralSection(BuildContext context, AccountOptions options) {
    return SettingsCategory(
      title: Text(NeonLocalizations.of(context).optionsCategoryGeneral),
      tiles: [
        SelectSettingsTile(
          option: options.initialApp,
        ),
      ],
    );
  }
}
