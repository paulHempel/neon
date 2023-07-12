import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:nextcloud/nextcloud.dart';

/// [Color] constants which represent Nextcloud's
/// [color palette](https://docs.nextcloud.com/server/latest/developer_manual/design/foundations.html#color).
abstract final class NcColors {
  /// Nextcloud blue.
  ///
  /// The default primary clolor as specified by the
  /// [design guidlines](https://docs.nextcloud.com/server/latest/developer_manual/design/foundations.html#primary-color).
  static const Color primary = Color(0xFF0082C9);

  /// The [ColorScheme.background] color used on OLED devices.
  ///
  /// This color is only used at the users discretion.
  static const Color oledBackground = Colors.black;
}

@internal
extension UserStatusTypeColors on UserStatusType {
  Color? get color => switch (this) {
        UserStatusType.online => const Color(0xFF49B382),
        UserStatusType.away => const Color(0xFFF4A331),
        UserStatusType.dnd => const Color(0xFFED484C),
        _ => null,
      };
}
