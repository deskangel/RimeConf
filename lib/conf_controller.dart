import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import 'log_helper.dart';

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

    schemeList = SchemeConf().load();
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
}

class SchemeConf {
  RxList<String> load() {
    var dir = Directory('/usr/share/rime-data/');
    var content = File(join(dir.path, 'default.yaml')).readAsStringSync();
    var doc = loadYaml(content);

    RxList<String> list = RxList();
    for (var item in doc['schema_list']) {
      list.add(item.values.first);
    }

    return list;
  }
}
