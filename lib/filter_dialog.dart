import 'package:flutter/material.dart';
import 'package:list_with_filters/custom_checkbox_tile.dart';

const brands = [
  'Samsung',
  'Apple',
  'Xiaomi'
];

const colors = [
  'red',
  'yellow',
  'black',
  'blue',
  'white'
];

const prices = [
  'Less or equal than 100',
  'Less or equal than 500',
  'Less or equal than 1000'
];

class FilterDialog extends StatefulWidget {
  final void Function(Map<String, List<String>?>) onApplyFilters;

  const FilterDialog({Key? key, required this.onApplyFilters}) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  Map<String, List<String>?> filters = {};

  void _handleCheckFilter(bool checked, String key, String value) {
    final currentFilters = filters[key] ?? [];
    if(checked) {
      currentFilters.add(value);
    } else {
      currentFilters.remove(value);
    }
    filters[key] = currentFilters;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Filters',textAlign: TextAlign.center,),
      contentPadding: const EdgeInsets.all(16),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Select a brand'),
            ...brands.map((el) =>
                CustomCheckboxTile(
                  label: el,
                  onChange: (check) => _handleCheckFilter(check, 'brand', el),
                ),
            ).toList(),
            const Text('Select a price'),
            ...prices.map((el) =>
                CustomCheckboxTile(
                  label: el,
                  onChange: (check) => _handleCheckFilter(check, 'price', el),
                )
            ).toList(),
            const Text('Select a colors'),
            ...colors.map((el) =>
                CustomCheckboxTile(
                  label: el,
                  onChange: (check) => _handleCheckFilter(check, 'color', el),
                ),
            ).toList(),
            const SizedBox(height: 24,),
            ElevatedButton(
              onPressed: () {
                widget.onApplyFilters(filters);
                filters.clear();
                Navigator.of(context).pop();
              },
              child: const Text('APPLY'),
            ),
          ],
        ),
      ],
    );
  }
}
