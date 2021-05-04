import 'dart:io';

import 'package:get/get.dart';

import 'scheme_conf.dart';

class ConfCtrl extends GetxController {
  var count = 0.obs;
  increment() {
    count = 2.obs;
    refresh();
  }
  RxList<String>? schemeList;
  // var length = 0.obs;
  RxInt get length => schemeList?.length.obs ?? 0.obs;

  void readConf() {


    // var dir = Directory('$home/.config/ibus/rime/');
    // var path = join(dir.path, 'default.custom.yaml');
    // var content = File(path).readAsStringSync();
    // var doc = loadYaml(content);

    // logger.d(jsonEncode(doc));

    var schemeConf = SchemeConf()..load();
    schemeList =   schemeConf.schemeList;
    refresh();
  }

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

  void remove(int index) {
    this.schemeList?.removeAt(index);
    refresh();
  }
}


