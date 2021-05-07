import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimeconf/schema_conf.dart';

import 'package:rimeconf/schema_detail_page.dart';

class SchemaListTab extends StatefulWidget {
  final SchemaConf schemaConf;

  SchemaListTab({Key? key, required this.schemaConf}) : super(key: key);

  @override
  _SchemaListTabState createState() => _SchemaListTabState();
}

class _SchemaListTabState extends State<SchemaListTab> {
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
          Text(
            '输入方案列表：',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: GetBuilder<SchemaConf>(
              init: ctrl,
              builder: (c) {
                var schemaList = ctrl.schemeList;
                return ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => Divider(),
                  itemCount: schemaList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var schema = schemaList[index];
                    return ListTile(
                      dense: true,
                      title: Text(schema.name, style: TextStyle(fontSize: 16)),
                      trailing: Switch(
                        value: schema.active,
                        onChanged: (bool value) {
                          setState(() {
                            schema.active = value;
                          });
                          ctrl.save();
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SchemeDetailPage(schema: schema,),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
