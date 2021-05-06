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

class Utils {
  factory Utils() => _getInstance();
  static Utils get instance => _getInstance();
  static Utils? _instance;

  Utils._internal();

  static Utils _getInstance() {
    if (_instance == null) {
      _instance = Utils._internal();
    }

    return _instance!;
  }
}
