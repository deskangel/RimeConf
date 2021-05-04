import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimeconf/conf_controller.dart';

class SchemeListTab extends StatefulWidget {
  SchemeListTab({Key? key}) : super(key: key);

  @override
  _SchemeListTabState createState() => _SchemeListTabState();
}

class _SchemeListTabState extends State<SchemeListTab> {
  final ConfCtrl ctrl = Get.put(ConfCtrl());

  @override
  void initState() {
    super.initState();
    ctrl.readConf();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '输入方案列表：',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GetBuilder<ConfCtrl>(
            init: ConfCtrl(),
            builder: (c) {
              return ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (_, __) => Divider(),
                itemCount: ctrl.length.value,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    minVerticalPadding: 1,
                    // contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(ctrl.schemeList![index], style: TextStyle(fontSize: 16)),
                    trailing: IconButton(
                      icon: Icon(Icons.cancel_outlined),
                      onPressed: () {
                        ctrl.remove(index);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
