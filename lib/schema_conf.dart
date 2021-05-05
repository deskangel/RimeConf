import 'dart:io';

import 'package:get/get.dart';
import 'package:rimeconf/utils.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart';

import 'log_helper.dart';

class Switcher {
  final String name;
  final String states;
  bool reset;
  Switcher(this.name, this.states, {this.reset: false});
}

class Schema extends GetxController {
  static const DEFAULT_DIR = '/usr/share/rime-data/';
  final String name;
  bool active;

  late final String _pathDefault;
  late final String _pathCustom;

  RxList<Switcher> _switches = RxList();

  RxList<Switcher> get switches => _switches;

  Schema(this.name, {this.active: true}) {
    _pathDefault = join(DEFAULT_DIR, '${this.name}.schema.yaml');

    var home = getHomePath();
    assert(home != null, 'home cannot found.');
    _pathCustom = join(home!, '${this.name}.custom.yaml');
  }

  void load() {
    var content = File(_pathDefault).readAsStringSync();
    var doc = loadYaml(content);

    _switches.clear();
    for (var item in doc['switches']) {
      _switches.add(Switcher(item['name'], item['states'].toString(), reset: item['reset'] == 1));
      logger.d('message');
    }
    refresh();
  }
}

class SchemaConf extends GetxController {
  RxList<Schema> _schemeList = RxList();

  RxList<Schema> get schemeList => _schemeList;

  void load() {
    var dir = Directory('/usr/share/rime-data/');
    var content = File(join(dir.path, 'default.yaml')).readAsStringSync();
    var doc = loadYaml(content);

    // schema list
    for (var item in doc['schema_list']) {
      _schemeList.add(Schema(item.values.first));
    }
    refresh();
  }
}
