import 'package:flutter/material.dart';

///
/// @param: value, if the values array is not null, the value is an index of the element in values
///
class SpinnerTitle extends StatefulWidget {
  final String title;
  final String? subtitle;
  final int? value;
  final int? min;
  final int? max;
  final int step;
  final Widget? left;
  final Widget? right;
  final List<String>? values;
  final TextStyle? labelStyle;
  final Function? onChanged;

  SpinnerTitle({
    Key? key,
    required this.title,
    this.subtitle,
    this.value,
    this.min,
    this.max,
    this.step: 1,
    this.left,
    this.right,
    this.values,
    this.labelStyle,
    this.onChanged,
  })  : assert(!(max == null && values == null), 'max and values cannot be null at the same time.'),
        assert(!(value == null && values == null), 'value and values cannot be null at the same time.'),
        super(key: key);

  @override
  _SpinnerTitleState createState() => _SpinnerTitleState();
}

class _SpinnerTitleState extends State<SpinnerTitle> {
  late dynamic value;
  late int min;
  late int max;

  @override
  void initState() {
    super.initState();

    value = widget.value ?? widget.values![0];
    min = widget.min ?? 0;
    max = widget.max ?? (widget.values!.length - 1);
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
                if (value > min) {
                  setState(() {
                    value--;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
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
                if (value < max) {
                  setState(() {
                    value++;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
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
