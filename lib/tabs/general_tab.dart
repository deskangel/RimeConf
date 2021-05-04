import 'package:flutter/material.dart';
import 'package:rimeconf/spinner_title.dart';

class GeneralTab extends StatefulWidget {
  GeneralTab({Key? key}) : super(key: key);

  @override
  _GeneralTabState createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> {
  @override
  Widget build(BuildContext context) {
    return SpinnerTitle(title: '候选数量', value: 0, values: ['5', '6', '7', '8', '9']);
  }
}
