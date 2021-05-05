import 'dart:io';

String? getHomePath() {
  String? home;
  var env = Platform.environment;
  if (Platform.isLinux || Platform.isMacOS) {
    home = env['HOME'];
  } else {
    throw ('not implemented.');
  }

  return home;
}
