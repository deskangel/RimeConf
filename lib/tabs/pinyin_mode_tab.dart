import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimeconf/schema_conf.dart';

class PinyinModeTab extends StatefulWidget {
  final Schema schema;

  PinyinModeTab({Key? key, required this.schema}) : super(key: key);

  @override
  _PinyinModeTabState createState() => _PinyinModeTabState();
}

class _PinyinModeTabState extends State<PinyinModeTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GetBuilder<Schema>(
          init: widget.schema,
          builder: (c) {
            var speller = widget.schema.speller;
            return ListView(
            //   crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('模糊音：', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SwitchListTile(
                              value: speller.cch,
                              title: Text('c <=> ch'),
                              onChanged: (value) {
                                setState(() {
                                  speller.cch = value;
                                });
                                widget.schema.save();
                              }),
                          SwitchListTile(
                              value: speller.ssh,
                              title: Text('s <=> sh'),
                              onChanged: (value) {
                                setState(() {
                                  speller.ssh = value;
                                });
                                widget.schema.save();
                              }),
                          SwitchListTile(
                              value: speller.zzh,
                              title: Text('z <=> zh'),
                              onChanged: (value) {
                                setState(() {
                                  speller.zzh = value;
                                });
                                widget.schema.save();
                              }),
                          SwitchListTile(
                              value: speller.ln,
                              title: Text('l <=> n'),
                              onChanged: (value) {
                                setState(() {
                                  speller.ln = value;
                                });
                                widget.schema.save();
                              }),
                          SwitchListTile(
                              value: speller.rl,
                              title: Text('r <=> l'),
                              onChanged: (value) {
                                setState(() {
                                  speller.rl = value;
                                });
                                widget.schema.save();
                              }),
                          SwitchListTile(
                              value: speller.fh,
                              title: Text('f <=> h'),
                              onChanged: (value) {
                                setState(() {
                                  speller.fh = value;
                                });
                                widget.schema.save();
                              }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          SwitchListTile(
                              value: speller.anang,
                              title: Text('an <=> ang'),
                              onChanged: (value) {
                                setState(() {
                                  speller.anang = value;
                                });
                                widget.schema.save();
                              }),
                          SwitchListTile(
                              value: speller.eneng,
                              title: Text('en <=> eng'),
                              onChanged: (value) {
                                setState(() {
                                  speller.eneng = value;
                                });
                                widget.schema.save();
                              }),
                          SwitchListTile(
                              value: speller.ining,
                              title: Text('in <=> ing'),
                              onChanged: (value) {
                                setState(() {
                                  speller.ining = value;
                                });
                                widget.schema.save();
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(),
                SwitchListTile(
                  value: speller.abbrev,
                  title: Text('简拼'),
                  onChanged: (value) {
                    setState(() {
                      speller.abbrev = value;
                    });
                    widget.schema.save();
                  },
                ),
              ],
            );
          }),
    );
  }
}
