import 'package:flutter/material.dart';

class PinyinModeTab extends StatefulWidget {
  PinyinModeTab({Key? key}) : super(key: key);

  @override
  _PinyinModeTabState createState() => _PinyinModeTabState();
}

class _PinyinModeTabState extends State<PinyinModeTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    SwitchListTile(value: false, title: Text('c <=> ch'), onChanged: (value) {}),
                    SwitchListTile(value: false, title: Text('z <=> zh'), onChanged: (value) {}),
                    SwitchListTile(value: false, title: Text('s <=> sh'), onChanged: (value) {}),
                    SwitchListTile(value: false, title: Text('l <=> n'), onChanged: (value) {}),
                    SwitchListTile(value: false, title: Text('r <=> l'), onChanged: (value) {}),
                    SwitchListTile(value: false, title: Text('f <=> h'), onChanged: (value) {}),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SwitchListTile(value: false, title: Text('an <=> ang'), onChanged: (value) {}),
                    SwitchListTile(value: false, title: Text('en <=> eng'), onChanged: (value) {}),
                    SwitchListTile(value: false, title: Text('in <=> ing'), onChanged: (value) {}),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          SwitchListTile(
            value: false,
            title: Text('简拼'),
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
