import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:rimeconf/utils/utils.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart';

import 'utils/log_helper.dart';

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

  Schema(this.name, {this.active: false}) {
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
  static const List<String> SWITCH_KEYS = ['屏蔽', '编码字符上屏后切换至英文', '候选文字上屏后切换至英文', '临时输入后自动复位为中文'];
  static const List<String> CANDIDATE_COUNT = ['5', '6', '7', '8', '9'];

  RxList<Schema> _schemaList = RxList();
  RxList<Schema> get schemeList => _schemaList;

  var _pageSize = CANDIDATE_COUNT[0].obs;
  String get pageSize => _pageSize.value;
  set pageSize(String value) {
    _pageSize = value.obs;
  }

  Map<String, String> switchKeys = {
    'Caps_Lock': 'noop',
    'Shift_L': 'commit_code',
    'Shift_R': 'commit_code',
    'Control_L': 'noop',
    'Control_R': 'noop',
  };
  setSwitchkey(String key, String value) {
    if (value == SWITCH_KEYS[0]) {
      switchKeys[key] = 'noop';
    } else if (value == SWITCH_KEYS[1]) {
      switchKeys[key] = 'commit_code';
    } else if (value == SWITCH_KEYS[2]) {
      switchKeys[key] = 'commit_text';
    } else if (value == SWITCH_KEYS[3]) {
      switchKeys[key] = 'inline_ascii';
    }
  }

  String convertSwitchKeyString(String value) {
    switch (value) {
      case 'noop':
        return '屏蔽';
      case 'commit_code':
        return '编码字符上屏后切换至英文';
      case 'commit_text':
        return '候选文字上屏后切换至英文';
      case 'inline_ascii':
        return '临时输入后自动复位为中文';
      default:
        return '屏蔽';
    }
  }

  void load() {
    _loadDefault();
    _loadCustom();
    refresh();
  }

  void _loadDefault() {
    var dir = '/usr/share/rime-data/';
    var content = File(join(dir, 'default.yaml')).readAsStringSync();
    var doc = loadYaml(content);

    // schema list
    _schemaList.clear();
    for (var item in doc['schema_list']) {
      _schemaList.add(Schema(item.values.first));
    }
  }

  void _loadCustom() {
    var dir = '${getHomePath()!}/.config/ibus/rime/';
    var file = File(join(dir, 'd.custom.yaml'));
    if (!file.existsSync()) {
      return;
    }

    var content = file.readAsStringSync();
    var doc = loadYaml(content)['patch'];
    if (doc == null) {
      return;
    }

    for (var item in doc['schema_list']) {
      _schemaList.where((scheme) => scheme.name == item.values.first).first.active = true;
    }

    var value = doc['menu']?['page_size'];
    if (value != null) {
      return;
    }
    this.pageSize = value.toString();
  }

  void save() {
    String usedSchemaList = '';
    for (var item in _schemaList) {
      if (item.active) {
        usedSchemaList += '    - schema: ${item.name}\n';
      }
    }

    String switchKeysString = '';
    for (var item in switchKeys.entries) {
      switchKeysString += '      ${item.key}: ${item.value}\n';
    }

    String doc = '''
patch:
  menu:
    page_size: $_pageSize
  schema_list:
$usedSchemaList
  ascii_composer:
      good_old_caps_lock: true
      switch_key:
$switchKeysString
    ''';
    logger.i(doc);

    var dir = '${getHomePath()!}/.config/ibus/rime/';

    var file = File(join(dir, 'd.custom.yaml'));
    file.writeAsStringSync(doc);
  }
}
