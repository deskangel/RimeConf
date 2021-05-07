import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimeconf/schema_conf.dart';

class SwitcherTab extends StatefulWidget {
  final Schema schema;
  SwitcherTab({Key? key, required this.schema}) : super(key: key);

  @override
  _SwitcherTabState createState() => _SwitcherTabState();
}

class _SwitcherTabState extends State<SwitcherTab> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Schema>(
      init: widget.schema,
      builder: (c) {
        var schema = widget.schema;
        return ListView.separated(
            itemBuilder: (context, index) {
              var _switch = schema.switches[index];
              return SwitchListTile(
                value: _switch.reset,
                onChanged: (value) {
                  setState(() {
                    _switch.reset = value;
                  });
                  widget.schema.save();
                },
                title: Text(_switch.states),
                subtitle: Text(_switch.name),
              );
            },
            separatorBuilder: (_, __) => Divider(),
            itemCount: schema.switches.length);
      },
    );
  }
}
