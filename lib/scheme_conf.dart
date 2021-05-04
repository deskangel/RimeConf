

import 'dart:io';

import 'package:get/get.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart';

class SchemeConf {
  RxList<String>? _schemeList = RxList();

  RxList<String>? get schemeList => _schemeList;

  void load() {
    var dir = Directory('/usr/share/rime-data/');
    var content = File(join(dir.path, 'default.yaml')).readAsStringSync();
    var doc = loadYaml(content);

    // schema list
    for (var item in doc['schema_list']) {
      _schemeList?.add(item.values.first);
    }
  }
}
