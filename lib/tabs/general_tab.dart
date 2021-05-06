import 'package:flutter/material.dart';
import 'package:rimeconf/spinner_title.dart';

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
          SpinnerTitle(title: '候选数量', value: 0, values: ['5', '6', '7', '8', '9']),
          Text(
            '切换',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: Text('按键策略：'),
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: switchKey[0],
                items: switchKey.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
