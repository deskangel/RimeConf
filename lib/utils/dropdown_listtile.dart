import 'package:flutter/material.dart';

class DropdownListTile extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? initValue;
  final ValueChanged? onChange;
  const DropdownListTile({
    Key? key,
    required this.title,
    required this.items,
    this.onChange,
    this.initValue,
  }) : super(key: key);

  @override
  _DropdownListTileState createState() => _DropdownListTileState();
}

class _DropdownListTileState extends State<DropdownListTile> {
  String? value;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton(
            value: value ?? widget.initValue ?? widget.items[0],
            items: widget.items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) {
              setState(() {
                value = v.toString();
              });
              if (widget.onChange != null) {
                widget.onChange!(v);
              }
            }),
      ),
    );
  }
}
