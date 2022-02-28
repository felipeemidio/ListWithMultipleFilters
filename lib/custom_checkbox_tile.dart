import 'package:flutter/material.dart';

class CustomCheckboxTile extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool)? onChange;

  const CustomCheckboxTile({
    Key? key,
    required this.label,
    required this.value,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          visualDensity: VisualDensity.compact,
          value: value,
          onChanged: (_) {
            if(onChange != null) {
              onChange!(!value);
            }
          },
        ),
        Text(label),
      ],
    );
  }
}
