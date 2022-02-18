import 'package:flutter/material.dart';

class CustomCheckboxTile extends StatefulWidget {
  final String label;
  final void Function(bool)? onChange;

  const CustomCheckboxTile({Key? key, required this.label, this.onChange}) : super(key: key);

  @override
  State<CustomCheckboxTile> createState() => _CustomCheckboxTileState();
}

class _CustomCheckboxTileState extends State<CustomCheckboxTile> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          visualDensity: VisualDensity.compact,
          value: checked,
          onChanged: (_) {
            setState(() {
              checked = !checked;
              if(widget.onChange != null) {
                widget.onChange!(checked);
              }
            });
          },
        ),
        Text(widget.label),
      ],
    );
  }
}
