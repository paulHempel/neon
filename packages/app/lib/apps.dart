import 'package:neon/models.dart';
import 'package:neon_files/neon_files.dart';
import 'package:neon_news/neon_news.dart';
import 'package:neon_notes/neon_notes.dart';
import 'package:neon_notifications/neon_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<AppImplementation> getAppImplementations(
  final SharedPreferences sharedPreferences,
) =>
    [
      FilesApp(sharedPreferences),
      NewsApp(sharedPreferences),
      NotesApp(sharedPreferences),
      NotificationsApp(sharedPreferences),
    ];
