import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimeconf/conf_controller.dart';
import 'package:rimeconf/spinner_title.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rime Configuration Tool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final ConfCtrl ctrl = Get.put(ConfCtrl());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Clicked: ${ctrl.count}')),
      ),
      body: Column(
        children: [
          SpinnerTitle(title: '候选数量', value: 0, values: ['5', '6', '7', '8', '9']),
          ElevatedButton(
            onPressed: () => ctrl.readConf(),
            child: Obx(() => Text('${ctrl.length.value}')),
          ),
          GetBuilder<ConfCtrl>(
            init: ConfCtrl(),
            builder: (c) {
              return Text(ctrl.count.toString());
            },
          ),
          Expanded(
            child: GetBuilder<ConfCtrl>(
              init: ConfCtrl(),
              builder: (c) {
                return ListView.builder(
                    itemCount: ctrl.length.value,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(title: Obx(() => Text(ctrl.schemeList![index])));
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
