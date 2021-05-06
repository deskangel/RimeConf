import 'package:flutter/material.dart';
import 'package:rimeconf/spinner_title.dart';
import 'package:rimeconf/utils/dropdown_listtile.dart';

class GeneralTab extends StatefulWidget {
  GeneralTab({Key? key}) : super(key: key);

  @override
  _GeneralTabState createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> {
  static const List<String> switchKey = ['屏蔽', '编码字符上屏后切换至英文', '候选文字上屏后切换至英文', '临时输入后自动复位为中文'];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpinnerTitle(title: '每页候选数量', value: 0, values: ['5', '6', '7', '8', '9']),
          Text(
            '按键切换策略',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownListTile(items: switchKey, title: 'Caps_Lock', onChange: (v) {}),
          DropdownListTile(items: switchKey, title: 'Shift_l', onChange: (v) {}),
          DropdownListTile(items: switchKey, title: 'Shift_R', onChange: (v) {}),
          DropdownListTile(items: switchKey, title: 'Control_L', onChange: (v) {}),
          DropdownListTile(items: switchKey, title: 'Control_R', onChange: (v) {}),
        ],
      ),
    );
  }
}

