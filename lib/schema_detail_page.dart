import 'package:flutter/material.dart';
import 'package:rimeconf/schema_conf.dart';
import 'package:rimeconf/tabs/switcher_tab.dart';

import 'tabs/pinyin_mode_tab.dart';

class SchemeDetailPage extends StatefulWidget {
  final Schema schema;
  SchemeDetailPage({Key? key, required this.schema}) : super(key: key);

  @override
  _SchemeDetailPageState createState() => _SchemeDetailPageState();
}

class _SchemeDetailPageState extends State<SchemeDetailPage> {
  static const TABS = ['切换列表', '拼音模式'];

  @override
  void initState() {
    super.initState();

    widget.schema.load();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: TABS.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.schema.name),
          bottom: TabBar(
            tabs: [
              for (var tab in TABS) Tab(text: tab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SwitcherTab(schema: widget.schema),
            PinyinModeTab(),
          ],
        ),
      ),
    );
  }
}
