// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:list_with_filters/custom_checkbox_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

List brands = [
  {'Samsung': false},
  {'Apple': false},
  {'Xiaomi': false},
];

List colors = [
  {'red': false},
  {'yellow': false},
  {'black': false},
  {'blue': false},
  {'white': false},
];

List prices = [
  {'Less or equal than 100': false},
  {'Less or equal than 500': false},
  {'Less or equal than 1000': false},
];

class FilterDialog extends StatefulWidget {
  final void Function(Map<String, List<dynamic>?>) onApplyFilters;

  const FilterDialog({Key? key, required this.onApplyFilters})
      : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  Map<String, List<dynamic>?> filters = {};
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  initState() {
    super.initState();
    loadFilter();
  }

  Future<void> addFilter(filterValue) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('filters', filterValue);
  }

  Future<void> resetFilter() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove('filters');
  }

  Future<void> loadFilter() async {
    final SharedPreferences prefs = await _prefs;
    //await prefs.remove('filters');
    final String filterPref = prefs.getString('filters') ?? "";

    if (filterPref.isNotEmpty) {
      print(filterPref);
      List<dynamic> jsonfilter = json.decode(filterPref);
      for (var element in jsonfilter) {
        (element as Map).forEach((key, value) {
          for (var e in (value as List)) {
            _handleCheckFilter(true, key, e);
          }
        });
      }
    }
  }

  _handleCheckFilter(bool checked, String key, Map el) {
    List<dynamic> currentFilters = filters[key] ?? [];
    List<Map<String, List<dynamic>?>> currentFilters2 = [];
    final subfilters = {};
    subfilters[el.keys.first] = el.values.first;
    if (checked) {
      subfilters[el.keys.first] = true;
      currentFilters.add((subfilters));
      List templist = [];
      if (key == "brand") {
        templist = brands;
      } else if (key == "price") {
        templist = prices;
      } else if (key == "color") {
        templist = colors;
      }

      int index = templist.indexWhere((element) {
        Map e = element;
        return (e.keys.first.toString() == el.keys.first.toString());
      });
      setState(() {
        templist[index][el.keys.first] = true;
      });
    } else {
      currentFilters.removeWhere(
          (element) => element.toString() == subfilters.toString());
      List templist = [];
      if (key == "brand") {
        templist = brands;
      } else if (key == "price") {
        templist = prices;
      } else if (key == "color") {
        templist = colors;
      }

      int index = templist.indexWhere((element) {
        Map e = element;
        return (e.keys.first.toString() == el.keys.first.toString());
      });
      setState(() {
        templist[index][el.keys.first] = false;
      });
    }
    filters[key] = currentFilters;
    currentFilters2.add(filters);
    addFilter(json.encode(currentFilters2));
    print(filters);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Row(
        children: [
          const Expanded(
            flex: 40,
            child: Text(
              'Filters',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 50,
            child: ElevatedButton(
              onPressed: () {
                widget.onApplyFilters(filters);
                //filters.clear();
                Navigator.of(context).pop();
              },
              child: const Text('APPLY'),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 50,
            child: ElevatedButton(
              onPressed: () async {
                print(filters);
                filters.forEach((key, value) {
                  List templist = [];
                  if (key == "brand") {
                    templist = brands;
                  } else if (key == "price") {
                    templist = prices;
                  } else if (key == "color") {
                    templist = colors;
                  }
                  for (var el in value!) {
                    int index = templist.indexWhere((element) {
                      Map e = element;
                      return (e.keys.first.toString() ==
                          el.keys.first.toString());
                    });
                    setState(() {
                      templist[index][el.keys.first] = false;
                    });
                  }
                });
                await resetFilter();
                setState(() {
                  filters.clear();
                });
                widget.onApplyFilters(filters);
              },
              child: const Text('RESET'),
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(16),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Select a brand'),
            ...brands
                .map(
                  (el) => CustomCheckboxTile(
                    label: el.keys.first,
                    onChange: (check) => _handleCheckFilter(check, 'brand', el),
                    check: el.values.first,
                  ),
                )
                .toList(),
            const Text('Select a price'),
            ...prices
                .map((el) => CustomCheckboxTile(
                      label: el.keys.first,
                      onChange: (check) =>
                          _handleCheckFilter(check, 'price', el),
                      check: el.values.first,
                    ))
                .toList(),
            const Text('Select a colors'),
            ...colors
                .map(
                  (el) => CustomCheckboxTile(
                    label: el.keys.first,
                    onChange: (check) => _handleCheckFilter(check, 'color', el),
                    check: el.values.first,
                  ),
                )
                .toList(),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: () {
                widget.onApplyFilters(filters);
                //filters.clear();
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
