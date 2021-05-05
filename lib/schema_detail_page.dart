import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimeconf/schema_conf.dart';

class SchemeDetailPage extends StatefulWidget {
  final Schema schema;
  SchemeDetailPage({Key? key, required this.schema}) : super(key: key);

  @override
  _SchemeDetailPageState createState() => _SchemeDetailPageState();
}

class _SchemeDetailPageState extends State<SchemeDetailPage> {
  @override
  void initState() {
    super.initState();

    widget.schema.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.schema.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '切换列表',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: GetBuilder<Schema>(
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
                          },
                          title: Text(_switch.name),
                        );
                      },
                      separatorBuilder: (_, __) => Divider(),
                      itemCount: schema.switches.length);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
