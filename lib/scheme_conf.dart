

import 'dart:io';

import 'package:get/get.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart';

class SchemeList {
  final String name;
  bool active;


  SchemeList(this.name, {this.active: true});


}

class SchemeConf {
  RxList<SchemeList>? _schemeList = RxList();

  RxList<SchemeList>? get schemeList => _schemeList;

  void load() {
    var dir = Directory('/usr/share/rime-data/');
    var content = File(join(dir.path, 'default.yaml')).readAsStringSync();
    var doc = loadYaml(content);

    // schema list
    for (var item in doc['schema_list']) {
      _schemeList?.add(SchemeList(item.values.first));
    }
  }
}
