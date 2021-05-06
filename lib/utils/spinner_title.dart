import 'package:flutter/material.dart';

///
/// @param: value, if the values array is not null, the value is an index of the element in values
///
class SpinnerTitle extends StatefulWidget {
  final String title;
  final String? subtitle;

  late final int? value;

  final int min;
  late final int max;
  late final int? step;

  late final int initIndex;
  late final List<String> values;

  final Widget? left;
  final Widget? right;
  final TextStyle? labelStyle;
  final Function? onChanged;

  SpinnerTitle({
    Key? key,
    required this.title,
    this.subtitle,
    required this.value,
    this.min: 0,
    required this.max,
    this.step: 1,
    this.left,
    this.right,
    this.labelStyle,
    this.onChanged,
  }) : super(key: key);

  SpinnerTitle.list({
    Key? key,
    required this.title,
    this.subtitle,
    required this.initIndex,
    this.left,
    this.right,
    required this.values,
    this.labelStyle,
    this.onChanged,
  })  : min = 0,
        super(key: key) {
    max = this.values.length - 1;
    this.step = 1;
    this.value = null;
  }

  @override
  _SpinnerTitleState createState() => _SpinnerTitleState();
}

class _SpinnerTitleState extends State<SpinnerTitle> {
  late dynamic value;
  late int index;
  late final bool useList;

  @override
  void initState() {
    super.initState();

    useList = (widget.value == null);

    value = widget.value ?? widget.values[widget.initIndex];
    index = widget.initIndex;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 18),
      ),
      subtitle: widget.subtitle == null ? null : Text(widget.subtitle!),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ButtonTheme(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minWidth: 10,
            child: OutlinedButton(
              child: widget.left ?? Text('-'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.blue;
                    } else if (states.contains(MaterialState.hovered)) {
                      return Colors.blue[100];
                    }
                    return (Theme.of(context).brightness == Brightness.dark) ? Colors.white : Colors.black87;
                  },
                ),
                shape: MaterialStateProperty.all(CircleBorder()),
                side: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return BorderSide(color: Colors.blue);
                    } else if (states.contains(MaterialState.hovered)) {
                      return BorderSide(color: Colors.blue[100]!);
                    }
                    return BorderSide(color: Colors.grey[600]!);
                  },
                ),
              ),
              onPressed: () {
                if (!useList) {
                  if (value > widget.min) {
                    setState(() {
                      value--;
                    });

                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  }
                } else {
                  if (index > widget.min) {
                    index--;
                    setState(() {
                      value = widget.values[index];
                    });
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  }
                }
              },
            ),
          ),
          Container(
            // color: Colors.green,
            width: 30,
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
              style: widget.labelStyle,
            ),
          ),
          ButtonTheme(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minWidth: 10,
            child: OutlinedButton(
              child: widget.right ?? Text('+'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.blue;
                    } else if (states.contains(MaterialState.hovered)) {
                      return Colors.blue[100];
                    }
                    return (Theme.of(context).brightness == Brightness.dark) ? Colors.white : Colors.black87;
                  },
                ),
                shape: MaterialStateProperty.all(CircleBorder()),
                side: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return BorderSide(color: Colors.blue);
                    } else if (states.contains(MaterialState.hovered)) {
                      return BorderSide(color: Colors.blue[100]!);
                    }
                    return BorderSide(color: Colors.grey[600]!);
                  },
                ),
              ),
              onPressed: () {
                if (!useList) {
                  if (value < widget.max) {
                    setState(() {
                      value++;
                    });

                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  }
                } else {
                  if (index < widget.max) {
                    index++;
                    setState(() {
                      value = widget.values[index];
                    });
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
