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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpinnerTitle(title: '候选数量', value: 0, values: ['5', '6', '7', '8', '9']),
          Text('切换'),
          SwitchListTile(title: Text('全角'), value: true, onChanged: (value){}),
        ],
      ),
    );
  }
}
