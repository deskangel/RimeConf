import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:rimeconf/utils/utils.dart';
import 'package:yaml/yaml.dart';

import 'utils/log_helper.dart';

class Speller {
  bool cch = false;
  bool ssh = false;
  bool zzh = false;
  bool ln = false;
  bool rl = false;
  bool fh = false;
  bool anang = false;
  bool eneng = false;
  bool ining = false;

  bool abbrev = false;

  String toYaml() {
    String yaml = '';

    if (cch) {
      yaml += '''
    - derive/^ch/c/             # ch => c
    - derive/^c/ch/             # c => ch
      \n''';
    }
    if (ssh) {
      yaml += '''
    - derive/^sh/s/             # sh => s
    - derive/^s/sh/             # s => sh
      \n''';
    }
    if (zzh) {
      yaml += '''
    - derive/^zh/z/             # zh => z
    - derive/^z/zh/             # z => zh
      \n''';
    }

    if (ln) {
      yaml += '''
    - derive/^n/l/                     # n => l
    - derive/^l/n/                     # l => n
      \n''';
    }

    if (rl) {
      yaml += '''
    - derive/^r/l/                     # r => l
    - derive/^l/r/                     # l => r
      \n''';
    }
    if (fh) {
      yaml += '''
    - derive/^f/h/                     # f => h
    - derive/^h/f/                     # h => f
      \n''';
    }

    if (anang) {
      yaml += '''
    - derive/an\$/ang/                     # an => ang
    - derive/ang\$/an/                     # ang => an
      \n''';
    }
    if (eneng) {
      yaml += '''
    - derive/en\$/eng/                     # en => eng
    - derive/eng\$/en/                     # eng => en
      \n''';
    }
    if (ining) {
      yaml += '''
    - derive/in\$/ing/                     # in => ing
    - derive/ing\$/in/                     # ing => in
      \n''';
    }

    if (abbrev) {
      yaml += '''
    # 模糊音定義先於簡拼定義，方可令簡拼支持以上模糊音
    - abbrev/^([a-z]).+\$/\$1/           # 簡拼（首字母）
    - abbrev/^([zcs]h).+\$/\$1/          # 簡拼（zh, ch, sh）
      \n''';
    }

    return yaml;
  }
}

class Switcher {
  final String name;
  final String states;
  bool reset;
  Switcher(this.name, this.states, {this.reset: false});

  String toYaml() {
    String yaml = '''
    - name: $name
      reset: ${reset ? 1 : 0}
      states: $states''';

    return yaml;
  }
}

class Schema extends GetxController {
  static const DEFAULT_DIR = '/usr/share/rime-data/';
  final String name;
  bool active;

  late final String _pathDefault;
  late final String _pathCustom;

  List<Switcher> _switches = [];

  List<Switcher> get switches => _switches;

  Speller _speller = Speller();
  Speller get speller => _speller;

  Schema(this.name, {this.active: false}) {
    _pathDefault = join(DEFAULT_DIR, '${this.name}.schema.yaml');

    var home = getHomePath();
    assert(home != null, 'home cannot found.');
    _pathCustom = join(home!, '.config/ibus/rime/', '${this.name}.custom.yaml');
  }

  void load() {
    var file = File(_pathCustom);
    if (!file.existsSync()) {
      file = File(_pathDefault);
    }
    if (!file.existsSync()) {
      logger.e('cannot find the config files');
      return;
    }

    var content = file.readAsStringSync();
    var doc = loadYaml(content);

    var docPatch = doc['patch'];

    // if use the custom config file, doc['switches'] would be null
    var switchersMap = doc['switches'] ?? docPatch?['switches'];
    assert(switchersMap != null, 'cannot find node patch nor switches');

    _switches.clear();
    for (var item in switchersMap) {
      YamlList v = item['states'];
      _switches.add(Switcher(item['name'], '["${v[0]}", "${v[1]}"]', reset: item['reset'] == 1));
    }

    var spellerList = docPatch == null ? [] : docPatch['speller/algebra'];
    for (var item in spellerList) {
      switch (item) {
        case 'derive/^ch/c/':
          speller.cch = true;
          break;
        case 'derive/^sh/s/':
          speller.ssh = true;
          break;
        case 'derive/^zh/z/':
          speller.zzh = true;
          break;

        case 'derive/^l/n/':
          speller.ln = true;
          break;
        case 'derive/^r/l/':
          speller.rl = true;
          break;
        case 'derive/^f/h/':
          speller.fh = true;
          break;
        // 韵母
        case 'derive/an\$/ang/':
          speller.anang = true;
          break;
        case 'derive/en\$/eng/':
          speller.eneng = true;
          break;
        case 'derive/in\$/ing/':
          speller.ining = true;
          break;
        // 简拼
        case 'abbrev/^([a-z]).+\$/\$1/':
          speller.abbrev = true;
          break;
      }
    }

    refresh();
  }

  void save() {
    String switcherList = '';
    for (var item in _switches) {
      switcherList += '${item.toYaml()}\n';
    }

    String doc = '''
# ${this.name}.custom.yaml
# encoding: utf-8
#
# 部署位置：
# ~/.config/ibus/rime  (Linux)
# ~/Library/Rime  (Mac OS)
# %APPDATA%\\Rime  (Windows)
#
# 於重新部署後生效

patch:
  # 导入朙月拼音扩充词库
  "translator/dictionary": luna_pinyin.extended
  # 导入自定义符号
  "punctuator/import_preset": symbols.custom
  # 匹配自定义符号
  "recognizer/patterns/punct": "^/([a-z]+|[0-9])\$"
  switches:
$switcherList

  # 以下皆为模糊音模板 #
  'speller/algebra':
    - erase/^xx\$/                      # 第一行保留

    # 模糊音定義
${_speller.toYaml()}

    # 反模糊音？
    # 誰說方言沒有普通話精確、有模糊音，就能有反模糊音。
    # 示例爲分尖團的中原官話：
    #- derive/^ji\$/zii/   # 在設計者安排下鳩佔鵲巢，尖音i只好雙寫了
    #- derive/^qi\$/cii/
    #- derive/^xi\$/sii/
    #- derive/^ji/zi/
    #- derive/^qi/ci/
    #- derive/^xi/si/
    #- derive/^ju/zv/
    #- derive/^qu/cv/
    #- derive/^xu/sv/
    # 韻母部份，只能從大面上覆蓋
    #- derive/^([bpm])o\$/\$1eh/          # bo => beh, ...
    #- derive/(^|[dtnlgkhzcs]h?)e\$/\$1eh/  # ge => geh, se => sheh, ...
    #- derive/^([gkh])uo\$/\$1ue/         # guo => gue, ...
    #- derive/^([gkh])e\$/\$1uo/          # he => huo, ...
    #- derive/([uv])e\$/\$1o/             # jue => juo, lve => lvo, ...
    #- derive/^fei\$/fi/                 # fei => fi
    #- derive/^wei\$/vi/                 # wei => vi
    #- derive/^([nl])ei\$/\$1ui/          # nei => nui, lei => lui
    - derive/^([nlzcs])un\$/\$1vn/       # lun => lvn, zun => zvn, ...
    #- derive/^([nlzcs])ong\$/\$1iong/    # long => liong, song => siong, ...
    # 這個辦法雖從拼寫上做出了區分，然而受詞典制約，候選字仍是混的。
    # 只有真正的方音輸入方案纔能做到！但「反模糊音」這個玩法快速而有效！

    # 模糊音定義先於簡拼定義，方可令簡拼支持以上模糊音
    - abbrev/^([a-z]).+\$/\$1/           # 簡拼（首字母）
    - abbrev/^([zcs]h).+\$/\$1/          # 簡拼（zh, ch, sh）

    # 以下是一組容錯拼寫，《漢語拼音》方案以前者爲正
    - derive/^([nl])ve\$/\$1ue/          # nve = nue, lve = lue
    - derive/^([jqxy])u/\$1v/           # ju = jv,
    - derive/un\$/uen/                  # gun = guen,
    - derive/ui\$/uei/                  # gui = guei,
    - derive/iu\$/iou/                  # jiu = jiou,

    # 自動糾正一些常見的按鍵錯誤
    - derive/([aeiou])ng\$/\$1gn/        # dagn => dang
    - derive/([dtngkhrzcs])o(u|ng)\$/\$1o/  # zho => zhong|zhou
    - derive/ong\$/on/                  # zhonguo => zhong guo
    - derive/ao\$/oa/                   # hoa => hao
    - derive/([iu])a(o|ng?)\$/a\$1\$2/    # tain => tian

  # 分尖團後 v => ü 的改寫條件也要相應地擴充：
  #'translator/preedit_format':
  #  - "xform/([nljqxyzcs])v/\$1ü/"
''';

    logger.i(doc);

    var file = File(_pathCustom);
    file.writeAsString(doc);
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
    var file = File(join(dir, 'default.custom.yaml'));
    if (!file.existsSync()) {
      return;
    }

    var content = file.readAsStringSync();
    var doc = loadYaml(content)['patch'];
    if (doc == null) {
      return;
    }

    for (var item in doc['schema_list'] ?? []) {
      _schemaList.where((scheme) => scheme.name == item.values.first).first.active = true;
    }

    var value = doc['menu']?['page_size'];
    if (value == null) {
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
      switchKeysString += '        ${item.key}: ${item.value}\n';
    }

    String doc = '''
# default.custom.yaml
# encoding: utf-8
#
# 部署位置：
# ~/.config/ibus/rime  (Linux)
# ~/Library/Rime  (Mac OS)
# %APPDATA%\\Rime  (Windows)
#
# 於重新部署後生效

patch:
  menu:
    page_size: $_pageSize
#  style/horizontal: false # 候选窗水平显示
  schema_list:
$usedSchemaList

# 定义按键切换策略：
# inline_ascii 在输入法的临时西文编辑区内输入字母、数字、符号、空格等，回车上屏后自动复位到中文
# commit_text 已输入的候选文字上屏并切换至英文输入模式
# commit_code 已输入的编码字符上屏并切换至英文输入模式
# noop 屏蔽該切換鍵

  ascii_composer:
      good_old_caps_lock: true
      switch_key:
$switchKeysString
    ''';
    logger.i(doc);

    var dir = '${getHomePath()!}/.config/ibus/rime/';

    var file = File(join(dir, 'default.custom.yaml'));
    file.writeAsString(doc);
  }
}
