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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () => ctrl.readConf(),
          child: Obx(() => Text('${ctrl.length.value}')),
        ),
        Text('输入方案列表：'),
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
                    title: Text(ctrl.schemeList![index]),
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
