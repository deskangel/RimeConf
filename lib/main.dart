import 'package:flutter/material.dart';
import 'package:rimeconf/tabs/general_tab.dart';
import 'package:rimeconf/tabs/scheme_list_tab.dart';

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

  static const TABS = ['通用', '方案列表'];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: TABS.length,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              tabs: [
                for (var tab in TABS) Tab(text: tab),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  GeneralTab(),
                  SchemaListTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
