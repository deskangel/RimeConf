import 'package:flutter/material.dart';
import 'package:rimeconf/schema_conf.dart';
import 'package:rimeconf/utils/spinner_title.dart';
import 'package:rimeconf/utils/dropdown_listtile.dart';

class GeneralTab extends StatefulWidget {
  final SchemaConf schemaConf;
  GeneralTab({Key? key, required this.schemaConf}) : super(key: key);

  @override
  _GeneralTabState createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> {
  late final SchemaConf ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = widget.schemaConf;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpinnerTitle.list(
            initIndex: SchemaConf.CANDIDATE_COUNT.indexOf(ctrl.pageSize),
            title: '每页候选数量',
            values: ['5', '6', '7', '8', '9'],
            onChanged: (v) {
              ctrl.pageSize = v;
            },
          ),
          Text(
            '按键切换策略',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          for (var item in ctrl.switchKeys.entries)
            DropdownListTile(
              title: item.key,
              items: SchemaConf.SWITCH_KEYS,
              initValue: ctrl.convertSwitchKeyString(item.value),
              onChange: (v) => ctrl.setSwitchkey(item.key, v),
            ),

          Divider(),
          ElevatedButton(
              onPressed: () {
                ctrl.save();
              },
              child: Text('save')),
        ],
      ),
    );
  }
}
